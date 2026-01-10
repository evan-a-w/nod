open! Core
open! Nod_core
module L = Ir.Lit_or_var

type int64
type int32
type int16
type int8
type float64
type float32
type ptr

type i64 = int64
type i32 = int32
type i16 = int16
type i8 = int8
type f64 = float64
type f32 = float32

module Atom = struct
  type 'a t = Ir.Lit_or_var.t
end

module Fn = struct
  type ('args, 'ret) t =
    { name : string
    ; args : Type.t list
    ; returns : Type.t list
    ; body : Function.t option
    }

  let name t = t.name
  let function_exn t = Option.value_exn t.body
  let functions fns = List.filter_map fns ~f:(fun fn -> fn.body)
  let external_ ~name ~args ~returns = { name; args; returns; body = None }

  let infer_returns fn =
    let types = ref [] in
    Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ());
    Block.iter_instructions (Function.root fn) ~f:(function
      | Ir.Return value -> types := value :: !types
      | _ -> ());
    match !types with
    | [] -> []
    | value :: rest ->
      let type_of = function
        | L.Lit _ -> Type.I64
        | L.Var v -> Var.type_ v
        | L.Global g -> Type.Ptr_typed g.Global.type_
      in
      let value_type = type_of value in
      let consistent =
        List.for_all rest ~f:(fun other ->
          Type.equal (type_of other) value_type)
      in
      if consistent
      then [ value_type ]
      else failwith "function returns multiple incompatible types"
  ;;

  let of_function fn =
    let args = List.map fn.Function.args ~f:Var.type_ in
    let returns = infer_returns fn in
    { name = fn.Function.name; args; returns; body = Some fn }
  ;;
end

let current_builder : Ir_builder.t option ref = ref None

let with_builder builder f =
  let prev = !current_builder in
  current_builder := Some builder;
  Exn.protect ~f ~finally:(fun () -> current_builder := prev)
;;

let builder_exn () =
  match !current_builder with
  | Some builder -> builder
  | None -> failwith "Dsl.with_builder is not set"
;;

let type_of_atom = function
  | L.Lit _ -> Type.I64
  | L.Var v -> Var.type_ v
  | L.Global g -> Type.Ptr_typed g.Global.type_
;;

let ptr_type_of_atom = function
  | L.Var v -> Var.type_ v
  | L.Global g -> Type.Ptr_typed g.Global.type_
  | L.Lit _ -> failwith "pointer literals are not supported"
;;

let atom_of_var v = L.Var v

let new_var ~name ~type_ =
  Ir_builder.new_var (builder_exn ()) ~name ~type_
;;

let emit instr = Ir_builder.emit (builder_exn ()) instr

(* Atom constructors *)
let lit i = L.Lit i
let var v = L.Var v
let global g = L.Global g

(* Arithmetic operations *)
let mov name src =
  let dest = new_var ~name ~type_:(type_of_atom src) in
  emit (Ir.move dest src);
  atom_of_var dest
;;

let add name src1 src2 =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.add { dest; src1; src2 });
  atom_of_var dest
;;

let sub name src1 src2 =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.sub { dest; src1; src2 });
  atom_of_var dest
;;

let mul name src1 src2 =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.mul { dest; src1; src2 });
  atom_of_var dest
;;

let div name src1 src2 =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.div { dest; src1; src2 });
  atom_of_var dest
;;

let mod_ name src1 src2 =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.mod_ { dest; src1; src2 });
  atom_of_var dest
;;

let and_ name src1 src2 =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.and_ { dest; src1; src2 });
  atom_of_var dest
;;

let or_ name src1 src2 =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.or_ { dest; src1; src2 });
  atom_of_var dest
;;

let ptr_add name ptr offset =
  let dest = new_var ~name ~type_:(ptr_type_of_atom ptr) in
  emit (Ir.add { dest; src1 = ptr; src2 = offset });
  atom_of_var dest
;;

let ptr_sub name ptr offset =
  let dest = new_var ~name ~type_:(ptr_type_of_atom ptr) in
  emit (Ir.sub { dest; src1 = ptr; src2 = offset });
  atom_of_var dest
;;

let ptr_diff name lhs rhs =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.sub { dest; src1 = lhs; src2 = rhs });
  atom_of_var dest
;;

(* Floating point operations *)
let fadd name src1 src2 =
  let dest = new_var ~name ~type_:Type.F64 in
  emit (Ir.fadd { dest; src1; src2 });
  atom_of_var dest
;;

let fsub name src1 src2 =
  let dest = new_var ~name ~type_:Type.F64 in
  emit (Ir.fsub { dest; src1; src2 });
  atom_of_var dest
;;

let fmul name src1 src2 =
  let dest = new_var ~name ~type_:Type.F64 in
  emit (Ir.fmul { dest; src1; src2 });
  atom_of_var dest
;;

let fdiv name src1 src2 =
  let dest = new_var ~name ~type_:Type.F64 in
  emit (Ir.fdiv { dest; src1; src2 });
  atom_of_var dest
;;

(* Memory operations *)
let load name addr =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.load dest (Ir.Mem.address addr));
  atom_of_var dest
;;

let load_ptr name addr =
  let dest = new_var ~name ~type_:Type.Ptr in
  emit (Ir.load dest (Ir.Mem.address addr));
  atom_of_var dest
;;

let load_f64 name addr =
  let dest = new_var ~name ~type_:Type.F64 in
  emit (Ir.load dest (Ir.Mem.address addr));
  atom_of_var dest
;;

let store value addr = emit (Ir.store value (Ir.Mem.address addr))

let load_addr name base offset =
  let dest = new_var ~name ~type_:Type.I64 in
  emit (Ir.load dest (Ir.Mem.address base ~offset));
  atom_of_var dest
;;

let load_addr_ptr name base offset =
  let dest = new_var ~name ~type_:Type.Ptr in
  emit (Ir.load dest (Ir.Mem.address base ~offset));
  atom_of_var dest
;;

let load_addr_f64 name base offset =
  let dest = new_var ~name ~type_:Type.F64 in
  emit (Ir.load dest (Ir.Mem.address base ~offset));
  atom_of_var dest
;;

let store_addr value base offset =
  emit (Ir.store value (Ir.Mem.address base ~offset))
;;

(* Alloca *)
let alloca name size =
  let dest = new_var ~name ~type_:Type.Ptr in
  emit (Ir.alloca { dest; size });
  atom_of_var dest
;;

(* Cast *)
let cast name dest_type src =
  let dest = new_var ~name ~type_:dest_type in
  emit (Ir.cast dest src);
  atom_of_var dest
;;

(* Call helpers for different arities that work with PPX *)
let call_with_args name fn args =
  match fn.Fn.returns with
  | [ ret_type ] ->
    let dest = new_var ~name ~type_:ret_type in
    emit (Ir.call ~fn:fn.Fn.name ~results:[ dest ] ~args);
    atom_of_var dest
  | [] -> failwith "call expects a return value"
  | _ -> failwith "call does not support multiple return values"
;;

let call name fn arg = call_with_args name fn [ arg ]
let call0 name fn = call_with_args name fn []

let call2 name fn arg1 arg2 = call_with_args name fn [ arg1; arg2 ]

let call3 name fn arg1 arg2 arg3 =
  call_with_args name fn [ arg1; arg2; arg3 ]
;;

let call4 name fn arg1 arg2 arg3 arg4 =
  call_with_args name fn [ arg1; arg2; arg3; arg4 ]
;;

let call5 name fn arg1 arg2 arg3 arg4 arg5 =
  call_with_args name fn [ arg1; arg2; arg3; arg4; arg5 ]
;;

(* Aggregate operations *)
let load_field name base type_ indices =
  let dest_type =
    match Type.field_offset type_ indices with
    | Ok (_, Type.Tuple _ as agg) -> Type.Ptr_typed agg
    | Ok (_, field) -> field
    | Error err -> raise (Error.to_exn err)
  in
  let dest = new_var ~name ~type_:dest_type in
  emit (Ir.load_field { dest; base; type_; indices });
  atom_of_var dest
;;

let store_field base src type_ indices =
  emit (Ir.store_field { base; src; type_; indices })
;;

let memcpy dest src type_ = emit (Ir.memcpy { dest; src; type_ })

module Instr = struct
  let var_exn = function
    | L.Var v -> v
    | _ -> failwith "expected variable atom"
  ;;

  let mov ~dest src = Ir.move (var_exn dest) src
  let add ~dest src1 src2 = Ir.add { dest = var_exn dest; src1; src2 }
  let sub ~dest src1 src2 = Ir.sub { dest = var_exn dest; src1; src2 }
  let mul ~dest src1 src2 = Ir.mul { dest = var_exn dest; src1; src2 }
  let div ~dest src1 src2 = Ir.div { dest = var_exn dest; src1; src2 }
  let mod_ ~dest src1 src2 = Ir.mod_ { dest = var_exn dest; src1; src2 }
  let and_ ~dest src1 src2 = Ir.and_ { dest = var_exn dest; src1; src2 }
  let or_ ~dest src1 src2 = Ir.or_ { dest = var_exn dest; src1; src2 }
  let fadd ~dest src1 src2 = Ir.fadd { dest = var_exn dest; src1; src2 }
  let fsub ~dest src1 src2 = Ir.fsub { dest = var_exn dest; src1; src2 }
  let fmul ~dest src1 src2 = Ir.fmul { dest = var_exn dest; src1; src2 }
  let fdiv ~dest src1 src2 = Ir.fdiv { dest = var_exn dest; src1; src2 }

  let load mem ~dest = Ir.load (var_exn dest) mem
  let store value mem = Ir.store value mem

  let load_addr base offset ~dest =
    Ir.load (var_exn dest) (Ir.Mem.address base ~offset)
  ;;

  let store_addr value base offset =
    Ir.store value (Ir.Mem.address base ~offset)
  ;;

  let alloca size ~dest = Ir.alloca { dest = var_exn dest; size }
  let cast src ~dest = Ir.cast (var_exn dest) src

  let call fn args ~results =
    Ir.call
      ~fn:fn.Fn.name
      ~results:(List.map results ~f:var_exn)
      ~args
  ;;

  let call0 fn args = Ir.call ~fn:fn.Fn.name ~results:[] ~args

  let load_field base type_ indices ~dest =
    Ir.load_field { dest = var_exn dest; base; type_; indices }
  ;;

  let store_field base src type_ indices =
    Ir.store_field { base; src; type_; indices }
  ;;

  let memcpy dest src type_ = Ir.memcpy { dest; src; type_ }

  let atomic_load addr order ~dest =
    Ir.atomic_load { dest = var_exn dest; addr; order }
  ;;

  let atomic_store addr src order = Ir.atomic_store { addr; src; order }

  let atomic_rmw addr src op order ~dest =
    Ir.atomic_rmw { dest = var_exn dest; addr; src; op; order }
  ;;

  let atomic_cmpxchg
    addr
    expected
    desired
    success_order
    failure_order
    ~dest
    ~success
    =
    Ir.atomic_cmpxchg
      { dest = var_exn dest
      ; success = var_exn success
      ; addr
      ; expected
      ; desired
      ; success_order
      ; failure_order
      }
  ;;
end
