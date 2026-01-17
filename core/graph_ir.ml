open! Core

(* Value-based SSA IR with explicit use-def chains and intrusive linked lists.

   This IR is designed to make optimizations easier:
   - Values are first-class entities with explicit use-def chains
   - Instructions form doubly-linked lists for O(1) insertion/deletion
   - CFG edges carry block arguments explicitly
   - Clear separation between values, instructions, and control flow
*)

(* ===== Value IDs ===== *)

module Value_id = struct
  type t = int [@@deriving sexp, compare, hash, equal]

  include Comparable.Make (struct
    type nonrec t = t [@@deriving sexp, compare]
  end)

  include Hashable.Make (struct
    type nonrec t = t [@@deriving sexp, compare, hash]
  end)

  let to_string = Int.to_string
end

(* ===== Forward declarations ===== *)

module rec Value : sig
  type t =
    { id : Value_id.t
    ; type_ : Type.t
    ; mutable def : def_site
    ; mutable uses : use_site list
    }
  [@@deriving fields]

  and def_site =
    | Instr_result of Instr.t * int (* instruction + result index *)
    | Block_arg of Block.t * int (* block parameter + index *)
    | Undef (* undefined/uninitialized *)

  and use_site =
    { instr : Instr.t
    ; operand_idx : int
    }

  val create : id:Value_id.t -> type_:Type.t -> def:def_site -> t
  val replace_all_uses_with : t -> t -> unit
  val has_uses : t -> bool
  val num_uses : t -> int
  val add_use : t -> use_site -> unit
  val remove_use : t -> Instr.t -> unit
end = struct
  type t =
    { id : Value_id.t
    ; type_ : Type.t
    ; mutable def : def_site
    ; mutable uses : use_site list
    }
  [@@deriving fields]

  and def_site =
    | Instr_result of Instr.t * int
    | Block_arg of Block.t * int
    | Undef

  and use_site =
    { instr : Instr.t
    ; operand_idx : int
    }

  let create ~id ~type_ ~def = { id; type_; def; uses = [] }

  let replace_all_uses_with old_val new_val =
    if phys_equal old_val new_val
    then ()
    else (
      List.iter old_val.uses ~f:(fun use ->
        use.instr.operands.(use.operand_idx) <- new_val);
      new_val.uses <- old_val.uses @ new_val.uses;
      old_val.uses <- [])
  ;;

  let has_uses t = not (List.is_empty t.uses)
  let num_uses t = List.length t.uses
  let add_use t use = t.uses <- use :: t.uses

  let remove_use t instr =
    t.uses <- List.filter t.uses ~f:(fun use -> not (phys_equal use.instr instr))
  ;;
end

and Instr : sig
  type t =
    { id : int
    ; mutable opcode : opcode
    ; mutable operands : Value.t array
    ; mutable results : Value.t array
    ; mutable block : Block.t option
    ; mutable next : t option
    ; mutable prev : t option
    }
  [@@deriving fields]

  and opcode =
    (* Binary arithmetic *)
    | Add
    | Sub
    | Mul
    | Div
    | Mod
    | Lt
    | And
    | Or
    (* Floating point *)
    | Fadd
    | Fsub
    | Fmul
    | Fdiv
    (* Memory *)
    | Load of Ir0.Mem.t
    | Store of Ir0.Mem.t
    | Alloca
    (* Atomics *)
    | Atomic_load of Ir0.Mem.t * Ir0.Memory_order.t
    | Atomic_store of Ir0.Mem.t * Ir0.Memory_order.t
    | Atomic_rmw of Ir0.Mem.t * Ir0.Rmw_op.t * Ir0.Memory_order.t
    | Atomic_cmpxchg of
        { addr : Ir0.Mem.t
        ; success_order : Ir0.Memory_order.t
        ; failure_order : Ir0.Memory_order.t
        }
    (* Type conversions *)
    | Cast of Type.t
    | Move
    (* Calls *)
    | Call of string

  val create
    :  id:int
    -> opcode:opcode
    -> operands:Value.t array
    -> results:Value.t array
    -> t

  val insert_after : after:t -> t -> unit
  val insert_before : before:t -> t -> unit
  val remove : t -> unit
  val has_side_effects : t -> bool
  val is_pure : t -> bool
  val replace_operand : t -> int -> Value.t -> unit
end = struct
  type t =
    { id : int
    ; mutable opcode : opcode
    ; mutable operands : Value.t array
    ; mutable results : Value.t array
    ; mutable block : Block.t option
    ; mutable next : t option
    ; mutable prev : t option
    }
  [@@deriving fields]

  and opcode =
    | Add
    | Sub
    | Mul
    | Div
    | Mod
    | Lt
    | And
    | Or
    | Fadd
    | Fsub
    | Fmul
    | Fdiv
    | Load of Ir0.Mem.t
    | Store of Ir0.Mem.t
    | Alloca
    | Atomic_load of Ir0.Mem.t * Ir0.Memory_order.t
    | Atomic_store of Ir0.Mem.t * Ir0.Memory_order.t
    | Atomic_rmw of Ir0.Mem.t * Ir0.Rmw_op.t * Ir0.Memory_order.t
    | Atomic_cmpxchg of
        { addr : Ir0.Mem.t
        ; success_order : Ir0.Memory_order.t
        ; failure_order : Ir0.Memory_order.t
        }
    | Cast of Type.t
    | Move
    | Call of string

  let create ~id ~opcode ~operands ~results =
    { id; opcode; operands; results; block = None; next = None; prev = None }
  ;;

  let insert_after ~after instr =
    instr.prev <- Some after;
    instr.next <- after.next;
    (match after.next with
     | Some next -> next.prev <- Some instr
     | None ->
       (match after.block with
        | Some block -> block.last_instr <- Some instr
        | None -> ()));
    after.next <- Some instr;
    instr.block <- after.block
  ;;

  let insert_before ~before instr =
    instr.next <- Some before;
    instr.prev <- before.prev;
    (match before.prev with
     | Some prev -> prev.next <- Some instr
     | None ->
       (match before.block with
        | Some block -> block.first_instr <- Some instr
        | None -> ()));
    before.prev <- Some instr;
    instr.block <- before.block
  ;;

  let remove instr =
    (match instr.prev with
     | Some prev -> prev.next <- instr.next
     | None ->
       (match instr.block with
        | Some block -> block.first_instr <- instr.next
        | None -> ()));
    (match instr.next with
     | Some next -> next.prev <- instr.prev
     | None ->
       (match instr.block with
        | Some block -> block.last_instr <- instr.prev
        | None -> ()));
    instr.block <- None;
    instr.next <- None;
    instr.prev <- None
  ;;

  let has_side_effects = function
    | { opcode = Store _ | Call _ | Atomic_store _ | Atomic_rmw _ | Atomic_cmpxchg _; _ } -> true
    | _ -> false
  ;;

  let is_pure instr = not (has_side_effects instr)

  let replace_operand instr idx new_val =
    let old_val = instr.operands.(idx) in
    if not (phys_equal old_val new_val)
    then (
      (* Remove old use *)
      old_val.uses
      <- List.filter old_val.uses ~f:(fun use ->
        not (phys_equal use.instr instr && use.operand_idx = idx));
      (* Add new use *)
      new_val.uses <- { instr; operand_idx = idx } :: new_val.uses;
      instr.operands.(idx) <- new_val)
  ;;
end

and Block : sig
  type t =
    { id : int
    ; id_hum : string
    ; mutable args : Value.t array
    ; mutable first_instr : Instr.t option
    ; mutable last_instr : Instr.t option
    ; mutable terminator : terminator
    ; mutable predecessors : t list
    ; mutable successors : successor list
    ; mutable dom_tree_parent : t option
    ; mutable dom_tree_children : t list
    ; mutable dom_frontier : t list
    }
  [@@deriving fields]

  and terminator =
    | Branch of
        { cond : Value.t option
        ; true_target : successor
        ; false_target : successor option
        }
    | Return of Value.t option
    | Unreachable

  and successor =
    { target : t
    ; args : Value.t array
    }

  val create : id:int -> id_hum:string -> t
  val add_instr : t -> Instr.t -> unit
  val iter_instrs : t -> f:(Instr.t -> unit) -> unit
  val fold_instrs : t -> init:'a -> f:('a -> Instr.t -> 'a) -> 'a
end = struct
  type t =
    { id : int
    ; id_hum : string
    ; mutable args : Value.t array
    ; mutable first_instr : Instr.t option
    ; mutable last_instr : Instr.t option
    ; mutable terminator : terminator
    ; mutable predecessors : t list
    ; mutable successors : successor list
    ; mutable dom_tree_parent : t option
    ; mutable dom_tree_children : t list
    ; mutable dom_frontier : t list
    }
  [@@deriving fields]

  and terminator =
    | Branch of
        { cond : Value.t option
        ; true_target : successor
        ; false_target : successor option
        }
    | Return of Value.t option
    | Unreachable

  and successor =
    { target : t
    ; args : Value.t array
    }

  let create ~id ~id_hum =
    { id
    ; id_hum
    ; args = [||]
    ; first_instr = None
    ; last_instr = None
    ; terminator = Unreachable
    ; predecessors = []
    ; successors = []
    ; dom_tree_parent = None
    ; dom_tree_children = []
    ; dom_frontier = []
    }
  ;;

  let add_instr block instr =
    match block.last_instr with
    | None ->
      block.first_instr <- Some instr;
      block.last_instr <- Some instr;
      instr.block <- Some block
    | Some last -> Instr.insert_after ~after:last instr
  ;;

  let iter_instrs block ~f =
    let rec loop = function
      | None -> ()
      | Some instr ->
        f instr;
        loop (Instr.next instr)
    in
    loop block.first_instr
  ;;

  let fold_instrs block ~init ~f =
    let rec loop acc = function
      | None -> acc
      | Some instr -> loop (f acc instr) (Instr.next instr)
    in
    loop init block.first_instr
  ;;
end

(* ===== Function representation ===== *)

module Func = struct
  type t =
    { name : string
    ; mutable params : Value.t array
    ; mutable return_type : Type.t
    ; mutable entry_block : Block.t
    ; mutable blocks : Block.t list
    ; mutable next_value_id : int
    ; mutable next_instr_id : int
    ; value_table : Value.t Int.Table.t
    }

  let create ~name ~return_type =
    let entry_block = Block.create ~id:0 ~id_hum:"entry" in
    { name
    ; params = [||]
    ; return_type
    ; entry_block
    ; blocks = [ entry_block ]
    ; next_value_id = 0
    ; next_instr_id = 0
    ; value_table = Int.Table.create ()
    }
  ;;

  let fresh_value t ~type_ ~def =
    let id = t.next_value_id in
    t.next_value_id <- id + 1;
    let value = Value.create ~id ~type_ ~def in
    Hashtbl.set t.value_table ~key:id ~data:value;
    value
  ;;

  let fresh_instr t ~opcode ~operands ~result_types =
    let id = t.next_instr_id in
    t.next_instr_id <- id + 1;
    let instr = Instr.create ~id ~opcode ~operands ~results:[||] in
    let results =
      Array.mapi result_types ~f:(fun idx type_ ->
        fresh_value t ~type_ ~def:(Instr_result (instr, idx)))
    in
    instr.results <- results;
    (* Register uses *)
    Array.iteri operands ~f:(fun operand_idx operand ->
      operand.uses <- { instr; operand_idx } :: operand.uses);
    instr
  ;;

  let iter_blocks t ~f = List.iter t.blocks ~f
  let iter_instrs t ~f = iter_blocks t ~f:(fun block -> Block.iter_instrs block ~f)
end

(* ===== Optimization utilities ===== *)

module Opt = struct
  (* Dead code elimination *)
  let dce (func : Func.t) =
    let changed = ref true in
    while !changed do
      changed := false;
      Func.iter_blocks func ~f:(fun block ->
        let rec scan = function
          | None -> ()
          | Some instr ->
            let next = Instr.next instr in
            if (not (Instr.has_side_effects instr))
               && Array.for_all (Instr.results instr) ~f:(fun v -> not (Value.has_uses v))
            then (
              (* Remove uses *)
              Array.iter (Instr.operands instr) ~f:(fun operand ->
                Value.remove_use operand instr);
              Instr.remove instr;
              changed := true);
            scan next
        in
        scan (Block.first_instr block))
    done
  ;;

  (* Constant folding - stub for now *)
  let const_fold (_func : Func.t) =
    (* TODO: Implement constant folding with proper constant representation *)
    ()
  ;;
end
