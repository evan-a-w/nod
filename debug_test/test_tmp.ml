open! Core
open! Import

let map_function_roots ~f functions =
  Map.map ~f:(Function.map_root ~f) functions
;;

let test_cfg s =
  s
  |> Parser.parse_string
  |> Result.map ~f:(map_function_roots ~f:Cfg.process)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok fns ->
    Map.iter
      fns
      ~f:(fun { Function.root = ~root:_, ~blocks:_, ~in_order:blocks; _ } ->
        Vec.iter blocks ~f:(fun block ->
          let instrs =
            Vec.to_list block.Block.instructions @ [ block.terminal ]
          in
          print_s [%message block.id_hum (instrs : Ir.t list)]))
;;

let test_ssa ?don't_opt s =
  test_cfg s;
  print_endline "=================================";
  Parser.parse_string s
  |> Result.map ~f:(map_function_roots ~f:Cfg.process)
  |> Result.map ~f:Eir.set_entry_block_args
  |> Result.map ~f:(map_function_roots ~f:Ssa.create)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok fns ->
    let go fns =
      Map.iter fns ~f:(fun { Function.root = (ssa : Ssa.t); _ } ->
        Vec.iter ssa.in_order ~f:(fun block ->
          let instrs = Vec.to_list block.instructions @ [ block.terminal ] in
          print_s
            [%message
              block.id_hum ~args:(block.args : Var.t Vec.t) (instrs : Ir.t list)]))
    in
    go fns;
    (match don't_opt with
     | Some () -> ()
     | None ->
       print_endline "******************************";
       Eir.optimize fns;
       go fns)
;;

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Nod.compile ~opt_flags program with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    let asm = X86_backend.compile_to_asm functions in
    print_endline asm
;;

let test ?dump_crap ?(opt_flags = Eir.Opt_flags.no_opt) s =
  match Eir.compile ~opt_flags s with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    let x86 = X86_backend.compile ?dump_crap functions in
    print_s
      [%sexp
        (Map.data x86 |> List.map ~f:Function.to_sexp_verbose : Sexp.t list)]
;;

let borked =
  (* Examples.Textual. *)
  {|
root() {
    add %v1:i64, 1, 0
    add %v2:i64, 2, 0
    add %v3:i64, 3, 0
    add %v4:i64, 4, 0
    add %v5:i64, 5, 0
    add %v6:i64, 6, 0
    add %v7:i64, 7, 0
    add %v8:i64, 8, 0
    add %v9:i64, 9, 0
    add %v10:i64, 10, 0
    add %v11:i64, 11, 0
    add %v12:i64, 12, 0
    add %v13:i64, 13, 0
    add %v14:i64, 14, 0
    add %v15:i64, 15, 0
    add %v16:i64, 16, 0
    add %v17:i64, 17, 0
    add %v18:i64, 18, 0
    add %v19:i64, 19, 0
    add %v20:i64, 20, 0
    add %s1:i64, %v1, %v2
    add %s2:i64, %s1, %v3
    add %s3:i64, %s2, %v4
    add %s4:i64, %s3, %v5
    add %s5:i64, %s4, %v6
    add %s6:i64, %s5, %v7
    add %s7:i64, %s6, %v8
    add %s8:i64, %s7, %v9
    add %s9:i64, %s8, %v10
    add %s10:i64, %s9, %v11
    add %s11:i64, %s10, %v12
    add %s12:i64, %s11, %v13
    add %s13:i64, %s12, %v14
    add %s14:i64, %s13, %v15
    add %s15:i64, %s14, %v16
    add %s16:i64, %s15, %v17
    add %s17:i64, %s16, %v18
    add %s18:i64, %s17, %v19
    add %result:i64, %s18, %v20
    ret %result
}
|}
;;

let%expect_test "run" =
  let output =
    compile_and_execute
    (* ~harness: *)
    (*   (make_harness_source ~fn_name:"root" ~fn_arg_type:"int" ~fn_arg:"2" ()) *)
      ~opt_flags:Eir.Opt_flags.no_opt
      borked
  in
  print_endline output;
  [%expect {| 210 |}]
;;

let%expect_test "borked regaloc" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_assignments functions;
    [%expect
      {|
      ((function_name root)
       (assignments
        ((((name res__0) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name result) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s1) (type_ I64)) (Reg ((reg R11) (class_ I64))))
         (((name s10) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name s11) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name s12) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name s13) (type_ I64)) Spill) (((name s14) (type_ I64)) Spill)
         (((name s15) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s16) (type_ I64)) Spill)
         (((name s17) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s18) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s2) (type_ I64)) Spill) (((name s3) (type_ I64)) Spill)
         (((name s4) (type_ I64)) Spill)
         (((name s5) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name s6) (type_ I64)) Spill)
         (((name s7) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name s8) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name s9) (type_ I64)) Spill)
         (((name v1) (type_ I64)) (Reg ((reg R11) (class_ I64))))
         (((name v10) (type_ I64)) Spill) (((name v11) (type_ I64)) Spill)
         (((name v12) (type_ I64)) (Reg ((reg R9) (class_ I64))))
         (((name v13) (type_ I64)) Spill)
         (((name v14) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name v15) (type_ I64)) Spill)
         (((name v16) (type_ I64)) (Reg ((reg R10) (class_ I64))))
         (((name v17) (type_ I64)) (Reg ((reg R8) (class_ I64))))
         (((name v18) (type_ I64)) Spill) (((name v19) (type_ I64)) Spill)
         (((name v2) (type_ I64)) (Reg ((reg RBX) (class_ I64))))
         (((name v20) (type_ I64)) (Reg ((reg R14) (class_ I64))))
         (((name v3) (type_ I64)) (Reg ((reg R12) (class_ I64))))
         (((name v4) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name v5) (type_ I64)) Spill)
         (((name v6) (type_ I64)) (Reg ((reg RDX) (class_ I64))))
         (((name v7) (type_ I64)) Spill)
         (((name v8) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name v9) (type_ I64)) (Reg ((reg RCX) (class_ I64)))))))
      ((((name v1) (type_ I64)) ((name v2) (type_ I64)))
       (((name v1) (type_ I64)) ((name v3) (type_ I64)))
       (((name v1) (type_ I64)) ((name v4) (type_ I64)))
       (((name v1) (type_ I64)) ((name v5) (type_ I64)))
       (((name v1) (type_ I64)) ((name v6) (type_ I64)))
       (((name v1) (type_ I64)) ((name v7) (type_ I64)))
       (((name v1) (type_ I64)) ((name v8) (type_ I64)))
       (((name v1) (type_ I64)) ((name v9) (type_ I64)))
       (((name v1) (type_ I64)) ((name v10) (type_ I64)))
       (((name v1) (type_ I64)) ((name v11) (type_ I64)))
       (((name v1) (type_ I64)) ((name v12) (type_ I64)))
       (((name v1) (type_ I64)) ((name v13) (type_ I64)))
       (((name v1) (type_ I64)) ((name v14) (type_ I64)))
       (((name v1) (type_ I64)) ((name v15) (type_ I64)))
       (((name v1) (type_ I64)) ((name v16) (type_ I64)))
       (((name v1) (type_ I64)) ((name v17) (type_ I64)))
       (((name v1) (type_ I64)) ((name v18) (type_ I64)))
       (((name v1) (type_ I64)) ((name v19) (type_ I64)))
       (((name v1) (type_ I64)) ((name v20) (type_ I64)))
       (((name v2) (type_ I64)) ((name v3) (type_ I64)))
       (((name v2) (type_ I64)) ((name v4) (type_ I64)))
       (((name v2) (type_ I64)) ((name v5) (type_ I64)))
       (((name v2) (type_ I64)) ((name v6) (type_ I64)))
       (((name v2) (type_ I64)) ((name v7) (type_ I64)))
       (((name v2) (type_ I64)) ((name v8) (type_ I64)))
       (((name v2) (type_ I64)) ((name v9) (type_ I64)))
       (((name v2) (type_ I64)) ((name v10) (type_ I64)))
       (((name v2) (type_ I64)) ((name v11) (type_ I64)))
       (((name v2) (type_ I64)) ((name v12) (type_ I64)))
       (((name v2) (type_ I64)) ((name v13) (type_ I64)))
       (((name v2) (type_ I64)) ((name v14) (type_ I64)))
       (((name v2) (type_ I64)) ((name v15) (type_ I64)))
       (((name v2) (type_ I64)) ((name v16) (type_ I64)))
       (((name v2) (type_ I64)) ((name v17) (type_ I64)))
       (((name v2) (type_ I64)) ((name v18) (type_ I64)))
       (((name v2) (type_ I64)) ((name v19) (type_ I64)))
       (((name v2) (type_ I64)) ((name v20) (type_ I64)))
       (((name v2) (type_ I64)) ((name s1) (type_ I64)))
       (((name v3) (type_ I64)) ((name v4) (type_ I64)))
       (((name v3) (type_ I64)) ((name v5) (type_ I64)))
       (((name v3) (type_ I64)) ((name v6) (type_ I64)))
       (((name v3) (type_ I64)) ((name v7) (type_ I64)))
       (((name v3) (type_ I64)) ((name v8) (type_ I64)))
       (((name v3) (type_ I64)) ((name v9) (type_ I64)))
       (((name v3) (type_ I64)) ((name v10) (type_ I64)))
       (((name v3) (type_ I64)) ((name v11) (type_ I64)))
       (((name v3) (type_ I64)) ((name v12) (type_ I64)))
       (((name v3) (type_ I64)) ((name v13) (type_ I64)))
       (((name v3) (type_ I64)) ((name v14) (type_ I64)))
       (((name v3) (type_ I64)) ((name v15) (type_ I64)))
       (((name v3) (type_ I64)) ((name v16) (type_ I64)))
       (((name v3) (type_ I64)) ((name v17) (type_ I64)))
       (((name v3) (type_ I64)) ((name v18) (type_ I64)))
       (((name v3) (type_ I64)) ((name v19) (type_ I64)))
       (((name v3) (type_ I64)) ((name v20) (type_ I64)))
       (((name v3) (type_ I64)) ((name s1) (type_ I64)))
       (((name v3) (type_ I64)) ((name s2) (type_ I64)))
       (((name v4) (type_ I64)) ((name v5) (type_ I64)))
       (((name v4) (type_ I64)) ((name v6) (type_ I64)))
       (((name v4) (type_ I64)) ((name v7) (type_ I64)))
       (((name v4) (type_ I64)) ((name v8) (type_ I64)))
       (((name v4) (type_ I64)) ((name v9) (type_ I64)))
       (((name v4) (type_ I64)) ((name v10) (type_ I64)))
       (((name v4) (type_ I64)) ((name v11) (type_ I64)))
       (((name v4) (type_ I64)) ((name v12) (type_ I64)))
       (((name v4) (type_ I64)) ((name v13) (type_ I64)))
       (((name v4) (type_ I64)) ((name v14) (type_ I64)))
       (((name v4) (type_ I64)) ((name v15) (type_ I64)))
       (((name v4) (type_ I64)) ((name v16) (type_ I64)))
       (((name v4) (type_ I64)) ((name v17) (type_ I64)))
       (((name v4) (type_ I64)) ((name v18) (type_ I64)))
       (((name v4) (type_ I64)) ((name v19) (type_ I64)))
       (((name v4) (type_ I64)) ((name v20) (type_ I64)))
       (((name v4) (type_ I64)) ((name s1) (type_ I64)))
       (((name v4) (type_ I64)) ((name s2) (type_ I64)))
       (((name v4) (type_ I64)) ((name s3) (type_ I64)))
       (((name v5) (type_ I64)) ((name v6) (type_ I64)))
       (((name v5) (type_ I64)) ((name v7) (type_ I64)))
       (((name v5) (type_ I64)) ((name v8) (type_ I64)))
       (((name v5) (type_ I64)) ((name v9) (type_ I64)))
       (((name v5) (type_ I64)) ((name v10) (type_ I64)))
       (((name v5) (type_ I64)) ((name v11) (type_ I64)))
       (((name v5) (type_ I64)) ((name v12) (type_ I64)))
       (((name v5) (type_ I64)) ((name v13) (type_ I64)))
       (((name v5) (type_ I64)) ((name v14) (type_ I64)))
       (((name v5) (type_ I64)) ((name v15) (type_ I64)))
       (((name v5) (type_ I64)) ((name v16) (type_ I64)))
       (((name v5) (type_ I64)) ((name v17) (type_ I64)))
       (((name v5) (type_ I64)) ((name v18) (type_ I64)))
       (((name v5) (type_ I64)) ((name v19) (type_ I64)))
       (((name v5) (type_ I64)) ((name v20) (type_ I64)))
       (((name v5) (type_ I64)) ((name s1) (type_ I64)))
       (((name v5) (type_ I64)) ((name s2) (type_ I64)))
       (((name v5) (type_ I64)) ((name s3) (type_ I64)))
       (((name v5) (type_ I64)) ((name s4) (type_ I64)))
       (((name v6) (type_ I64)) ((name v7) (type_ I64)))
       (((name v6) (type_ I64)) ((name v8) (type_ I64)))
       (((name v6) (type_ I64)) ((name v9) (type_ I64)))
       (((name v6) (type_ I64)) ((name v10) (type_ I64)))
       (((name v6) (type_ I64)) ((name v11) (type_ I64)))
       (((name v6) (type_ I64)) ((name v12) (type_ I64)))
       (((name v6) (type_ I64)) ((name v13) (type_ I64)))
       (((name v6) (type_ I64)) ((name v14) (type_ I64)))
       (((name v6) (type_ I64)) ((name v15) (type_ I64)))
       (((name v6) (type_ I64)) ((name v16) (type_ I64)))
       (((name v6) (type_ I64)) ((name v17) (type_ I64)))
       (((name v6) (type_ I64)) ((name v18) (type_ I64)))
       (((name v6) (type_ I64)) ((name v19) (type_ I64)))
       (((name v6) (type_ I64)) ((name v20) (type_ I64)))
       (((name v6) (type_ I64)) ((name s1) (type_ I64)))
       (((name v6) (type_ I64)) ((name s2) (type_ I64)))
       (((name v6) (type_ I64)) ((name s3) (type_ I64)))
       (((name v6) (type_ I64)) ((name s4) (type_ I64)))
       (((name v6) (type_ I64)) ((name s5) (type_ I64)))
       (((name v7) (type_ I64)) ((name v8) (type_ I64)))
       (((name v7) (type_ I64)) ((name v9) (type_ I64)))
       (((name v7) (type_ I64)) ((name v10) (type_ I64)))
       (((name v7) (type_ I64)) ((name v11) (type_ I64)))
       (((name v7) (type_ I64)) ((name v12) (type_ I64)))
       (((name v7) (type_ I64)) ((name v13) (type_ I64)))
       (((name v7) (type_ I64)) ((name v14) (type_ I64)))
       (((name v7) (type_ I64)) ((name v15) (type_ I64)))
       (((name v7) (type_ I64)) ((name v16) (type_ I64)))
       (((name v7) (type_ I64)) ((name v17) (type_ I64)))
       (((name v7) (type_ I64)) ((name v18) (type_ I64)))
       (((name v7) (type_ I64)) ((name v19) (type_ I64)))
       (((name v7) (type_ I64)) ((name v20) (type_ I64)))
       (((name v7) (type_ I64)) ((name s1) (type_ I64)))
       (((name v7) (type_ I64)) ((name s2) (type_ I64)))
       (((name v7) (type_ I64)) ((name s3) (type_ I64)))
       (((name v7) (type_ I64)) ((name s4) (type_ I64)))
       (((name v7) (type_ I64)) ((name s5) (type_ I64)))
       (((name v7) (type_ I64)) ((name s6) (type_ I64)))
       (((name v8) (type_ I64)) ((name v9) (type_ I64)))
       (((name v8) (type_ I64)) ((name v10) (type_ I64)))
       (((name v8) (type_ I64)) ((name v11) (type_ I64)))
       (((name v8) (type_ I64)) ((name v12) (type_ I64)))
       (((name v8) (type_ I64)) ((name v13) (type_ I64)))
       (((name v8) (type_ I64)) ((name v14) (type_ I64)))
       (((name v8) (type_ I64)) ((name v15) (type_ I64)))
       (((name v8) (type_ I64)) ((name v16) (type_ I64)))
       (((name v8) (type_ I64)) ((name v17) (type_ I64)))
       (((name v8) (type_ I64)) ((name v18) (type_ I64)))
       (((name v8) (type_ I64)) ((name v19) (type_ I64)))
       (((name v8) (type_ I64)) ((name v20) (type_ I64)))
       (((name v8) (type_ I64)) ((name s1) (type_ I64)))
       (((name v8) (type_ I64)) ((name s2) (type_ I64)))
       (((name v8) (type_ I64)) ((name s3) (type_ I64)))
       (((name v8) (type_ I64)) ((name s4) (type_ I64)))
       (((name v8) (type_ I64)) ((name s5) (type_ I64)))
       (((name v8) (type_ I64)) ((name s6) (type_ I64)))
       (((name v8) (type_ I64)) ((name s7) (type_ I64)))
       (((name v9) (type_ I64)) ((name v10) (type_ I64)))
       (((name v9) (type_ I64)) ((name v11) (type_ I64)))
       (((name v9) (type_ I64)) ((name v12) (type_ I64)))
       (((name v9) (type_ I64)) ((name v13) (type_ I64)))
       (((name v9) (type_ I64)) ((name v14) (type_ I64)))
       (((name v9) (type_ I64)) ((name v15) (type_ I64)))
       (((name v9) (type_ I64)) ((name v16) (type_ I64)))
       (((name v9) (type_ I64)) ((name v17) (type_ I64)))
       (((name v9) (type_ I64)) ((name v18) (type_ I64)))
       (((name v9) (type_ I64)) ((name v19) (type_ I64)))
       (((name v9) (type_ I64)) ((name v20) (type_ I64)))
       (((name v9) (type_ I64)) ((name s1) (type_ I64)))
       (((name v9) (type_ I64)) ((name s2) (type_ I64)))
       (((name v9) (type_ I64)) ((name s3) (type_ I64)))
       (((name v9) (type_ I64)) ((name s4) (type_ I64)))
       (((name v9) (type_ I64)) ((name s5) (type_ I64)))
       (((name v9) (type_ I64)) ((name s6) (type_ I64)))
       (((name v9) (type_ I64)) ((name s7) (type_ I64)))
       (((name v9) (type_ I64)) ((name s8) (type_ I64)))
       (((name v10) (type_ I64)) ((name v11) (type_ I64)))
       (((name v10) (type_ I64)) ((name v12) (type_ I64)))
       (((name v10) (type_ I64)) ((name v13) (type_ I64)))
       (((name v10) (type_ I64)) ((name v14) (type_ I64)))
       (((name v10) (type_ I64)) ((name v15) (type_ I64)))
       (((name v10) (type_ I64)) ((name v16) (type_ I64)))
       (((name v10) (type_ I64)) ((name v17) (type_ I64)))
       (((name v10) (type_ I64)) ((name v18) (type_ I64)))
       (((name v10) (type_ I64)) ((name v19) (type_ I64)))
       (((name v10) (type_ I64)) ((name v20) (type_ I64)))
       (((name v10) (type_ I64)) ((name s1) (type_ I64)))
       (((name v10) (type_ I64)) ((name s2) (type_ I64)))
       (((name v10) (type_ I64)) ((name s3) (type_ I64)))
       (((name v10) (type_ I64)) ((name s4) (type_ I64)))
       (((name v10) (type_ I64)) ((name s5) (type_ I64)))
       (((name v10) (type_ I64)) ((name s6) (type_ I64)))
       (((name v10) (type_ I64)) ((name s7) (type_ I64)))
       (((name v10) (type_ I64)) ((name s8) (type_ I64)))
       (((name v10) (type_ I64)) ((name s9) (type_ I64)))
       (((name v11) (type_ I64)) ((name v12) (type_ I64)))
       (((name v11) (type_ I64)) ((name v13) (type_ I64)))
       (((name v11) (type_ I64)) ((name v14) (type_ I64)))
       (((name v11) (type_ I64)) ((name v15) (type_ I64)))
       (((name v11) (type_ I64)) ((name v16) (type_ I64)))
       (((name v11) (type_ I64)) ((name v17) (type_ I64)))
       (((name v11) (type_ I64)) ((name v18) (type_ I64)))
       (((name v11) (type_ I64)) ((name v19) (type_ I64)))
       (((name v11) (type_ I64)) ((name v20) (type_ I64)))
       (((name v11) (type_ I64)) ((name s1) (type_ I64)))
       (((name v11) (type_ I64)) ((name s2) (type_ I64)))
       (((name v11) (type_ I64)) ((name s3) (type_ I64)))
       (((name v11) (type_ I64)) ((name s4) (type_ I64)))
       (((name v11) (type_ I64)) ((name s5) (type_ I64)))
       (((name v11) (type_ I64)) ((name s6) (type_ I64)))
       (((name v11) (type_ I64)) ((name s7) (type_ I64)))
       (((name v11) (type_ I64)) ((name s8) (type_ I64)))
       (((name v11) (type_ I64)) ((name s9) (type_ I64)))
       (((name v11) (type_ I64)) ((name s10) (type_ I64)))
       (((name v12) (type_ I64)) ((name v13) (type_ I64)))
       (((name v12) (type_ I64)) ((name v14) (type_ I64)))
       (((name v12) (type_ I64)) ((name v15) (type_ I64)))
       (((name v12) (type_ I64)) ((name v16) (type_ I64)))
       (((name v12) (type_ I64)) ((name v17) (type_ I64)))
       (((name v12) (type_ I64)) ((name v18) (type_ I64)))
       (((name v12) (type_ I64)) ((name v19) (type_ I64)))
       (((name v12) (type_ I64)) ((name v20) (type_ I64)))
       (((name v12) (type_ I64)) ((name s1) (type_ I64)))
       (((name v12) (type_ I64)) ((name s2) (type_ I64)))
       (((name v12) (type_ I64)) ((name s3) (type_ I64)))
       (((name v12) (type_ I64)) ((name s4) (type_ I64)))
       (((name v12) (type_ I64)) ((name s5) (type_ I64)))
       (((name v12) (type_ I64)) ((name s6) (type_ I64)))
       (((name v12) (type_ I64)) ((name s7) (type_ I64)))
       (((name v12) (type_ I64)) ((name s8) (type_ I64)))
       (((name v12) (type_ I64)) ((name s9) (type_ I64)))
       (((name v12) (type_ I64)) ((name s10) (type_ I64)))
       (((name v12) (type_ I64)) ((name s11) (type_ I64)))
       (((name v13) (type_ I64)) ((name v14) (type_ I64)))
       (((name v13) (type_ I64)) ((name v15) (type_ I64)))
       (((name v13) (type_ I64)) ((name v16) (type_ I64)))
       (((name v13) (type_ I64)) ((name v17) (type_ I64)))
       (((name v13) (type_ I64)) ((name v18) (type_ I64)))
       (((name v13) (type_ I64)) ((name v19) (type_ I64)))
       (((name v13) (type_ I64)) ((name v20) (type_ I64)))
       (((name v13) (type_ I64)) ((name s1) (type_ I64)))
       (((name v13) (type_ I64)) ((name s2) (type_ I64)))
       (((name v13) (type_ I64)) ((name s3) (type_ I64)))
       (((name v13) (type_ I64)) ((name s4) (type_ I64)))
       (((name v13) (type_ I64)) ((name s5) (type_ I64)))
       (((name v13) (type_ I64)) ((name s6) (type_ I64)))
       (((name v13) (type_ I64)) ((name s7) (type_ I64)))
       (((name v13) (type_ I64)) ((name s8) (type_ I64)))
       (((name v13) (type_ I64)) ((name s9) (type_ I64)))
       (((name v13) (type_ I64)) ((name s10) (type_ I64)))
       (((name v13) (type_ I64)) ((name s11) (type_ I64)))
       (((name v13) (type_ I64)) ((name s12) (type_ I64)))
       (((name v14) (type_ I64)) ((name v15) (type_ I64)))
       (((name v14) (type_ I64)) ((name v16) (type_ I64)))
       (((name v14) (type_ I64)) ((name v17) (type_ I64)))
       (((name v14) (type_ I64)) ((name v18) (type_ I64)))
       (((name v14) (type_ I64)) ((name v19) (type_ I64)))
       (((name v14) (type_ I64)) ((name v20) (type_ I64)))
       (((name v14) (type_ I64)) ((name s1) (type_ I64)))
       (((name v14) (type_ I64)) ((name s2) (type_ I64)))
       (((name v14) (type_ I64)) ((name s3) (type_ I64)))
       (((name v14) (type_ I64)) ((name s4) (type_ I64)))
       (((name v14) (type_ I64)) ((name s5) (type_ I64)))
       (((name v14) (type_ I64)) ((name s6) (type_ I64)))
       (((name v14) (type_ I64)) ((name s7) (type_ I64)))
       (((name v14) (type_ I64)) ((name s8) (type_ I64)))
       (((name v14) (type_ I64)) ((name s9) (type_ I64)))
       (((name v14) (type_ I64)) ((name s10) (type_ I64)))
       (((name v14) (type_ I64)) ((name s11) (type_ I64)))
       (((name v14) (type_ I64)) ((name s12) (type_ I64)))
       (((name v14) (type_ I64)) ((name s13) (type_ I64)))
       (((name v15) (type_ I64)) ((name v16) (type_ I64)))
       (((name v15) (type_ I64)) ((name v17) (type_ I64)))
       (((name v15) (type_ I64)) ((name v18) (type_ I64)))
       (((name v15) (type_ I64)) ((name v19) (type_ I64)))
       (((name v15) (type_ I64)) ((name v20) (type_ I64)))
       (((name v15) (type_ I64)) ((name s1) (type_ I64)))
       (((name v15) (type_ I64)) ((name s2) (type_ I64)))
       (((name v15) (type_ I64)) ((name s3) (type_ I64)))
       (((name v15) (type_ I64)) ((name s4) (type_ I64)))
       (((name v15) (type_ I64)) ((name s5) (type_ I64)))
       (((name v15) (type_ I64)) ((name s6) (type_ I64)))
       (((name v15) (type_ I64)) ((name s7) (type_ I64)))
       (((name v15) (type_ I64)) ((name s8) (type_ I64)))
       (((name v15) (type_ I64)) ((name s9) (type_ I64)))
       (((name v15) (type_ I64)) ((name s10) (type_ I64)))
       (((name v15) (type_ I64)) ((name s11) (type_ I64)))
       (((name v15) (type_ I64)) ((name s12) (type_ I64)))
       (((name v15) (type_ I64)) ((name s13) (type_ I64)))
       (((name v15) (type_ I64)) ((name s14) (type_ I64)))
       (((name v16) (type_ I64)) ((name v17) (type_ I64)))
       (((name v16) (type_ I64)) ((name v18) (type_ I64)))
       (((name v16) (type_ I64)) ((name v19) (type_ I64)))
       (((name v16) (type_ I64)) ((name v20) (type_ I64)))
       (((name v16) (type_ I64)) ((name s1) (type_ I64)))
       (((name v16) (type_ I64)) ((name s2) (type_ I64)))
       (((name v16) (type_ I64)) ((name s3) (type_ I64)))
       (((name v16) (type_ I64)) ((name s4) (type_ I64)))
       (((name v16) (type_ I64)) ((name s5) (type_ I64)))
       (((name v16) (type_ I64)) ((name s6) (type_ I64)))
       (((name v16) (type_ I64)) ((name s7) (type_ I64)))
       (((name v16) (type_ I64)) ((name s8) (type_ I64)))
       (((name v16) (type_ I64)) ((name s9) (type_ I64)))
       (((name v16) (type_ I64)) ((name s10) (type_ I64)))
       (((name v16) (type_ I64)) ((name s11) (type_ I64)))
       (((name v16) (type_ I64)) ((name s12) (type_ I64)))
       (((name v16) (type_ I64)) ((name s13) (type_ I64)))
       (((name v16) (type_ I64)) ((name s14) (type_ I64)))
       (((name v16) (type_ I64)) ((name s15) (type_ I64)))
       (((name v17) (type_ I64)) ((name v18) (type_ I64)))
       (((name v17) (type_ I64)) ((name v19) (type_ I64)))
       (((name v17) (type_ I64)) ((name v20) (type_ I64)))
       (((name v17) (type_ I64)) ((name s1) (type_ I64)))
       (((name v17) (type_ I64)) ((name s2) (type_ I64)))
       (((name v17) (type_ I64)) ((name s3) (type_ I64)))
       (((name v17) (type_ I64)) ((name s4) (type_ I64)))
       (((name v17) (type_ I64)) ((name s5) (type_ I64)))
       (((name v17) (type_ I64)) ((name s6) (type_ I64)))
       (((name v17) (type_ I64)) ((name s7) (type_ I64)))
       (((name v17) (type_ I64)) ((name s8) (type_ I64)))
       (((name v17) (type_ I64)) ((name s9) (type_ I64)))
       (((name v17) (type_ I64)) ((name s10) (type_ I64)))
       (((name v17) (type_ I64)) ((name s11) (type_ I64)))
       (((name v17) (type_ I64)) ((name s12) (type_ I64)))
       (((name v17) (type_ I64)) ((name s13) (type_ I64)))
       (((name v17) (type_ I64)) ((name s14) (type_ I64)))
       (((name v17) (type_ I64)) ((name s15) (type_ I64)))
       (((name v17) (type_ I64)) ((name s16) (type_ I64)))
       (((name v18) (type_ I64)) ((name v19) (type_ I64)))
       (((name v18) (type_ I64)) ((name v20) (type_ I64)))
       (((name v18) (type_ I64)) ((name s1) (type_ I64)))
       (((name v18) (type_ I64)) ((name s2) (type_ I64)))
       (((name v18) (type_ I64)) ((name s3) (type_ I64)))
       (((name v18) (type_ I64)) ((name s4) (type_ I64)))
       (((name v18) (type_ I64)) ((name s5) (type_ I64)))
       (((name v18) (type_ I64)) ((name s6) (type_ I64)))
       (((name v18) (type_ I64)) ((name s7) (type_ I64)))
       (((name v18) (type_ I64)) ((name s8) (type_ I64)))
       (((name v18) (type_ I64)) ((name s9) (type_ I64)))
       (((name v18) (type_ I64)) ((name s10) (type_ I64)))
       (((name v18) (type_ I64)) ((name s11) (type_ I64)))
       (((name v18) (type_ I64)) ((name s12) (type_ I64)))
       (((name v18) (type_ I64)) ((name s13) (type_ I64)))
       (((name v18) (type_ I64)) ((name s14) (type_ I64)))
       (((name v18) (type_ I64)) ((name s15) (type_ I64)))
       (((name v18) (type_ I64)) ((name s16) (type_ I64)))
       (((name v18) (type_ I64)) ((name s17) (type_ I64)))
       (((name v19) (type_ I64)) ((name v20) (type_ I64)))
       (((name v19) (type_ I64)) ((name s1) (type_ I64)))
       (((name v19) (type_ I64)) ((name s2) (type_ I64)))
       (((name v19) (type_ I64)) ((name s3) (type_ I64)))
       (((name v19) (type_ I64)) ((name s4) (type_ I64)))
       (((name v19) (type_ I64)) ((name s5) (type_ I64)))
       (((name v19) (type_ I64)) ((name s6) (type_ I64)))
       (((name v19) (type_ I64)) ((name s7) (type_ I64)))
       (((name v19) (type_ I64)) ((name s8) (type_ I64)))
       (((name v19) (type_ I64)) ((name s9) (type_ I64)))
       (((name v19) (type_ I64)) ((name s10) (type_ I64)))
       (((name v19) (type_ I64)) ((name s11) (type_ I64)))
       (((name v19) (type_ I64)) ((name s12) (type_ I64)))
       (((name v19) (type_ I64)) ((name s13) (type_ I64)))
       (((name v19) (type_ I64)) ((name s14) (type_ I64)))
       (((name v19) (type_ I64)) ((name s15) (type_ I64)))
       (((name v19) (type_ I64)) ((name s16) (type_ I64)))
       (((name v19) (type_ I64)) ((name s17) (type_ I64)))
       (((name v19) (type_ I64)) ((name s18) (type_ I64)))
       (((name v20) (type_ I64)) ((name s1) (type_ I64)))
       (((name v20) (type_ I64)) ((name s2) (type_ I64)))
       (((name v20) (type_ I64)) ((name s3) (type_ I64)))
       (((name v20) (type_ I64)) ((name s4) (type_ I64)))
       (((name v20) (type_ I64)) ((name s5) (type_ I64)))
       (((name v20) (type_ I64)) ((name s6) (type_ I64)))
       (((name v20) (type_ I64)) ((name s7) (type_ I64)))
       (((name v20) (type_ I64)) ((name s8) (type_ I64)))
       (((name v20) (type_ I64)) ((name s9) (type_ I64)))
       (((name v20) (type_ I64)) ((name s10) (type_ I64)))
       (((name v20) (type_ I64)) ((name s11) (type_ I64)))
       (((name v20) (type_ I64)) ((name s12) (type_ I64)))
       (((name v20) (type_ I64)) ((name s13) (type_ I64)))
       (((name v20) (type_ I64)) ((name s14) (type_ I64)))
       (((name v20) (type_ I64)) ((name s15) (type_ I64)))
       (((name v20) (type_ I64)) ((name s16) (type_ I64)))
       (((name v20) (type_ I64)) ((name s17) (type_ I64)))
       (((name v20) (type_ I64)) ((name s18) (type_ I64)))
       (((name v20) (type_ I64)) ((name result) (type_ I64))))
      |}]
;;

let%expect_test "borked" =
  compile_and_lower ~opt_flags:Eir.Opt_flags.no_opt borked;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl root
    root:
      sub rsp, 80
      push rbp
      push rbx
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 48
    root___root:
      mov r11, 1
      add r11, 0
      mov rbx, 2
      add rbx, 0
      mov r12, 3
      add r12, 0
      mov r13, 4
      add r13, 0
      mov qword ptr [rbp], 5
      add qword ptr [rbp], 0
      mov rdx, 6
      add rdx, 0
      mov qword ptr [rbp + 8], 7
      add qword ptr [rbp + 8], 0
      mov rax, 8
      add rax, 0
      mov rcx, 9
      add rcx, 0
      mov qword ptr [rbp + 16], 10
      add qword ptr [rbp + 16], 0
      mov qword ptr [rbp + 24], 11
      add qword ptr [rbp + 24], 0
      mov r9, 12
      add r9, 0
      mov qword ptr [rbp + 32], 13
      add qword ptr [rbp + 32], 0
      mov r15, 14
      add r15, 0
      mov qword ptr [rbp + 40], 15
      add qword ptr [rbp + 40], 0
      mov r10, 16
      add r10, 0
      mov r8, 17
      add r8, 0
      mov qword ptr [rbp + 48], 18
      add qword ptr [rbp + 48], 0
      mov qword ptr [rbp + 56], 19
      add qword ptr [rbp + 56], 0
      mov r14, 20
      add r14, 0
      add r11, rbx
      mov [rbp + 64], r11
      add [rbp + 64], r12
      push r11
      mov r11, [rbp + 64]
      mov [rbp + 72], r11
      pop r11
      add [rbp + 72], r13
      push r11
      mov r11, [rbp + 72]
      mov [rbp + 64], r11
      pop r11
      push r11
      mov r11, [rbp + 64]
      add r11, [rbp]
      mov [rbp + 64], r11
      pop r11
      mov r13, [rbp + 64]
      add r13, rdx
      mov [rbp], r13
      push r11
      mov r11, [rbp]
      add r11, [rbp + 8]
      mov [rbp], r11
      pop r11
      mov r13, [rbp]
      add r13, rax
      add r13, rcx
      mov [rbp], r13
      push r11
      mov r11, [rbp]
      add r11, [rbp + 16]
      mov [rbp], r11
      pop r11
      mov r13, [rbp]
      add r13, [rbp + 24]
      add r13, r9
      add r13, [rbp + 32]
      mov [rbp], r13
      add [rbp], r15
      push r11
      mov r11, [rbp]
      mov [rbp + 8], r11
      pop r11
      push r11
      mov r11, [rbp + 8]
      add r11, [rbp + 40]
      mov [rbp + 8], r11
      pop r11
      mov r15, [rbp + 8]
      add r15, r10
      mov [rbp], r15
      add [rbp], r8
      mov r15, [rbp]
      add r15, [rbp + 48]
      add r15, [rbp + 56]
      add r15, r14
      mov rax, r15
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 48
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbx
      pop rbp
      add rsp, 80
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "debug borked opt ssa" =
  test_ssa ~don't_opt:() borked;
  [%expect
    {|
    (%root
     (instrs
      ((Add ((dest ((name v1) (type_ I64))) (src1 (Lit 1)) (src2 (Lit 0))))
       (Add ((dest ((name v2) (type_ I64))) (src1 (Lit 2)) (src2 (Lit 0))))
       (Add ((dest ((name v3) (type_ I64))) (src1 (Lit 3)) (src2 (Lit 0))))
       (Add ((dest ((name v4) (type_ I64))) (src1 (Lit 4)) (src2 (Lit 0))))
       (Add ((dest ((name v5) (type_ I64))) (src1 (Lit 5)) (src2 (Lit 0))))
       (Add ((dest ((name v6) (type_ I64))) (src1 (Lit 6)) (src2 (Lit 0))))
       (Add ((dest ((name v7) (type_ I64))) (src1 (Lit 7)) (src2 (Lit 0))))
       (Add ((dest ((name v8) (type_ I64))) (src1 (Lit 8)) (src2 (Lit 0))))
       (Add ((dest ((name v9) (type_ I64))) (src1 (Lit 9)) (src2 (Lit 0))))
       (Add ((dest ((name v10) (type_ I64))) (src1 (Lit 10)) (src2 (Lit 0))))
       (Add ((dest ((name v11) (type_ I64))) (src1 (Lit 11)) (src2 (Lit 0))))
       (Add ((dest ((name v12) (type_ I64))) (src1 (Lit 12)) (src2 (Lit 0))))
       (Add ((dest ((name v13) (type_ I64))) (src1 (Lit 13)) (src2 (Lit 0))))
       (Add ((dest ((name v14) (type_ I64))) (src1 (Lit 14)) (src2 (Lit 0))))
       (Add ((dest ((name v15) (type_ I64))) (src1 (Lit 15)) (src2 (Lit 0))))
       (Add ((dest ((name v16) (type_ I64))) (src1 (Lit 16)) (src2 (Lit 0))))
       (Add ((dest ((name v17) (type_ I64))) (src1 (Lit 17)) (src2 (Lit 0))))
       (Add ((dest ((name v18) (type_ I64))) (src1 (Lit 18)) (src2 (Lit 0))))
       (Add ((dest ((name v19) (type_ I64))) (src1 (Lit 19)) (src2 (Lit 0))))
       (Add ((dest ((name v20) (type_ I64))) (src1 (Lit 20)) (src2 (Lit 0))))
       (Add
        ((dest ((name s1) (type_ I64))) (src1 (Var ((name v1) (type_ I64))))
         (src2 (Var ((name v2) (type_ I64))))))
       (Add
        ((dest ((name s2) (type_ I64))) (src1 (Var ((name s1) (type_ I64))))
         (src2 (Var ((name v3) (type_ I64))))))
       (Add
        ((dest ((name s3) (type_ I64))) (src1 (Var ((name s2) (type_ I64))))
         (src2 (Var ((name v4) (type_ I64))))))
       (Add
        ((dest ((name s4) (type_ I64))) (src1 (Var ((name s3) (type_ I64))))
         (src2 (Var ((name v5) (type_ I64))))))
       (Add
        ((dest ((name s5) (type_ I64))) (src1 (Var ((name s4) (type_ I64))))
         (src2 (Var ((name v6) (type_ I64))))))
       (Add
        ((dest ((name s6) (type_ I64))) (src1 (Var ((name s5) (type_ I64))))
         (src2 (Var ((name v7) (type_ I64))))))
       (Add
        ((dest ((name s7) (type_ I64))) (src1 (Var ((name s6) (type_ I64))))
         (src2 (Var ((name v8) (type_ I64))))))
       (Add
        ((dest ((name s8) (type_ I64))) (src1 (Var ((name s7) (type_ I64))))
         (src2 (Var ((name v9) (type_ I64))))))
       (Add
        ((dest ((name s9) (type_ I64))) (src1 (Var ((name s8) (type_ I64))))
         (src2 (Var ((name v10) (type_ I64))))))
       (Add
        ((dest ((name s10) (type_ I64))) (src1 (Var ((name s9) (type_ I64))))
         (src2 (Var ((name v11) (type_ I64))))))
       (Add
        ((dest ((name s11) (type_ I64))) (src1 (Var ((name s10) (type_ I64))))
         (src2 (Var ((name v12) (type_ I64))))))
       (Add
        ((dest ((name s12) (type_ I64))) (src1 (Var ((name s11) (type_ I64))))
         (src2 (Var ((name v13) (type_ I64))))))
       (Add
        ((dest ((name s13) (type_ I64))) (src1 (Var ((name s12) (type_ I64))))
         (src2 (Var ((name v14) (type_ I64))))))
       (Add
        ((dest ((name s14) (type_ I64))) (src1 (Var ((name s13) (type_ I64))))
         (src2 (Var ((name v15) (type_ I64))))))
       (Add
        ((dest ((name s15) (type_ I64))) (src1 (Var ((name s14) (type_ I64))))
         (src2 (Var ((name v16) (type_ I64))))))
       (Add
        ((dest ((name s16) (type_ I64))) (src1 (Var ((name s15) (type_ I64))))
         (src2 (Var ((name v17) (type_ I64))))))
       (Add
        ((dest ((name s17) (type_ I64))) (src1 (Var ((name s16) (type_ I64))))
         (src2 (Var ((name v18) (type_ I64))))))
       (Add
        ((dest ((name s18) (type_ I64))) (src1 (Var ((name s17) (type_ I64))))
         (src2 (Var ((name v19) (type_ I64))))))
       (Add
        ((dest ((name result) (type_ I64))) (src1 (Var ((name s18) (type_ I64))))
         (src2 (Var ((name v20) (type_ I64))))))
       (Return (Var ((name result) (type_ I64)))))))
    =================================
    (%root (args ())
     (instrs
      ((Add ((dest ((name v1) (type_ I64))) (src1 (Lit 1)) (src2 (Lit 0))))
       (Add ((dest ((name v2) (type_ I64))) (src1 (Lit 2)) (src2 (Lit 0))))
       (Add ((dest ((name v3) (type_ I64))) (src1 (Lit 3)) (src2 (Lit 0))))
       (Add ((dest ((name v4) (type_ I64))) (src1 (Lit 4)) (src2 (Lit 0))))
       (Add ((dest ((name v5) (type_ I64))) (src1 (Lit 5)) (src2 (Lit 0))))
       (Add ((dest ((name v6) (type_ I64))) (src1 (Lit 6)) (src2 (Lit 0))))
       (Add ((dest ((name v7) (type_ I64))) (src1 (Lit 7)) (src2 (Lit 0))))
       (Add ((dest ((name v8) (type_ I64))) (src1 (Lit 8)) (src2 (Lit 0))))
       (Add ((dest ((name v9) (type_ I64))) (src1 (Lit 9)) (src2 (Lit 0))))
       (Add ((dest ((name v10) (type_ I64))) (src1 (Lit 10)) (src2 (Lit 0))))
       (Add ((dest ((name v11) (type_ I64))) (src1 (Lit 11)) (src2 (Lit 0))))
       (Add ((dest ((name v12) (type_ I64))) (src1 (Lit 12)) (src2 (Lit 0))))
       (Add ((dest ((name v13) (type_ I64))) (src1 (Lit 13)) (src2 (Lit 0))))
       (Add ((dest ((name v14) (type_ I64))) (src1 (Lit 14)) (src2 (Lit 0))))
       (Add ((dest ((name v15) (type_ I64))) (src1 (Lit 15)) (src2 (Lit 0))))
       (Add ((dest ((name v16) (type_ I64))) (src1 (Lit 16)) (src2 (Lit 0))))
       (Add ((dest ((name v17) (type_ I64))) (src1 (Lit 17)) (src2 (Lit 0))))
       (Add ((dest ((name v18) (type_ I64))) (src1 (Lit 18)) (src2 (Lit 0))))
       (Add ((dest ((name v19) (type_ I64))) (src1 (Lit 19)) (src2 (Lit 0))))
       (Add ((dest ((name v20) (type_ I64))) (src1 (Lit 20)) (src2 (Lit 0))))
       (Add
        ((dest ((name s1) (type_ I64))) (src1 (Var ((name v1) (type_ I64))))
         (src2 (Var ((name v2) (type_ I64))))))
       (Add
        ((dest ((name s2) (type_ I64))) (src1 (Var ((name s1) (type_ I64))))
         (src2 (Var ((name v3) (type_ I64))))))
       (Add
        ((dest ((name s3) (type_ I64))) (src1 (Var ((name s2) (type_ I64))))
         (src2 (Var ((name v4) (type_ I64))))))
       (Add
        ((dest ((name s4) (type_ I64))) (src1 (Var ((name s3) (type_ I64))))
         (src2 (Var ((name v5) (type_ I64))))))
       (Add
        ((dest ((name s5) (type_ I64))) (src1 (Var ((name s4) (type_ I64))))
         (src2 (Var ((name v6) (type_ I64))))))
       (Add
        ((dest ((name s6) (type_ I64))) (src1 (Var ((name s5) (type_ I64))))
         (src2 (Var ((name v7) (type_ I64))))))
       (Add
        ((dest ((name s7) (type_ I64))) (src1 (Var ((name s6) (type_ I64))))
         (src2 (Var ((name v8) (type_ I64))))))
       (Add
        ((dest ((name s8) (type_ I64))) (src1 (Var ((name s7) (type_ I64))))
         (src2 (Var ((name v9) (type_ I64))))))
       (Add
        ((dest ((name s9) (type_ I64))) (src1 (Var ((name s8) (type_ I64))))
         (src2 (Var ((name v10) (type_ I64))))))
       (Add
        ((dest ((name s10) (type_ I64))) (src1 (Var ((name s9) (type_ I64))))
         (src2 (Var ((name v11) (type_ I64))))))
       (Add
        ((dest ((name s11) (type_ I64))) (src1 (Var ((name s10) (type_ I64))))
         (src2 (Var ((name v12) (type_ I64))))))
       (Add
        ((dest ((name s12) (type_ I64))) (src1 (Var ((name s11) (type_ I64))))
         (src2 (Var ((name v13) (type_ I64))))))
       (Add
        ((dest ((name s13) (type_ I64))) (src1 (Var ((name s12) (type_ I64))))
         (src2 (Var ((name v14) (type_ I64))))))
       (Add
        ((dest ((name s14) (type_ I64))) (src1 (Var ((name s13) (type_ I64))))
         (src2 (Var ((name v15) (type_ I64))))))
       (Add
        ((dest ((name s15) (type_ I64))) (src1 (Var ((name s14) (type_ I64))))
         (src2 (Var ((name v16) (type_ I64))))))
       (Add
        ((dest ((name s16) (type_ I64))) (src1 (Var ((name s15) (type_ I64))))
         (src2 (Var ((name v17) (type_ I64))))))
       (Add
        ((dest ((name s17) (type_ I64))) (src1 (Var ((name s16) (type_ I64))))
         (src2 (Var ((name v18) (type_ I64))))))
       (Add
        ((dest ((name s18) (type_ I64))) (src1 (Var ((name s17) (type_ I64))))
         (src2 (Var ((name v19) (type_ I64))))))
       (Add
        ((dest ((name result) (type_ I64))) (src1 (Var ((name s18) (type_ I64))))
         (src2 (Var ((name v20) (type_ I64))))))
       (Return (Var ((name result) (type_ I64)))))))
    |}]
;;

let%expect_test "debug borked opt x86" =
  test ~opt_flags:Eir.Opt_flags.no_opt borked;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 80)))
           (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg RBX) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R12) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R13) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (ADD (Reg ((reg RBP) (class_ I64))) (Imm 48)))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum %root) (args ()))) (args ())))))))
        (%root (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R11) (class_ I64))) (Imm 1)))
           (X86 (ADD (Reg ((reg R11) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg RBX) (class_ I64))) (Imm 2)))
           (X86 (ADD (Reg ((reg RBX) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg R12) (class_ I64))) (Imm 3)))
           (X86 (ADD (Reg ((reg R12) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg R13) (class_ I64))) (Imm 4)))
           (X86 (ADD (Reg ((reg R13) (class_ I64))) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 0) (Imm 5)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 0) (Imm 0)))
           (X86 (MOV (Reg ((reg RDX) (class_ I64))) (Imm 6)))
           (X86 (ADD (Reg ((reg RDX) (class_ I64))) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 8) (Imm 7)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 8) (Imm 0)))
           (X86 (MOV (Reg ((reg RAX) (class_ I64))) (Imm 8)))
           (X86 (ADD (Reg ((reg RAX) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg RCX) (class_ I64))) (Imm 9)))
           (X86 (ADD (Reg ((reg RCX) (class_ I64))) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 16) (Imm 10)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 16) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 24) (Imm 11)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 24) (Imm 0)))
           (X86 (MOV (Reg ((reg R9) (class_ I64))) (Imm 12)))
           (X86 (ADD (Reg ((reg R9) (class_ I64))) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 32) (Imm 13)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 32) (Imm 0)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 14)))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 40) (Imm 15)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 40) (Imm 0)))
           (X86 (MOV (Reg ((reg R10) (class_ I64))) (Imm 16)))
           (X86 (ADD (Reg ((reg R10) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg R8) (class_ I64))) (Imm 17)))
           (X86 (ADD (Reg ((reg R8) (class_ I64))) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 48) (Imm 18)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 48) (Imm 0)))
           (X86 (MOV (Mem ((reg RBP) (class_ I64)) 56) (Imm 19)))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 56) (Imm 0)))
           (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 20)))
           (X86 (ADD (Reg ((reg R14) (class_ I64))) (Imm 0)))
           (X86
            (MOV (Reg ((reg R11) (class_ I64))) (Reg ((reg R11) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R11) (class_ I64))) (Reg ((reg RBX) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 64)
             (Reg ((reg R11) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 64)
             (Reg ((reg R12) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 72)
             (Mem ((reg RBP) (class_ I64)) 64)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 72)
             (Reg ((reg R13) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 64)
             (Mem ((reg RBP) (class_ I64)) 72)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 64)
             (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64)))
             (Mem ((reg RBP) (class_ I64)) 64)))
           (X86
            (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0)
             (Mem ((reg RBP) (class_ I64)) 8)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg RCX) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0)
             (Mem ((reg RBP) (class_ I64)) 16)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Reg ((reg R13) (class_ I64)))
             (Mem ((reg RBP) (class_ I64)) 24)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg R9) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R13) (class_ I64)))
             (Mem ((reg RBP) (class_ I64)) 32)))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 8)
             (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 8)
             (Mem ((reg RBP) (class_ I64)) 40)))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 8)))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R10) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R15) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R8) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Reg ((reg R15) (class_ I64)))
             (Mem ((reg RBP) (class_ I64)) 48)))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R15) (class_ I64)))
             (Mem ((reg RBP) (class_ I64)) 56)))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 48)))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg R13) (class_ I64))))
           (X86 (POP ((reg R12) (class_ I64))))
           (X86 (POP ((reg RBX) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (ADD (Reg ((reg RSP) (class_ I64))) (Imm 80)))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
      (bytes_for_spills 80) (bytes_for_clobber_saves 48)))
    |}]
;;

let%expect_test "debug borked" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | block          | instruction                                                                                                                              | live_in                                                                                                                                                                                                                                                                                                                                                                                                                                                               | live_out                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | (block start(args()))                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                          | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | (X86(JMP((block((id_hum %root)(args())))(args()))))                                                                                      | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | block end                                                                                                                                | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (block start(args()))                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v1)(type_ I64))))(class_ I64)))(Imm 1)))                                                             | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | (((name v1)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v1)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                              | (((name v1)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v2)(type_ I64))))(class_ I64)))(Imm 2)))                                                             | (((name v1)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                              | (((name v1)(type_ I64))((name v2)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                        |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v2)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                        | (((name v1)(type_ I64))((name v2)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                        |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v3)(type_ I64))))(class_ I64)))(Imm 3)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                        | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                  |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v3)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                  | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                  |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v4)(type_ I64))))(class_ I64)))(Imm 4)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                  | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                            |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v4)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                            |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v5)(type_ I64))))(class_ I64)))(Imm 5)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                      |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v5)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                      | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                      |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v6)(type_ I64))))(class_ I64)))(Imm 6)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                      | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64)))                                                                                                                                                                                                                                                                                                                                |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v6)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64)))                                                                                                                                                                                                                                                                                                                                | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64)))                                                                                                                                                                                                                                                                                                                                |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v7)(type_ I64))))(class_ I64)))(Imm 7)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64)))                                                                                                                                                                                                                                                                                                                                | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64)))                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v7)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64)))                                                                                                                                                                                                                                                                                                          | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64)))                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v8)(type_ I64))))(class_ I64)))(Imm 8)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64)))                                                                                                                                                                                                                                                                                                          | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64)))                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v8)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64)))                                                                                                                                                                                                                                                                                    | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64)))                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v9)(type_ I64))))(class_ I64)))(Imm 9)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64)))                                                                                                                                                                                                                                                                                    | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64)))                                                                                                                                                                                                                                                              |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v9)(type_ I64))))(class_ I64)))(Imm 0)))                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64)))                                                                                                                                                                                                                                                              | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64)))                                                                                                                                                                                                                                                              |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v10)(type_ I64))))(class_ I64)))(Imm 10)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64)))                                                                                                                                                                                                                                                              | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64)))                                                                                                                                                                                                                                       |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v10)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64)))                                                                                                                                                                                                                                       | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64)))                                                                                                                                                                                                                                       |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v11)(type_ I64))))(class_ I64)))(Imm 11)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64)))                                                                                                                                                                                                                                       | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64)))                                                                                                                                                                                                                |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v11)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64)))                                                                                                                                                                                                                | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64)))                                                                                                                                                                                                                |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v12)(type_ I64))))(class_ I64)))(Imm 12)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64)))                                                                                                                                                                                                                | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64)))                                                                                                                                                                                         |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v12)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64)))                                                                                                                                                                                         | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64)))                                                                                                                                                                                         |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v13)(type_ I64))))(class_ I64)))(Imm 13)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64)))                                                                                                                                                                                         | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64)))                                                                                                                                                                  |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v13)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64)))                                                                                                                                                                  | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64)))                                                                                                                                                                  |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v14)(type_ I64))))(class_ I64)))(Imm 14)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64)))                                                                                                                                                                  | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64)))                                                                                                                                           |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v14)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64)))                                                                                                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64)))                                                                                                                                           |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v15)(type_ I64))))(class_ I64)))(Imm 15)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64)))                                                                                                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64)))                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v15)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64)))                                                                                                                    | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64)))                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v16)(type_ I64))))(class_ I64)))(Imm 16)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64)))                                                                                                                    | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64)))                                                                                             |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v16)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64)))                                                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64)))                                                                                             |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v17)(type_ I64))))(class_ I64)))(Imm 17)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64)))                                                                                             | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64)))                                                                      |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v17)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64)))                                                                      | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64)))                                                                      |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v18)(type_ I64))))(class_ I64)))(Imm 18)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64)))                                                                      | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64)))                                               |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v18)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64)))                                               | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64)))                                               |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v19)(type_ I64))))(class_ I64)))(Imm 19)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64)))                                               | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64)))                        |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v19)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64)))                        | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64)))                        |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name v20)(type_ I64))))(class_ I64)))(Imm 20)))                                                           | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64)))                        | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))) |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name v20)(type_ I64))))(class_ I64)))(Imm 0)))                                                            | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))) | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))) |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v1)(type_ I64))))(class_ I64)))))         | (((name v1)(type_ I64))((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))) | (((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s1)(type_ I64))) |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v2)(type_ I64))))(class_ I64)))))         | (((name v2)(type_ I64))((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s1)(type_ I64))) | (((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s1)(type_ I64)))                       |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s1)(type_ I64))))(class_ I64)))))         | (((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s1)(type_ I64)))                       | (((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s2)(type_ I64)))                       |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v3)(type_ I64))))(class_ I64)))))         | (((name v3)(type_ I64))((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s2)(type_ I64)))                       | (((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s2)(type_ I64)))                                             |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s2)(type_ I64))))(class_ I64)))))         | (((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s2)(type_ I64)))                                             | (((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s3)(type_ I64)))                                             |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v4)(type_ I64))))(class_ I64)))))         | (((name v4)(type_ I64))((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s3)(type_ I64)))                                             | (((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s3)(type_ I64)))                                                                   |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s3)(type_ I64))))(class_ I64)))))         | (((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s3)(type_ I64)))                                                                   | (((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s4)(type_ I64)))                                                                   |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v5)(type_ I64))))(class_ I64)))))         | (((name v5)(type_ I64))((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s4)(type_ I64)))                                                                   | (((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s4)(type_ I64)))                                                                                         |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s4)(type_ I64))))(class_ I64)))))         | (((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s4)(type_ I64)))                                                                                         | (((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s5)(type_ I64)))                                                                                         |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v6)(type_ I64))))(class_ I64)))))         | (((name v6)(type_ I64))((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s5)(type_ I64)))                                                                                         | (((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s5)(type_ I64)))                                                                                                               |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s5)(type_ I64))))(class_ I64)))))         | (((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s5)(type_ I64)))                                                                                                               | (((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s6)(type_ I64)))                                                                                                               |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v7)(type_ I64))))(class_ I64)))))         | (((name v7)(type_ I64))((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s6)(type_ I64)))                                                                                                               | (((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s6)(type_ I64)))                                                                                                                                     |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s6)(type_ I64))))(class_ I64)))))         | (((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s6)(type_ I64)))                                                                                                                                     | (((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s7)(type_ I64)))                                                                                                                                     |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v8)(type_ I64))))(class_ I64)))))         | (((name v8)(type_ I64))((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s7)(type_ I64)))                                                                                                                                     | (((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s7)(type_ I64)))                                                                                                                                                           |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s7)(type_ I64))))(class_ I64)))))         | (((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s7)(type_ I64)))                                                                                                                                                           | (((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                           |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v9)(type_ I64))))(class_ I64)))))         | (((name v9)(type_ I64))((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                           | (((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                                                 |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s8)(type_ I64))))(class_ I64)))))         | (((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                                                 | (((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                                 |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v10)(type_ I64))))(class_ I64)))))        | (((name v10)(type_ I64))((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                                 | (((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                                                        |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s9)(type_ I64))))(class_ I64)))))        | (((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                                                        | (((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                                       |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v11)(type_ I64))))(class_ I64)))))       | (((name v11)(type_ I64))((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                                       | (((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                                                              |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s10)(type_ I64))))(class_ I64)))))       | (((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                                                              | (((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                              |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v12)(type_ I64))))(class_ I64)))))       | (((name v12)(type_ I64))((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                              | (((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                                                     |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s11)(type_ I64))))(class_ I64)))))       | (((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                                                     | (((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s12)(type_ I64)))                                                                                                                                                                                                                                                     |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v13)(type_ I64))))(class_ I64)))))       | (((name v13)(type_ I64))((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s12)(type_ I64)))                                                                                                                                                                                                                                                     | (((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s12)(type_ I64)))                                                                                                                                                                                                                                                                            |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s12)(type_ I64))))(class_ I64)))))       | (((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s12)(type_ I64)))                                                                                                                                                                                                                                                                            | (((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s13)(type_ I64)))                                                                                                                                                                                                                                                                            |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v14)(type_ I64))))(class_ I64)))))       | (((name v14)(type_ I64))((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s13)(type_ I64)))                                                                                                                                                                                                                                                                            | (((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s13)(type_ I64)))                                                                                                                                                                                                                                                                                                   |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s13)(type_ I64))))(class_ I64)))))       | (((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s13)(type_ I64)))                                                                                                                                                                                                                                                                                                   | (((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s14)(type_ I64)))                                                                                                                                                                                                                                                                                                   |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v15)(type_ I64))))(class_ I64)))))       | (((name v15)(type_ I64))((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s14)(type_ I64)))                                                                                                                                                                                                                                                                                                   | (((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s14)(type_ I64)))                                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s15)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s14)(type_ I64))))(class_ I64)))))       | (((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s14)(type_ I64)))                                                                                                                                                                                                                                                                                                                          | (((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s15)(type_ I64)))                                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s15)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v16)(type_ I64))))(class_ I64)))))       | (((name v16)(type_ I64))((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s15)(type_ I64)))                                                                                                                                                                                                                                                                                                                          | (((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s15)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                 |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s16)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s15)(type_ I64))))(class_ I64)))))       | (((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s15)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                 | (((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s16)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                 |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s16)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v17)(type_ I64))))(class_ I64)))))       | (((name v17)(type_ I64))((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s16)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                 | (((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s16)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                        |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s17)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s16)(type_ I64))))(class_ I64)))))       | (((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s16)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                        | (((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s17)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                        |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s17)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v18)(type_ I64))))(class_ I64)))))       | (((name v18)(type_ I64))((name v19)(type_ I64))((name v20)(type_ I64))((name s17)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                        | (((name v19)(type_ I64))((name v20)(type_ I64))((name s17)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                               |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s18)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s17)(type_ I64))))(class_ I64)))))       | (((name v19)(type_ I64))((name v20)(type_ I64))((name s17)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                               | (((name v19)(type_ I64))((name v20)(type_ I64))((name s18)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                               |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s18)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v19)(type_ I64))))(class_ I64)))))       | (((name v19)(type_ I64))((name v20)(type_ I64))((name s18)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                               | (((name v20)(type_ I64))((name s18)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                      |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s18)(type_ I64))))(class_ I64)))))    | (((name v20)(type_ I64))((name s18)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                      | (((name v20)(type_ I64))((name result)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                   |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name v20)(type_ I64))))(class_ I64)))))    | (((name v20)(type_ I64))((name result)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                   | (((name result)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64))))) | (((name result)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          | (((name result)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86_terminal((JMP((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name result)(type_ I64))))))))              | (((name result)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | block end                                                                                                                                | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | (block start(args(((name res__0)(type_ I64)))))                                                                                          | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64)))))                                 | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                                                           | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                                                                                                                                                                                                          | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | block end                                                                                                                                | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      +----------------+------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |}]
;;

let%expect_test "debug borked opt" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.default borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | block          | instruction                                                                                                                               | live_in                       | live_out                      |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | (block start(args()))                                                                                                                     | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                           | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | (X86(JMP((block((id_hum %root)(args())))(args()))))                                                                                       | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | block end                                                                                                                                 | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (block start(args()))                                                                                                                     | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name res__00)(type_ I64))))(class_ I64)))(Imm 210)))                                                       | {}                            | (((name res__00)(type_ I64))) |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name res__00)(type_ I64))))(class_ I64))))) | (((name res__00)(type_ I64))) | (((name res__00)(type_ I64))) |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (X86_terminal((JMP((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res__00)(type_ I64))))))))              | (((name res__00)(type_ I64))) | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | block end                                                                                                                                 | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | (block start(args(((name res__0)(type_ I64)))))                                                                                           | {}                            | (((name res__0)(type_ I64)))  |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64)))))                                  | (((name res__0)(type_ I64)))  | (((name res__0)(type_ I64)))  |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                                                            | (((name res__0)(type_ I64)))  | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | block end                                                                                                                                 | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      |}]
;;
