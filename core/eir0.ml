open! Ssa
open! Core
open! Import

type raw_block =
  instrs_by_label:(Typed_var.t, string) Nod_ir.Ir.t Nod_vec.t String.Map.t
  * labels:string Nod_vec.t

type program = raw_block Program.t'

module Pp = struct
  let rec nod_type_to_string (t : Nod_common.Type.t) =
    match t with
    | I8 -> "i8"
    | I16 -> "i16"
    | I32 -> "i32"
    | I64 -> "i64"
    | F32 -> "f32"
    | F64 -> "f64"
    | Ptr -> "ptr"
    | Ptr_typed t -> sprintf "ptr(%s)" (nod_type_to_string t)
    | Tuple ts ->
      sprintf
        "tuple(%s)"
        (String.concat ~sep:", " (List.map ts ~f:nod_type_to_string))
  ;;

  let pp_tv (tv : Nod_common.Typed_var.t) =
    sprintf "%s:%s" tv.name (nod_type_to_string tv.type_)
  ;;

  let pp_lov (lov : Nod_common.Typed_var.t Nod_ir.Lit_or_var.t) =
    match lov with
    | Lit n -> Int64.to_string n
    | Var tv -> pp_tv tv
    | Global g -> sprintf "@%s" g.name
  ;;

  let pp_mem (mem : Nod_common.Typed_var.t Nod_ir.Mem.t) =
    match mem with
    | Address { base; offset } -> sprintf "[%s+%d]" (pp_lov base) offset
    | Stack_slot n -> sprintf "stack(%d)" n
    | Global g -> sprintf "@%s" g.name
  ;;

  let pp_arith op (a : Nod_common.Typed_var.t Nod_ir.Ir_helpers.arith) =
    sprintf "%s = %s %s, %s" (pp_tv a.dest) op (pp_lov a.src1) (pp_lov a.src2)
  ;;

  let pp_ir (ir : (Nod_common.Typed_var.t, string) Nod_ir.Ir.t) =
    match ir with
    | Noop -> "noop"
    | And arith -> pp_arith "and" arith
    | Or arith -> pp_arith "or" arith
    | Add arith -> pp_arith "add" arith
    | Sub arith -> pp_arith "sub" arith
    | Mul arith -> pp_arith "mul" arith
    | Div arith -> pp_arith "div" arith
    | Mod arith -> pp_arith "mod" arith
    | Lt arith -> pp_arith "lt" arith
    | Fadd arith -> pp_arith "fadd" arith
    | Fsub arith -> pp_arith "fsub" arith
    | Fmul arith -> pp_arith "fmul" arith
    | Fdiv arith -> pp_arith "fdiv" arith
    | Alloca { dest; size } ->
      sprintf "%s = alloca %s" (pp_tv dest) (pp_lov size)
    | Load (dest, mem) -> sprintf "%s = load %s" (pp_tv dest) (pp_mem mem)
    | Store (val_, mem) -> sprintf "store %s -> %s" (pp_lov val_) (pp_mem mem)
    | Move (dest, src) -> sprintf "%s = move %s" (pp_tv dest) (pp_lov src)
    | Cast (dest, src) -> sprintf "%s = cast %s" (pp_tv dest) (pp_lov src)
    | Call { callee; results; args } ->
      let results_str = List.map results ~f:pp_tv |> String.concat ~sep:", " in
      let args_str = List.map args ~f:pp_lov |> String.concat ~sep:", " in
      let callee_str =
        match callee with
        | Nod_ir.Ir.Call_callee.Direct fn -> fn
        | Nod_ir.Ir.Call_callee.Indirect operand ->
          sprintf "*%s" (pp_lov operand)
      in
      if String.is_empty results_str
      then sprintf "call %s(%s)" callee_str args_str
      else sprintf "%s = call %s(%s)" results_str callee_str args_str
    | Branch (Cond { cond; if_true; if_false }) ->
      sprintf "br %s, %s, %s" (pp_lov cond) if_true.block if_false.block
    | Branch (Uncond { block; args = _ }) -> sprintf "jmp %s" block
    | Return val_ -> sprintf "ret %s" (pp_lov val_)
    | Memcpy { dest; src; type_ } ->
      sprintf
        "memcpy %s, %s [%s]"
        (pp_lov dest)
        (pp_lov src)
        (nod_type_to_string type_)
    | Load_field { dest; base; type_; indices } ->
      sprintf
        "%s = load_field %s, %s, [%s]"
        (pp_tv dest)
        (pp_lov base)
        (nod_type_to_string type_)
        (List.map indices ~f:Int.to_string |> String.concat ~sep:", ")
    | Store_field { base; src; type_; indices } ->
      sprintf
        "store_field %s, %s, %s, [%s]"
        (pp_lov base)
        (pp_lov src)
        (nod_type_to_string type_)
        (List.map indices ~f:Int.to_string |> String.concat ~sep:", ")
    | _ ->
      Sexp.to_string_hum
        (Nod_ir.Ir.sexp_of_t Nod_common.Typed_var.sexp_of_t String.sexp_of_t ir)
  ;;

  let print_program (program : program) =
    List.iter program.globals ~f:(fun (g : Nod_ir.Global.t) ->
      let init_str =
        match g.init with
        | Zero -> "zero"
        | Int n -> Int64.to_string n
        | Float f -> Float.to_string f
        | Aggregate _ -> "aggregate(...)"
      in
      printf "global %s: %s = %s\n" g.name (nod_type_to_string g.type_) init_str);
    Map.iteri program.functions ~f:(fun ~key:_ ~data:fn ->
      let args_str = List.map fn.args ~f:pp_tv |> String.concat ~sep:", " in
      printf "function %s(%s):\n" fn.name args_str;
      let ~instrs_by_label, ~labels = fn.root in
      let label_list = Nod_vec.to_list labels in
      List.iter label_list ~f:(fun label ->
        printf "  %s:\n" label;
        match Map.find instrs_by_label label with
        | None -> ()
        | Some instrs ->
          Nod_vec.iter instrs ~f:(fun instr -> printf "    %s\n" (pp_ir instr))))
  ;;
end
