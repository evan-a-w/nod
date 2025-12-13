open! Core
open! Import

module Cst = Omm_cst

let rec ty_to_string (t : Cst.ty) =
  match t.value with
  | I64 -> "i64"
  | F64 -> "f64"
  | Unit -> "unit"
  | Named s -> s
  | Ptr t -> ty_to_string t ^ " ptr"
;;

let binop_to_string = function
  | Cst.Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Eq -> "="
  | Ne -> "<>"
  | Lt -> "<"
  | Le -> "<="
  | Gt -> ">"
  | Ge -> ">="
  | Land -> "land"
  | Lor -> "lor"
  | Lxor -> "lxor"
  | Lsl -> "lsl"
  | Lsr -> "lsr"
  | Asr -> "asr"
;;

let rec expr_to_string (e : Cst.expr) =
  match e.value with
  | Int i -> Int64.to_string i
  | Float f -> Float.to_string f
  | Unit_lit -> "()"
  | Var s -> s
  | Struct_lit { ty_name; fields } ->
    let fields =
      fields
      |> List.map ~f:(fun (name, value) ->
        [%string "%{name} = %{expr_to_string value}"])
      |> String.concat ~sep:"; "
    in
    [%string "%{ty_name} { %{fields} }"]
  | Field { base; field } -> [%string "%{expr_to_string base}.%{field}"]
  | Arrow_field { base; field } -> [%string "%{expr_to_string base}->%{field}"]
  | Index { base; index } ->
    [%string "%{expr_to_string base}[%{expr_to_string index}]"]
  | Call { callee; type_args; args } ->
    let type_args =
      match type_args with
      | [] -> ""
      | tys ->
        tys
        |> List.map ~f:ty_to_string
        |> String.concat ~sep:", "
        |> fun s -> [%string "<%{s}>"]
    in
    let args =
      args
      |> List.map ~f:(function
        | Cst.Expr e -> expr_to_string e
        | Named_field { field } -> [%string "field = %{field}"])
      |> String.concat ~sep:", "
    in
    [%string "%{expr_to_string callee}%{type_args}(%{args})"]
  | If { cond; then_; else_ } ->
    [%string
      "if %{expr_to_string cond} then %{expr_to_string then_} else %{expr_to_string else_}"]
  | Binop { op; lhs; rhs } ->
    [%string "(%{expr_to_string lhs} %{binop_to_string op} %{expr_to_string rhs})"]
  | Unop { op = Neg; arg } -> [%string "(-%{expr_to_string arg})"]
  | Paren e -> [%string "(%{expr_to_string e})"]
;;

let stmt_to_string (s : Cst.stmt) =
  match s.value with
  | Let { name; ty; expr } ->
    [%string "let %{name} : %{ty_to_string ty} = %{expr_to_string expr};"]
  | If_stmt { cond; then_; else_ } ->
    [%string
      "if %{expr_to_string cond} then begin(%{Int.to_string (List.length then_.value.stmts)}) \
       else begin(%{Int.to_string (List.length else_.value.stmts)});"]
  | While { cond; body } ->
    [%string
      "while %{expr_to_string cond} do begin(%{Int.to_string (List.length body.value.stmts)}) \
       done;"]
  | Return e -> [%string "return %{expr_to_string e};"]
  | Expr_stmt e -> [%string "%{expr_to_string e};"]
;;

let item_to_string (item : Cst.item) =
  match item.value with
  | Type_def { name; fields } ->
    let fields =
      fields
      |> List.map ~f:(fun (f : Cst.field) -> [%string "%{f.name} : %{ty_to_string f.ty}"])
      |> String.concat ~sep:", "
    in
    [%string "type %{name} = struct { %{fields} }"]
  | Extern_decl { name; params; ret; symbol } ->
    let params = params |> List.map ~f:ty_to_string |> String.concat ~sep:", " in
    [%string "external %{name} : (%{params}) -> %{ty_to_string ret} = %{symbol}"]
  | Fun_def { name; params; ret; body } ->
    let params =
      params
      |> List.map ~f:(fun (p : Cst.param) -> [%string "%{p.name} : %{ty_to_string p.ty}"])
      |> String.concat ~sep:", "
    in
    let stmts = body.value.stmts |> List.map ~f:stmt_to_string in
    Sexp.List
      [ Atom [%string "fun %{name}(%{params}) : %{ty_to_string ret}"]
      ; Sexp.List (List.map stmts ~f:(fun s -> Sexp.Atom s))
      ]
    |> Sexp.to_string_hum
  | Global_def { name; ty; init } ->
    let init =
      match init.value with
      | Top_int i -> Int64.to_string i
      | Top_float f -> Float.to_string f
      | Top_unit -> "()"
      | Top_var s -> s
      | Top_struct { ty_name; fields } ->
        let fields =
          fields
          |> List.map ~f:(fun (name, value) ->
            let value =
              match value.value with
              | Top_int i -> Int64.to_string i
              | Top_float f -> Float.to_string f
              | Top_unit -> "()"
              | Top_var s -> s
              | Top_struct _ -> "<struct>"
            in
            [%string "%{name} = %{value}"])
          |> String.concat ~sep:"; "
        in
        [%string "%{ty_name} { %{fields} }"]
    in
    [%string "let %{name} : %{ty_to_string ty} = %{init};"]
;;

let test s =
  match Omm_parser.parse_string s with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    program
    |> List.map ~f:item_to_string
    |> List.iter ~f:print_endline
;;

let%expect_test "parses spec example" =
  {|
type pair = struct { a : i64; b : i64; }

external print_i64 : (i64) -> i64 = "print_i64"

let main(u : unit) : i64 =
  begin
    let p : pair ptr = alloca<pair>();
    store<pair>(p, pair { a = 1; b = 2 });
    let a_ptr : i64 ptr = p->a;
    let b_ptr : i64 ptr = p->b;
    let s : i64 = load<i64>(a_ptr) + load<i64>(b_ptr);
    let _ : i64 = print_i64(s);
    return 0;
  end
|}
  |> test;
  [%expect
    {|
    type pair = struct { a : i64, b : i64 }
    external print_i64 : (i64) -> i64 = print_i64
    ("fun main(u : unit) : i64"
     ("let p : pair ptr = alloca<pair>();"
      "store<pair>(p, pair { a = 1; b = 2 });" "let a_ptr : i64 ptr = p->a;"
      "let b_ptr : i64 ptr = p->b;"
      "let s : i64 = (load<i64>(a_ptr) + load<i64>(b_ptr));"
      "let _ : i64 = print_i64(s);" "return 0;"))
    |}]
;;

let%expect_test "parses comments, hex, float exponent, indexing" =
  {|
// line comment
(* outer (* inner *) still outer *)

let f(x : i64) : i64 =
  begin
    let a : i64 = 0x2a;
    let b : f64 = -1.0e-9;
    let p : i64 ptr = alloca<i64>();
    let q : i64 ptr = p[3];
    return a;
  end
|}
  |> test;
  [%expect
    {|
    ("fun f(x : i64) : i64"
     ("let a : i64 = 42;" "let b : f64 = (-1e-09);"
      "let p : i64 ptr = alloca<i64>();" "let q : i64 ptr = p[3];" "return a;"))
    |}]
;;
