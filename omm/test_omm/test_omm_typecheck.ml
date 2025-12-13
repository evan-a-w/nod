open! Core
open! Import

let typecheck s =
  match Omm_parser.parse_string s with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok cst ->
    (match Omm_typecheck.check_program cst with
     | Ok program -> print_s [%sexp (program : Nod_omm.Ast.program)]
     | Error e -> Omm_tc_error.to_string e |> print_endline)
;;

let%expect_test "typechecks simple function and intrinsics" =
  {|
type pair = struct { a : i64; b : i64; }

external print_i64 : (i64) -> i64 = "print_i64"

let main(u : unit) : i64 =
  begin
    let p : pair ptr = alloca<pair>();
    store<pair>(p, pair { a = 1; b = 2 });
    let a_ptr : i64 ptr = p->a;
    let s : i64 = load<i64>(a_ptr) + 3;
    let _ : i64 = print_i64(s);
    return s;
  end
|}
  |> typecheck;
  [%expect
    {|
    ((items
      ((Type_def (pos ((line 1) (col 0) (file ""))) (name pair)
        (fields (((name a) (ty (Prim I64))) ((name b) (ty (Prim I64))))))
       (Extern_decl (pos ((line 3) (col 0) (file ""))) (name print_i64)
        (params ((Prim I64))) (ret (Prim I64)) (symbol print_i64))
       (Fun_def (pos ((line 5) (col 0) (file ""))) (name main)
        (params (((name u) (ty Unit)))) (ret (Prim I64))
        (body
         ((pos ((line 6) (col 2) (file "")))
          (stmts
           (((pos ((line 7) (col 4) (file "")))
             (desc
              (Let (name p) (ty (Ptr (Struct pair)))
               (expr
                ((pos ((line 7) (col 23) (file ""))) (ty (Ptr (Struct pair)))
                 (desc
                  (Intrinsic_call (name Alloca) (type_args ((Struct pair)))
                   (args ()))))))))
            ((pos ((line 8) (col 4) (file "")))
             (desc
              (Expr_stmt
               ((pos ((line 8) (col 4) (file ""))) (ty Unit)
                (desc
                 (Intrinsic_call (name Store) (type_args ((Struct pair)))
                  (args
                   ((Arg_expr
                     ((pos ((line 8) (col 16) (file "")))
                      (ty (Ptr (Struct pair))) (desc (Var p))))
                    (Arg_expr
                     ((pos ((line 8) (col 19) (file ""))) (ty (Struct pair))
                      (desc
                       (Struct_lit (ty_name pair)
                        (fields
                         ((a
                           ((pos ((line 8) (col 30) (file ""))) (ty (Prim I64))
                            (desc (Int 1))))
                          (b
                           ((pos ((line 8) (col 37) (file ""))) (ty (Prim I64))
                            (desc (Int 2))))))))))))))))))
            ((pos ((line 9) (col 4) (file "")))
             (desc
              (Let (name a_ptr) (ty (Ptr (Prim I64)))
               (expr
                ((pos ((line 9) (col 26) (file ""))) (ty (Ptr (Prim I64)))
                 (desc
                  (Arrow_field
                   (base
                    ((pos ((line 9) (col 26) (file ""))) (ty (Ptr (Struct pair)))
                     (desc (Var p))))
                   (field a))))))))
            ((pos ((line 10) (col 4) (file "")))
             (desc
              (Let (name s) (ty (Prim I64))
               (expr
                ((pos ((line 10) (col 18) (file ""))) (ty (Prim I64))
                 (desc
                  (Binop (op Add)
                   (lhs
                    ((pos ((line 10) (col 18) (file ""))) (ty (Prim I64))
                     (desc
                      (Intrinsic_call (name Load) (type_args ((Prim I64)))
                       (args
                        ((Arg_expr
                          ((pos ((line 10) (col 28) (file "")))
                           (ty (Ptr (Prim I64))) (desc (Var a_ptr))))))))))
                   (rhs
                    ((pos ((line 10) (col 37) (file ""))) (ty (Prim I64))
                     (desc (Int 3)))))))))))
            ((pos ((line 11) (col 4) (file "")))
             (desc
              (Let (name _) (ty (Prim I64))
               (expr
                ((pos ((line 11) (col 18) (file ""))) (ty (Prim I64))
                 (desc
                  (Call (name print_i64)
                   (args
                    (((pos ((line 11) (col 28) (file ""))) (ty (Prim I64))
                      (desc (Var s))))))))))))
            ((pos ((line 12) (col 4) (file "")))
             (desc
              (Return
               ((pos ((line 12) (col 11) (file ""))) (ty (Prim I64))
                (desc (Var s))))))))))))))
    |}]
;;

let%expect_test "rejects bad let annotation" =
  {|
let bad() : unit =
  begin
    let x : f64 = 0;
    return ();
  end
|}
  |> typecheck;
  [%expect
    {| Error: type mismatch (let x) at ((line 3)(col 18)(file"")): expected f64 but got i64 |}]
;;

let%expect_test "rejects field_addr type mismatch" =
  {|
type pair = struct { a : i64; b : i64; }
let bad(p : pair ptr) : unit =
  begin
    let _ : f64 ptr = field_addr<pair, f64>(p, field = a);
    return ();
  end
|}
  |> typecheck;
  [%expect
    {| Error: type mismatch (field_addr result type) at ((line 4)(col 22)(file"")): expected i64 but got f64 |}]
;;

