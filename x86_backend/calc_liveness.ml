open! Core
open! Import
open! Common

module type Arg = sig
  type t

  val uses_of_ir : Ir.t -> t list
  val defs_of_ir : Ir.t -> t list
  val t_of_var : Var.t -> t option
  val t_of_id : int -> t
  val id_of_t : t -> int
end

module type S = sig
  module Arg : Arg

  module Liveness : sig
    type t =
      { live_in : Int.Set.t
      ; live_out : Int.Set.t
      }
    [@@deriving fields, equal, compare, sexp]

    val live_in' : t -> Arg.t list
    val live_out' : t -> Arg.t list
    val empty : t
  end

  module Liveness_state : sig
    type block_liveness =
      { mutable instructions : Liveness.t Vec.t
      ; mutable terminal : Liveness.t
      ; mutable overall : Liveness.t
      ; defs : Int.Set.t
      ; uses : Int.Set.t
      }
    [@@deriving fields, sexp]

    type t [@@deriving sexp]

    val block_liveness : t -> Block.t -> block_liveness
    val create : root:Block.t -> t

    val block_instructions_with_liveness
      :  t
      -> block:Block.t
      -> instructions:(Ir.t * Liveness.t) list * terminal:(Ir.t * Liveness.t)
  end
end

module Make (Arg : Arg) = struct
  module Arg = Arg

  module Liveness = struct
    type t =
      { live_in : Int.Set.t
      ; live_out : Int.Set.t
      }
    [@@deriving fields, equal, compare, sexp]

    let live_in' { live_in; _ } = Set.to_list live_in |> List.map ~f:Arg.t_of_id

    let live_out' { live_out; _ } =
      Set.to_list live_out |> List.map ~f:Arg.t_of_id
    ;;

    let empty = { live_in = Int.Set.empty; live_out = Int.Set.empty }
  end

  module Liveness_state = struct
    type block_liveness =
      { mutable instructions : Liveness.t Vec.t
      ; mutable terminal : Liveness.t
      ; mutable overall : Liveness.t
      ; defs : Int.Set.t
      ; uses : Int.Set.t
      }
    [@@deriving fields, sexp]

    type t = { blocks : block_liveness Block.Table.t } [@@deriving fields, sexp]

    let block_liveness t block = Hashtbl.find_exn t.blocks block

    let uses_of_ir ir =
      Arg.uses_of_ir ir |> List.map ~f:Arg.id_of_t |> Int.Set.of_list
    ;;

    let defs_of_ir ir =
      Arg.defs_of_ir ir |> List.map ~f:Arg.id_of_t |> Int.Set.of_list
    ;;

    (* uses = uses that aren't yet defined in block *)
    let defs_and_uses ~(block : Block.t) =
      let f (~defs, ~uses) (ir : Ir.t) =
        let new_uses = Set.diff (uses_of_ir ir) defs in
        let uses = Set.union uses new_uses in
        let defs = Set.union defs (defs_of_ir ir) in
        ~defs, ~uses
      in
      let uses =
        List.filter_map
          (Vec.to_list block.args)
          ~f:(Arg.t_of_var >> Option.map ~f:Arg.id_of_t)
        |> Int.Set.of_list
      in
      let acc =
        Vec.fold block.instructions ~init:(~defs:Int.Set.empty, ~uses) ~f
      in
      f acc block.terminal
    ;;

    let calculate_intra_block_liveness t root =
      Block.iter root ~f:(fun block ->
        let block_liveness = block_liveness t block in
        let f ({ live_in; _ } : Liveness.t) ir =
          let new_live_in =
            Set.union (uses_of_ir ir) (Set.diff live_in (defs_of_ir ir))
          in
          { Liveness.live_in = new_live_in; live_out = live_in }
        in
        block_liveness.terminal <- f block_liveness.overall block.terminal;
        (* prob unnecessary *)
        Vec.clear block_liveness.instructions;
        let (_ : Liveness.t) =
          Vec.foldr
            block.instructions
            ~init:block_liveness.terminal
            ~f:(fun liveness ir ->
              let liveness = f liveness ir in
              Vec.push block_liveness.instructions liveness;
              liveness)
        in
        Vec.reverse_inplace block_liveness.instructions)
    ;;

    let initialize_block_liveness t block =
      let ~defs, ~uses = defs_and_uses ~block in
      Hashtbl.set
        t.blocks
        ~key:block
        ~data:
          { instructions = Vec.create ()
          ; terminal = Liveness.empty
          ; overall = Liveness.empty
          ; defs
          ; uses
          }
    ;;

    let calculate_block_liveness t root =
      let worklist = Queue.create () in
      Block.iter root ~f:(Queue.enqueue worklist);
      while not (Queue.is_empty worklist) do
        let block = Queue.dequeue_exn worklist in
        (* live_out[b] = U LIVE_IN[succ] *)
        let new_live_out =
          block.children
          |> Vec.to_list
          |> List.map ~f:(fun block ->
            block_liveness t block |> overall |> Liveness.live_in)
          |> Int.Set.union_list
        in
        (* live_in[b] = use U (live_out / def) *)
        let new_live_in =
          Set.union
            (block_liveness t block).uses
            (Set.diff new_live_out (block_liveness t block).defs)
        in
        let new_liveness =
          { Liveness.live_in = new_live_in; live_out = new_live_out }
        in
        if not (Liveness.equal new_liveness (block_liveness t block).overall)
        then (
          (block_liveness t block).overall <- new_liveness;
          (* only needs pred blocks but cbf to compute *)
          Block.iter root ~f:(Queue.enqueue worklist))
      done
    ;;

    let create ~root =
      let t = { blocks = Block.Table.create () } in
      Block.iter root ~f:(initialize_block_liveness t);
      calculate_block_liveness t root;
      calculate_intra_block_liveness t root;
      t
    ;;

    let block_instructions_with_liveness t ~(block : Block.t) =
      let block_liveness = block_liveness t block in
      let instructions =
        List.zip_exn
          (Vec.to_list block.instructions)
          (Vec.to_list block_liveness.instructions)
      in
      let terminal = block.terminal, block_liveness.terminal in
      ~instructions, ~terminal
    ;;
  end
end

let var ~reg_numbering =
  (module Make (struct
      type t = Var.t

      let uses_of_ir = Ir.uses
      let defs_of_ir = Ir.defs
      let t_of_var = Option.return
      let t_of_id = Reg_numbering.id_var reg_numbering
      let id_of_t = Reg_numbering.var_id reg_numbering
    end) : S
    with type Arg.t = Var.t)
;;
