open! Core
open Import

let test_ok s =
  match Nod_low.Low.lower_string s with
  | Ok _ -> print_endline "ok"
  | Error err -> Nod_low.Error.to_string err |> print_endline
;;

type call_info =
  { fn : string
  ; results : string list
  ; args : string list
  }
[@@deriving sexp]

type field_load =
  { indices : int list
  ; dest_type : string
  }
[@@deriving sexp]

type field_store =
  { indices : int list
  ; src_type : string
  }
[@@deriving sexp]

type fn_summary =
  { args : string list
  ; allocas : int
  ; memcpys : string list
  ; calls : call_info list
  ; load_fields : field_load list
  ; store_fields : field_store list
  ; returns : string list
  }
[@@deriving sexp]

let with_program source ~f =
  match Nod_low.Low.lower_string source with
  | Ok program -> f program
  | Error err -> Nod_low.Error.to_string err |> print_endline
;;

let instrs_in_order fn =
  let ~instrs_by_label, ~labels = fn.Function0.root in
  Vec.to_list labels
  |> List.concat_map ~f:(fun label ->
    Map.find_exn instrs_by_label label |> Vec.to_list)
;;

let lit_or_var_type = function
  | Ir0.Lit_or_var.Lit _ -> "lit"
  | Var v -> Type.to_string (Var.type_ v)
;;

let summarize_fn fn =
  let args =
    List.map fn.Function0.args ~f:(fun v -> Type.to_string (Var.type_ v))
  in
  let allocas = ref 0 in
  let memcpys = ref [] in
  let calls = ref [] in
  let load_fields = ref [] in
  let store_fields = ref [] in
  let returns = ref [] in
  List.iter (instrs_in_order fn) ~f:(function
    | Ir0.Alloca _ -> allocas := !allocas + 1
    | Ir0.Memcpy { type_; _ } -> memcpys := Type.to_string type_ :: !memcpys
    | Ir0.Call { fn; results; args } ->
      let results =
        List.map results ~f:(fun v -> Type.to_string (Var.type_ v))
      in
      let args = List.map args ~f:lit_or_var_type in
      calls := { fn; results; args } :: !calls
    | Ir0.Load_field { dest; indices; _ } ->
      let dest_type = Type.to_string (Var.type_ dest) in
      load_fields := { indices; dest_type } :: !load_fields
    | Ir0.Store_field { indices; src; _ } ->
      let src_type = lit_or_var_type src in
      store_fields := { indices; src_type } :: !store_fields
    | Ir0.Return operand -> returns := lit_or_var_type operand :: !returns
    | _ -> ());
  { args
  ; allocas = !allocas
  ; memcpys = List.rev !memcpys
  ; calls = List.rev !calls
  ; load_fields = List.rev !load_fields
  ; store_fields = List.rev !store_fields
  ; returns = List.rev !returns
  }
;;

let print_fn_summary program name =
  let fn = Map.find_exn program name in
  let summary = summarize_fn fn in
  print_s [%sexp ((name, summary) : string * fn_summary)]
;;

let host_system = Lazy.force Nod.host_system

let%expect_test "struct alloca and field access" =
  {|
struct Pair {
  a: i64;
  b: i64;
};

i64 sum(i64 x, i64 y) {
  struct Pair* p = alloca(struct Pair);
  p->a = x;
  p->b = y;
  return p->a + p->b;
}
|}
  |> test_ok;
  [%expect {| ok |}]
;;

let%expect_test "struct field ops lower to load_field/store_field" =
  {|
struct Pair {
  a: i64;
  b: i64;
};

i64 sum(i64 x, i64 y) {
  struct Pair* p = alloca(struct Pair);
  p->a = x;
  p->b = y;
  return p->a + p->b;
}
|}
  |> with_program ~f:(fun program -> print_fn_summary program "sum");
  [%expect
    {|
    (sum
     ((args (i64 i64)) (allocas 1) (memcpys ()) (calls ())
      (load_fields
       (((indices (0)) (dest_type i64)) ((indices (1)) (dest_type i64))))
      (store_fields
       (((indices (0)) (src_type i64)) ((indices (1)) (src_type i64))))
      (returns (i64))))
    |}]
;;

let%expect_test "struct value locals and by-value calls" =
  {|
struct Pair {
  a: i64;
  b: i64;
};

struct Pair make(i64 x) {
  struct Pair p;
  p.a = x;
  p.b = x;
  return p;
}

i64 sum(struct Pair p) {
  return p.a + p.b;
}

i64 main(i64 x) {
  struct Pair q;
  q = make(x);
  return sum(q);
}
|}
  |> test_ok;
  [%expect {| ok |}]
;;

let%expect_test "struct by-value calls and returns use sret" =
  {|
struct Pair {
  a: i64;
  b: i64;
};

struct Pair make(i64 x) {
  struct Pair p;
  p.a = x;
  p.b = x;
  return p;
}

i64 sum(struct Pair p) {
  return p.a + p.b;
}

i64 main(i64 x) {
  struct Pair q;
  q = make(x);
  return sum(q);
}
|}
  |> with_program ~f:(fun program ->
    print_fn_summary program "make";
    print_fn_summary program "sum";
    print_fn_summary program "main");
  [%expect
    {|
    (make
     ((args (ptr i64)) (allocas 1) (memcpys ("(i64, i64)")) (calls ())
      (load_fields ())
      (store_fields
       (((indices (0)) (src_type i64)) ((indices (1)) (src_type i64))))
      (returns (ptr))))
    (sum
     ((args (ptr)) (allocas 0) (memcpys ()) (calls ())
      (load_fields
       (((indices (0)) (dest_type i64)) ((indices (1)) (dest_type i64))))
      (store_fields ()) (returns (i64))))
    (main
     ((args (i64)) (allocas 3) (memcpys ("(i64, i64)" "(i64, i64)"))
      (calls
       (((fn make) (results ()) (args (ptr i64)))
        ((fn sum) (results (i64)) (args (ptr)))))
      (load_fields ()) (store_fields ()) (returns (i64))))
    |}]
;;

let%expect_test "struct field reads return pointers for aggregate fields" =
  {|
struct Inner {
  a: i64;
};

struct Outer {
  inner: struct Inner;
  b: i64;
};

i64 use_inner(i64 x) {
  struct Outer o;
  struct Inner t;
  t.a = x;
  o.inner = t;
  t = o.inner;
  return t.a;
}
|}
  |> with_program ~f:(fun program -> print_fn_summary program "use_inner");
  [%expect
    {|
    (use_inner
     ((args (i64)) (allocas 2) (memcpys ("(i64)")) (calls ())
      (load_fields
       (((indices (0)) (dest_type ptr)) ((indices (0)) (dest_type i64))))
      (store_fields
       (((indices (0)) (src_type i64)) ((indices (0)) (src_type ptr))))
      (returns (i64))))
    |}]
;;

let%expect_test "if and while" =
  {|
i64 count(i64 n) {
  i64 acc = 0;
  while (n) {
    acc = acc + 1;
    n = n - 1;
  }
  if (acc) {
    acc = acc + 10;
  } else {
    acc = acc + 20;
  }
  return acc;
}
|}
  |> test_ok;
  [%expect {| ok |}]
;;
