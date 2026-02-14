open! Core
open! Dsl_import
include Dsl_types
module Type_repr = Type_repr_gen

module Atom = struct
  type _ t = Typed_var.t Ir.Lit_or_var.t

  let lit_or_var t = t

  let var t =
    match (t : Typed_var.t Ir.Lit_or_var.t) with
    | Var v -> Some v
    | Global _ | Lit _ -> None
  ;;

  let type_ t =
    match (t : Typed_var.t Ir.Lit_or_var.t) with
    | Var v -> v.type_
    | Lit _ -> Type.I64
    | Global g -> g.type_
  ;;
end

module Instr = struct
  type 'a t =
    | Ir : (Typed_var.t, string) Nod_ir.Ir.t -> 'a t
    | Label : string -> 'a t
  [@@deriving variants]

  let ir ir0 = Ir ir0

  let process ?(root_name = "%entry") ts =
    let labels = Nod_vec.create () in
    let instrs = Nod_vec.create () in
    let end_this_label current_label instrs_by_label =
      if Nod_vec.length instrs = 0
      then Map.remove instrs_by_label current_label
      else (
        Nod_vec.push labels current_label;
        let instrs_in_map = Map.find_exn instrs_by_label current_label in
        Nod_vec.switch instrs_in_map instrs;
        instrs_by_label)
    in
    let instrs_by_label =
      Map.set String.Map.empty ~key:root_name ~data:(Nod_vec.create ())
    in
    let rec go current_label instrs_by_label ts =
      match ts with
      | [] -> Ok (~current_label, ~instrs_by_label)
      | Ir ir :: rest ->
        Nod_vec.push instrs ir;
        go current_label instrs_by_label rest
      | Label new_label :: rest ->
        if Map.mem instrs_by_label new_label
        then Error (`Duplicate_label new_label)
        else (
          let instrs_by_label = end_this_label current_label instrs_by_label in
          let instrs_by_label =
            Map.set instrs_by_label ~key:new_label ~data:(Nod_vec.create ())
          in
          go new_label instrs_by_label rest)
    in
    match go root_name instrs_by_label ts with
    | Error _ as res -> res
    | Ok (~current_label, ~instrs_by_label) ->
      let instrs_by_label = end_this_label current_label instrs_by_label in
      Ok (~instrs_by_label, ~labels)
  ;;
end

module Fn = struct
  module Unnamed = struct
    type ('fn, 'ret) t =
      { args : Typed_var.t list
      ; ret : Type.t
      ; instrs : 'ret Instr.t list
      }

    let args t = t.args
    let ret t = t.ret
    let instrs t = t.instrs

    let const type_repr instrs =
      { args = []; ret = Type_repr.type_ type_repr; instrs }
    ;;

    let const_with_return ret instrs =
      { args = []; ret = Atom.type_ ret; instrs }
    ;;

    let with_arg
      (type fn ret arg)
      ({ args; ret; instrs } : (fn, ret) t)
      type_repr
      var
      : (arg -> fn, ret) t
      =
      let expected = Type_repr.type_ type_repr in
      if not (Type.equal expected (Typed_var.type_ var))
      then
        failwithf
          "Fn.Unnamed.with_arg expected %s but got %s"
          (Type.to_string expected)
          (Type.to_string (Typed_var.type_ var))
          ();
      { args = var :: args; ret; instrs }
    ;;
  end

  type ('fn, 'ret) t =
    { name : string
    ; unnamed : ('fn, 'ret) Unnamed.t
    }

  let name t = t.name
  let unnamed t = t.unnamed
  let create ~unnamed ~name = { name; unnamed }
  let renamed ~name { name = _; unnamed } = { name; unnamed }

  let external_ ~name ~args ~ret =
    let ret_type = ret in
    let args_vars =
      List.mapi args ~f:(fun i type_ ->
        Typed_var.create ~name:(sprintf "arg%d" i) ~type_)
    in
    let unnamed = Unnamed.{ args = args_vars; ret = ret_type; instrs = [] } in
    { name; unnamed }
  ;;

  let function_ t =
    let open Result.Let_syntax in
    let%map root = Instr.process t.unnamed.instrs in
    Function.create ~name:t.name ~args:t.unnamed.args ~root
  ;;

  module Packed = struct
    type nonrec ('fn, 'ret) outer = ('fn, 'ret) t
    type t = T : (_, _) outer -> t
  end

  let pack t : Packed.t = T t
end

let program ~functions ~globals =
  let open Result.Let_syntax in
  let fn_results =
    List.map functions ~f:(fun (function_ : Fn.Packed.t) ->
      match function_ with
      | Fn.Packed.T fn ->
        let%map fn_value = Fn.function_ fn in
        Fn.name fn, fn_value)
  in
  let%bind functions = Result.all fn_results in
  match String.Map.of_alist functions with
  | `Ok functions -> Ok { Program.globals; functions }
  | `Duplicate_key dup ->
    Error (`Type_mismatch (sprintf "duplicate function %s" dup))
;;

let return (type a) (value : a Atom.t) : a Instr.t =
  Instr.ir (Nod_ir.Ir.Return (Atom.lit_or_var value))
;;

let label name = Instr.Label name
let lit value : int64 Atom.t = Ir.Lit_or_var.Lit value
let var v : 'a Atom.t = Ir.Lit_or_var.Var v
let global g : _ ptr Atom.t = Ir.Lit_or_var.Global g
let make_dest name type_ = Typed_var.create ~name ~type_
let atom_of_var var : _ Atom.t = Ir.Lit_or_var.Var var
let mem_address ?offset ptr = Nod_ir.Mem.address ?offset (Atom.lit_or_var ptr)

let binary name type_ lhs rhs ctor =
  let dest = make_dest name type_ in
  let instr =
    ctor
      { Nod_ir.Ir_helpers.dest
      ; Nod_ir.Ir_helpers.src1 = Atom.lit_or_var lhs
      ; Nod_ir.Ir_helpers.src2 = Atom.lit_or_var rhs
      }
    |> Instr.ir
  in
  atom_of_var dest, instr
;;

let mov name src =
  let dest = make_dest name (Atom.type_ src) in
  let instr = Instr.ir (Nod_ir.Ir.Move (dest, Atom.lit_or_var src)) in
  atom_of_var dest, instr
;;

let add name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.add
let sub name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.sub
let mul name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.mul
let div name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.div
let mod_ name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.mod_
let and_ name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.and_
let or_ name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.or_
let lt name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.lt

let ptr_add name base offset =
  binary name (Atom.type_ base) base offset Nod_ir.Ir.add
;;

let ptr_sub name base offset =
  binary name (Atom.type_ base) base offset Nod_ir.Ir.sub
;;

let ptr_diff name lhs rhs = binary name Type.I64 lhs rhs Nod_ir.Ir.sub
let fadd name lhs rhs = binary name Type.F64 lhs rhs Nod_ir.Ir.fadd
let fsub name lhs rhs = binary name Type.F64 lhs rhs Nod_ir.Ir.fsub
let fmul name lhs rhs = binary name Type.F64 lhs rhs Nod_ir.Ir.fmul
let fdiv name lhs rhs = binary name Type.F64 lhs rhs Nod_ir.Ir.fdiv

let load_mem ?(offset = 0) name ptr type_ =
  let dest = make_dest name type_ in
  let instr = Instr.ir (Nod_ir.Ir.Load (dest, mem_address ~offset ptr)) in
  atom_of_var dest, instr
;;

let load name ptr = load_mem name ptr Type.I64
let load_ptr name ptr = load_mem name ptr Type.Ptr
let load_f64 name ptr = load_mem name ptr Type.F64
let load_addr name ptr offset = load_mem ~offset name ptr Type.I64
let load_addr_ptr name ptr offset = load_mem ~offset name ptr Type.Ptr
let load_addr_f64 name ptr offset = load_mem ~offset name ptr Type.F64

let store value ptr =
  Instr.ir (Nod_ir.Ir.Store (Atom.lit_or_var value, mem_address ptr))
;;

let store_addr value ptr offset =
  Instr.ir (Nod_ir.Ir.Store (Atom.lit_or_var value, mem_address ~offset ptr))
;;

let alloca name size =
  let dest = make_dest name Type.Ptr in
  let instr =
    Instr.ir
      (Nod_ir.Ir.Alloca
         { Nod_ir.Ir_helpers.dest
         ; Nod_ir.Ir_helpers.size = Atom.lit_or_var size
         })
  in
  atom_of_var dest, instr
;;

let cast name type_ src =
  let dest = make_dest name type_ in
  let instr = Instr.ir (Nod_ir.Ir.Cast (dest, Atom.lit_or_var src)) in
  atom_of_var dest, instr
;;

let call_common name fn args =
  let dest = make_dest name (Fn.Unnamed.ret (Fn.unnamed fn)) in
  let instr =
    Instr.ir
      (Nod_ir.Ir.Call
         { callee = Nod_ir.Ir.Call_callee.Direct (Fn.name fn)
         ; results = [ dest ]
         ; args = List.map args ~f:Atom.lit_or_var
         })
  in
  atom_of_var dest, instr
;;

let call0 name (fn : ('ret, 'ret) Fn.t) = call_common name fn []

let call1 name (fn : ('a -> 'ret, 'ret) Fn.t) (arg : 'a Atom.t) =
  call_common name fn [ arg ]
;;

let call2
  name
  (fn : ('a -> 'b -> 'ret, 'ret) Fn.t)
  (arg1 : 'a Atom.t)
  (arg2 : 'b Atom.t)
  =
  call_common name fn [ arg1; arg2 ]
;;

let call3
  name
  (fn : ('a -> 'b -> 'c -> 'ret, 'ret) Fn.t)
  (arg1 : 'a Atom.t)
  (arg2 : 'b Atom.t)
  (arg3 : 'c Atom.t)
  =
  call_common name fn [ arg1; arg2; arg3 ]
;;

let branch_to cond ~if_true ~if_false =
  Instr.ir
    (Nod_ir.Ir.Branch
       (Nod_ir.Branch.Cond
          { cond = Atom.lit_or_var cond
          ; if_true = Call_block.{ block = if_true; args = [] }
          ; if_false = Call_block.{ block = if_false; args = [] }
          }))
;;

let jump_to label = Instr.ir (Nod_ir.Ir.jump_to label)

let compile_program_exn' program =
  match
    Result.bind program ~f:(Eir.compile ~opt_flags:Eir.Opt_flags.no_opt)
  with
  | Ok program -> program
  | Error err -> Nod_error.to_string err |> failwith
;;

let compile_program_exn program =
  match Eir.compile ~opt_flags:Eir.Opt_flags.no_opt program with
  | Ok program -> program
  | Error err -> Nod_error.to_string err |> failwith
;;

module Field = struct
  type ('record, 'field, 'type_info, 'kind) t =
    { repr : 'field Type_repr.t
    ; name : string
    ; index : int
    ; type_info : 'type_info
    ; record_repr : 'record Type_repr.t
    }

  type 'a field_access =
    { always_have : 'a
    ; type_ : Nod_common.Type.t option
    ; indices : int list
    }

  let create_field_access always_have =
    { always_have; type_ = None; indices = [] }
  ;;

  module Loader = struct
    type 'field t = string field_access

    let dest = create_field_access
  end

  module Storer = struct
    type ('field, 'record) t = 'field Atom.t field_access

    let src = create_field_access
  end

  let inter loader t =
    { loader with
      type_ =
        (match loader.type_ with
         | None -> Some (Type_repr.type_ t.record_repr)
         | Some _ as x -> x)
    ; indices = loader.indices @ [ t.index ]
    }
  ;;

  let load_record = inter
  let store_record = inter

  let load_immediate (loader : _ Loader.t) t base =
    let dest =
      Typed_var.create ~name:loader.always_have ~type_:(Type_repr.type_ t.repr)
    in
    let instr =
      Nod_ir.Ir.Load_field
        { dest
        ; base = Atom.lit_or_var base
        ; type_ =
            (match loader.type_ with
             | None -> Type_repr.type_ t.record_repr
             | Some type_ -> type_)
        ; indices = loader.indices @ [ t.index ]
        }
    in
    var dest, Instr.ir instr
  ;;

  let store_immediate (storer : _ Storer.t) t base =
    let instr =
      Nod_ir.Ir.Store_field
        { src = storer.always_have
        ; base = Atom.lit_or_var base
        ; type_ =
            (match storer.type_ with
             | None -> Type_repr.type_ t.record_repr
             | Some type_ -> type_)
        ; indices = storer.indices @ [ t.index ]
        }
    in
    Instr.ir instr
  ;;
end
