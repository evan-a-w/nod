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
root(%x:i64) {
    add %a1:i64, %x, 1
    add %a2:i64, %x, 2
    add %a3:i64, %x, 3
    add %a4:i64, %x, 4
    add %a5:i64, %x, 5
    add %a6:i64, %x, 6
    add %a7:i64, %x, 7
    add %a8:i64, %x, 8
    add %a9:i64, %x, 9
    add %a10:i64, %x, 10
    add %a11:i64, %x, 11
    add %a12:i64, %x, 12
    add %a13:i64, %x, 13
    add %a14:i64, %x, 14
    add %a15:i64, %x, 15
    call helper(%x) -> %tmp:i64
    add %r1:i64, %a1, %a2
    add %r2:i64, %r1, %a3
    add %r3:i64, %r2, %a4
    add %r4:i64, %r3, %a5
    add %r5:i64, %r4, %a6
    add %r6:i64, %r5, %a7
    add %r7:i64, %r6, %a8
    add %r8:i64, %r7, %a9
    add %r9:i64, %r8, %a10
    add %r10:i64, %r9, %a11
    add %r11:i64, %r10, %a12
    add %r12:i64, %r11, %a13
    add %r13:i64, %r12, %a14
    add %r14:i64, %r13, %a15
    add %result:i64, %r14, %tmp
    ret %result
}

helper(%x:i64) {
    mul %result:i64, %x, 100
    ret %result
}
|}
;;

let%expect_test "run" =
  let output =
    compile_and_execute
      ~harness:
        (make_harness_source
           ~fn_name:"root"
           ~fn_arg_type:"int"
           ~fn_arg:"5"
           ())
      ~opt_flags:Eir.Opt_flags.no_opt
      borked
  in
  assert (String.equal output "695")
;;

let%expect_test "borked regaloc" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_assignments functions;
    [%expect
      {|
      ((function_name helper)
       (assignments
        ((((name res__0) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name result) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name tmp_clobber) (type_ I64)) (Reg ((reg RDX) (class_ I64))))
         (((name tmp_dst) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name tmp_imm) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name tmp_rax) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name x) (type_ I64)) (Reg ((reg R14) (class_ I64))))
         (((name x0) (type_ I64)) (Reg ((reg RDI) (class_ I64)))))))
      ((((name x) (type_ I64)) ((name tmp_imm) (type_ I64)))
       (((name tmp_imm) (type_ I64)) ((name tmp_rax) (type_ I64)))
       (((name tmp_clobber) (type_ I64)) ((name tmp_dst) (type_ I64))))
      ((function_name root)
       (assignments
        ((((name a1) (type_ I64)) Spill)
         (((name a10) (type_ I64)) (Reg ((reg R11) (class_ I64))))
         (((name a11) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name a12) (type_ I64)) (Reg ((reg RCX) (class_ I64))))
         (((name a13) (type_ I64)) Spill)
         (((name a14) (type_ I64)) (Reg ((reg RBX) (class_ I64))))
         (((name a15) (type_ I64)) (Reg ((reg R10) (class_ I64))))
         (((name a2) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name a3) (type_ I64)) Spill) (((name a4) (type_ I64)) Spill)
         (((name a5) (type_ I64)) (Reg ((reg R14) (class_ I64))))
         (((name a6) (type_ I64)) (Reg ((reg R9) (class_ I64))))
         (((name a7) (type_ I64)) (Reg ((reg R12) (class_ I64))))
         (((name a8) (type_ I64)) (Reg ((reg R8) (class_ I64))))
         (((name a9) (type_ I64)) (Reg ((reg RDX) (class_ I64))))
         (((name arg_reg) (type_ I64)) (Reg ((reg RDI) (class_ I64))))
         (((name r1) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name r10) (type_ I64)) Spill)
         (((name r11) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name r12) (type_ I64)) Spill) (((name r13) (type_ I64)) Spill)
         (((name r14) (type_ I64)) Spill) (((name r2) (type_ I64)) Spill)
         (((name r3) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name r4) (type_ I64)) Spill) (((name r5) (type_ I64)) Spill)
         (((name r6) (type_ I64)) Spill) (((name r7) (type_ I64)) Spill)
         (((name r8) (type_ I64)) Spill)
         (((name r9) (type_ I64)) (Reg ((reg R14) (class_ I64))))
         (((name res__0) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name result) (type_ I64)) Spill) (((name tmp) (type_ I64)) Spill)
         (((name tmp_force_physical) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name x) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name x16) (type_ I64)) (Reg ((reg RDI) (class_ I64)))))))
      ((((name x) (type_ I64)) ((name a1) (type_ I64)))
       (((name x) (type_ I64)) ((name a2) (type_ I64)))
       (((name x) (type_ I64)) ((name a3) (type_ I64)))
       (((name x) (type_ I64)) ((name a4) (type_ I64)))
       (((name x) (type_ I64)) ((name a5) (type_ I64)))
       (((name x) (type_ I64)) ((name a6) (type_ I64)))
       (((name x) (type_ I64)) ((name a7) (type_ I64)))
       (((name x) (type_ I64)) ((name a8) (type_ I64)))
       (((name x) (type_ I64)) ((name a9) (type_ I64)))
       (((name x) (type_ I64)) ((name a10) (type_ I64)))
       (((name x) (type_ I64)) ((name a11) (type_ I64)))
       (((name x) (type_ I64)) ((name a12) (type_ I64)))
       (((name x) (type_ I64)) ((name a13) (type_ I64)))
       (((name x) (type_ I64)) ((name a14) (type_ I64)))
       (((name x) (type_ I64)) ((name a15) (type_ I64)))
       (((name x) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a1) (type_ I64)) ((name a2) (type_ I64)))
       (((name a1) (type_ I64)) ((name a3) (type_ I64)))
       (((name a1) (type_ I64)) ((name a4) (type_ I64)))
       (((name a1) (type_ I64)) ((name a5) (type_ I64)))
       (((name a1) (type_ I64)) ((name a6) (type_ I64)))
       (((name a1) (type_ I64)) ((name a7) (type_ I64)))
       (((name a1) (type_ I64)) ((name a8) (type_ I64)))
       (((name a1) (type_ I64)) ((name a9) (type_ I64)))
       (((name a1) (type_ I64)) ((name a10) (type_ I64)))
       (((name a1) (type_ I64)) ((name a11) (type_ I64)))
       (((name a1) (type_ I64)) ((name a12) (type_ I64)))
       (((name a1) (type_ I64)) ((name a13) (type_ I64)))
       (((name a1) (type_ I64)) ((name a14) (type_ I64)))
       (((name a1) (type_ I64)) ((name a15) (type_ I64)))
       (((name a1) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a1) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a1) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a2) (type_ I64)) ((name a3) (type_ I64)))
       (((name a2) (type_ I64)) ((name a4) (type_ I64)))
       (((name a2) (type_ I64)) ((name a5) (type_ I64)))
       (((name a2) (type_ I64)) ((name a6) (type_ I64)))
       (((name a2) (type_ I64)) ((name a7) (type_ I64)))
       (((name a2) (type_ I64)) ((name a8) (type_ I64)))
       (((name a2) (type_ I64)) ((name a9) (type_ I64)))
       (((name a2) (type_ I64)) ((name a10) (type_ I64)))
       (((name a2) (type_ I64)) ((name a11) (type_ I64)))
       (((name a2) (type_ I64)) ((name a12) (type_ I64)))
       (((name a2) (type_ I64)) ((name a13) (type_ I64)))
       (((name a2) (type_ I64)) ((name a14) (type_ I64)))
       (((name a2) (type_ I64)) ((name a15) (type_ I64)))
       (((name a2) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a2) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a2) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a2) (type_ I64)) ((name r1) (type_ I64)))
       (((name a3) (type_ I64)) ((name a4) (type_ I64)))
       (((name a3) (type_ I64)) ((name a5) (type_ I64)))
       (((name a3) (type_ I64)) ((name a6) (type_ I64)))
       (((name a3) (type_ I64)) ((name a7) (type_ I64)))
       (((name a3) (type_ I64)) ((name a8) (type_ I64)))
       (((name a3) (type_ I64)) ((name a9) (type_ I64)))
       (((name a3) (type_ I64)) ((name a10) (type_ I64)))
       (((name a3) (type_ I64)) ((name a11) (type_ I64)))
       (((name a3) (type_ I64)) ((name a12) (type_ I64)))
       (((name a3) (type_ I64)) ((name a13) (type_ I64)))
       (((name a3) (type_ I64)) ((name a14) (type_ I64)))
       (((name a3) (type_ I64)) ((name a15) (type_ I64)))
       (((name a3) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a3) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a3) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a3) (type_ I64)) ((name r1) (type_ I64)))
       (((name a3) (type_ I64)) ((name r2) (type_ I64)))
       (((name a4) (type_ I64)) ((name a5) (type_ I64)))
       (((name a4) (type_ I64)) ((name a6) (type_ I64)))
       (((name a4) (type_ I64)) ((name a7) (type_ I64)))
       (((name a4) (type_ I64)) ((name a8) (type_ I64)))
       (((name a4) (type_ I64)) ((name a9) (type_ I64)))
       (((name a4) (type_ I64)) ((name a10) (type_ I64)))
       (((name a4) (type_ I64)) ((name a11) (type_ I64)))
       (((name a4) (type_ I64)) ((name a12) (type_ I64)))
       (((name a4) (type_ I64)) ((name a13) (type_ I64)))
       (((name a4) (type_ I64)) ((name a14) (type_ I64)))
       (((name a4) (type_ I64)) ((name a15) (type_ I64)))
       (((name a4) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a4) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a4) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a4) (type_ I64)) ((name r1) (type_ I64)))
       (((name a4) (type_ I64)) ((name r2) (type_ I64)))
       (((name a4) (type_ I64)) ((name r3) (type_ I64)))
       (((name a5) (type_ I64)) ((name a6) (type_ I64)))
       (((name a5) (type_ I64)) ((name a7) (type_ I64)))
       (((name a5) (type_ I64)) ((name a8) (type_ I64)))
       (((name a5) (type_ I64)) ((name a9) (type_ I64)))
       (((name a5) (type_ I64)) ((name a10) (type_ I64)))
       (((name a5) (type_ I64)) ((name a11) (type_ I64)))
       (((name a5) (type_ I64)) ((name a12) (type_ I64)))
       (((name a5) (type_ I64)) ((name a13) (type_ I64)))
       (((name a5) (type_ I64)) ((name a14) (type_ I64)))
       (((name a5) (type_ I64)) ((name a15) (type_ I64)))
       (((name a5) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a5) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a5) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a5) (type_ I64)) ((name r1) (type_ I64)))
       (((name a5) (type_ I64)) ((name r2) (type_ I64)))
       (((name a5) (type_ I64)) ((name r3) (type_ I64)))
       (((name a5) (type_ I64)) ((name r4) (type_ I64)))
       (((name a6) (type_ I64)) ((name a7) (type_ I64)))
       (((name a6) (type_ I64)) ((name a8) (type_ I64)))
       (((name a6) (type_ I64)) ((name a9) (type_ I64)))
       (((name a6) (type_ I64)) ((name a10) (type_ I64)))
       (((name a6) (type_ I64)) ((name a11) (type_ I64)))
       (((name a6) (type_ I64)) ((name a12) (type_ I64)))
       (((name a6) (type_ I64)) ((name a13) (type_ I64)))
       (((name a6) (type_ I64)) ((name a14) (type_ I64)))
       (((name a6) (type_ I64)) ((name a15) (type_ I64)))
       (((name a6) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a6) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a6) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a6) (type_ I64)) ((name r1) (type_ I64)))
       (((name a6) (type_ I64)) ((name r2) (type_ I64)))
       (((name a6) (type_ I64)) ((name r3) (type_ I64)))
       (((name a6) (type_ I64)) ((name r4) (type_ I64)))
       (((name a6) (type_ I64)) ((name r5) (type_ I64)))
       (((name a7) (type_ I64)) ((name a8) (type_ I64)))
       (((name a7) (type_ I64)) ((name a9) (type_ I64)))
       (((name a7) (type_ I64)) ((name a10) (type_ I64)))
       (((name a7) (type_ I64)) ((name a11) (type_ I64)))
       (((name a7) (type_ I64)) ((name a12) (type_ I64)))
       (((name a7) (type_ I64)) ((name a13) (type_ I64)))
       (((name a7) (type_ I64)) ((name a14) (type_ I64)))
       (((name a7) (type_ I64)) ((name a15) (type_ I64)))
       (((name a7) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a7) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a7) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a7) (type_ I64)) ((name r1) (type_ I64)))
       (((name a7) (type_ I64)) ((name r2) (type_ I64)))
       (((name a7) (type_ I64)) ((name r3) (type_ I64)))
       (((name a7) (type_ I64)) ((name r4) (type_ I64)))
       (((name a7) (type_ I64)) ((name r5) (type_ I64)))
       (((name a7) (type_ I64)) ((name r6) (type_ I64)))
       (((name a8) (type_ I64)) ((name a9) (type_ I64)))
       (((name a8) (type_ I64)) ((name a10) (type_ I64)))
       (((name a8) (type_ I64)) ((name a11) (type_ I64)))
       (((name a8) (type_ I64)) ((name a12) (type_ I64)))
       (((name a8) (type_ I64)) ((name a13) (type_ I64)))
       (((name a8) (type_ I64)) ((name a14) (type_ I64)))
       (((name a8) (type_ I64)) ((name a15) (type_ I64)))
       (((name a8) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a8) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a8) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a8) (type_ I64)) ((name r1) (type_ I64)))
       (((name a8) (type_ I64)) ((name r2) (type_ I64)))
       (((name a8) (type_ I64)) ((name r3) (type_ I64)))
       (((name a8) (type_ I64)) ((name r4) (type_ I64)))
       (((name a8) (type_ I64)) ((name r5) (type_ I64)))
       (((name a8) (type_ I64)) ((name r6) (type_ I64)))
       (((name a8) (type_ I64)) ((name r7) (type_ I64)))
       (((name a9) (type_ I64)) ((name a10) (type_ I64)))
       (((name a9) (type_ I64)) ((name a11) (type_ I64)))
       (((name a9) (type_ I64)) ((name a12) (type_ I64)))
       (((name a9) (type_ I64)) ((name a13) (type_ I64)))
       (((name a9) (type_ I64)) ((name a14) (type_ I64)))
       (((name a9) (type_ I64)) ((name a15) (type_ I64)))
       (((name a9) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a9) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a9) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a9) (type_ I64)) ((name r1) (type_ I64)))
       (((name a9) (type_ I64)) ((name r2) (type_ I64)))
       (((name a9) (type_ I64)) ((name r3) (type_ I64)))
       (((name a9) (type_ I64)) ((name r4) (type_ I64)))
       (((name a9) (type_ I64)) ((name r5) (type_ I64)))
       (((name a9) (type_ I64)) ((name r6) (type_ I64)))
       (((name a9) (type_ I64)) ((name r7) (type_ I64)))
       (((name a9) (type_ I64)) ((name r8) (type_ I64)))
       (((name a10) (type_ I64)) ((name a11) (type_ I64)))
       (((name a10) (type_ I64)) ((name a12) (type_ I64)))
       (((name a10) (type_ I64)) ((name a13) (type_ I64)))
       (((name a10) (type_ I64)) ((name a14) (type_ I64)))
       (((name a10) (type_ I64)) ((name a15) (type_ I64)))
       (((name a10) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a10) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a10) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a10) (type_ I64)) ((name r1) (type_ I64)))
       (((name a10) (type_ I64)) ((name r2) (type_ I64)))
       (((name a10) (type_ I64)) ((name r3) (type_ I64)))
       (((name a10) (type_ I64)) ((name r4) (type_ I64)))
       (((name a10) (type_ I64)) ((name r5) (type_ I64)))
       (((name a10) (type_ I64)) ((name r6) (type_ I64)))
       (((name a10) (type_ I64)) ((name r7) (type_ I64)))
       (((name a10) (type_ I64)) ((name r8) (type_ I64)))
       (((name a10) (type_ I64)) ((name r9) (type_ I64)))
       (((name a11) (type_ I64)) ((name a12) (type_ I64)))
       (((name a11) (type_ I64)) ((name a13) (type_ I64)))
       (((name a11) (type_ I64)) ((name a14) (type_ I64)))
       (((name a11) (type_ I64)) ((name a15) (type_ I64)))
       (((name a11) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a11) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a11) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a11) (type_ I64)) ((name r1) (type_ I64)))
       (((name a11) (type_ I64)) ((name r2) (type_ I64)))
       (((name a11) (type_ I64)) ((name r3) (type_ I64)))
       (((name a11) (type_ I64)) ((name r4) (type_ I64)))
       (((name a11) (type_ I64)) ((name r5) (type_ I64)))
       (((name a11) (type_ I64)) ((name r6) (type_ I64)))
       (((name a11) (type_ I64)) ((name r7) (type_ I64)))
       (((name a11) (type_ I64)) ((name r8) (type_ I64)))
       (((name a11) (type_ I64)) ((name r9) (type_ I64)))
       (((name a11) (type_ I64)) ((name r10) (type_ I64)))
       (((name a12) (type_ I64)) ((name a13) (type_ I64)))
       (((name a12) (type_ I64)) ((name a14) (type_ I64)))
       (((name a12) (type_ I64)) ((name a15) (type_ I64)))
       (((name a12) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a12) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a12) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a12) (type_ I64)) ((name r1) (type_ I64)))
       (((name a12) (type_ I64)) ((name r2) (type_ I64)))
       (((name a12) (type_ I64)) ((name r3) (type_ I64)))
       (((name a12) (type_ I64)) ((name r4) (type_ I64)))
       (((name a12) (type_ I64)) ((name r5) (type_ I64)))
       (((name a12) (type_ I64)) ((name r6) (type_ I64)))
       (((name a12) (type_ I64)) ((name r7) (type_ I64)))
       (((name a12) (type_ I64)) ((name r8) (type_ I64)))
       (((name a12) (type_ I64)) ((name r9) (type_ I64)))
       (((name a12) (type_ I64)) ((name r10) (type_ I64)))
       (((name a12) (type_ I64)) ((name r11) (type_ I64)))
       (((name a13) (type_ I64)) ((name a14) (type_ I64)))
       (((name a13) (type_ I64)) ((name a15) (type_ I64)))
       (((name a13) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a13) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a13) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a13) (type_ I64)) ((name r1) (type_ I64)))
       (((name a13) (type_ I64)) ((name r2) (type_ I64)))
       (((name a13) (type_ I64)) ((name r3) (type_ I64)))
       (((name a13) (type_ I64)) ((name r4) (type_ I64)))
       (((name a13) (type_ I64)) ((name r5) (type_ I64)))
       (((name a13) (type_ I64)) ((name r6) (type_ I64)))
       (((name a13) (type_ I64)) ((name r7) (type_ I64)))
       (((name a13) (type_ I64)) ((name r8) (type_ I64)))
       (((name a13) (type_ I64)) ((name r9) (type_ I64)))
       (((name a13) (type_ I64)) ((name r10) (type_ I64)))
       (((name a13) (type_ I64)) ((name r11) (type_ I64)))
       (((name a13) (type_ I64)) ((name r12) (type_ I64)))
       (((name a14) (type_ I64)) ((name a15) (type_ I64)))
       (((name a14) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a14) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a14) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a14) (type_ I64)) ((name r1) (type_ I64)))
       (((name a14) (type_ I64)) ((name r2) (type_ I64)))
       (((name a14) (type_ I64)) ((name r3) (type_ I64)))
       (((name a14) (type_ I64)) ((name r4) (type_ I64)))
       (((name a14) (type_ I64)) ((name r5) (type_ I64)))
       (((name a14) (type_ I64)) ((name r6) (type_ I64)))
       (((name a14) (type_ I64)) ((name r7) (type_ I64)))
       (((name a14) (type_ I64)) ((name r8) (type_ I64)))
       (((name a14) (type_ I64)) ((name r9) (type_ I64)))
       (((name a14) (type_ I64)) ((name r10) (type_ I64)))
       (((name a14) (type_ I64)) ((name r11) (type_ I64)))
       (((name a14) (type_ I64)) ((name r12) (type_ I64)))
       (((name a14) (type_ I64)) ((name r13) (type_ I64)))
       (((name a15) (type_ I64)) ((name arg_reg) (type_ I64)))
       (((name a15) (type_ I64)) ((name tmp_force_physical) (type_ I64)))
       (((name a15) (type_ I64)) ((name tmp) (type_ I64)))
       (((name a15) (type_ I64)) ((name r1) (type_ I64)))
       (((name a15) (type_ I64)) ((name r2) (type_ I64)))
       (((name a15) (type_ I64)) ((name r3) (type_ I64)))
       (((name a15) (type_ I64)) ((name r4) (type_ I64)))
       (((name a15) (type_ I64)) ((name r5) (type_ I64)))
       (((name a15) (type_ I64)) ((name r6) (type_ I64)))
       (((name a15) (type_ I64)) ((name r7) (type_ I64)))
       (((name a15) (type_ I64)) ((name r8) (type_ I64)))
       (((name a15) (type_ I64)) ((name r9) (type_ I64)))
       (((name a15) (type_ I64)) ((name r10) (type_ I64)))
       (((name a15) (type_ I64)) ((name r11) (type_ I64)))
       (((name a15) (type_ I64)) ((name r12) (type_ I64)))
       (((name a15) (type_ I64)) ((name r13) (type_ I64)))
       (((name a15) (type_ I64)) ((name r14) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r1) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r2) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r3) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r4) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r5) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r6) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r7) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r8) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r9) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r10) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r11) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r12) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r13) (type_ I64)))
       (((name tmp) (type_ I64)) ((name r14) (type_ I64)))
       (((name tmp) (type_ I64)) ((name result) (type_ I64))))
      |}]
;;

let%expect_test "borked" =
  compile_and_lower ~opt_flags:Eir.Opt_flags.no_opt borked;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl helper
    helper:
      push rbp
      push r14
      push r15
      mov rbp, rsp
      add rbp, 24
      mov r14, rdi
    helper___root:
      mov r15, 100
      mov rax, r14
      imul r15
      mov r15, rax
      mov rax, r15
    helper__helper__epilogue:
      mov rsp, rbp
      sub rsp, 24
      pop r15
      pop r14
      pop rbp
      ret

    .globl root
    root:
      sub rsp, 40
      push rbp
      push rbx
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 48
      mov rax, rdi
    root___root:
      mov [rbp], rax
      add qword ptr [rbp], 1
      mov r13, rax
      add r13, 2
      mov [rbp + 8], rax
      add qword ptr [rbp + 8], 3
      mov [rbp + 16], rax
      add qword ptr [rbp + 16], 4
      mov r14, rax
      add r14, 5
      mov r9, rax
      add r9, 6
      mov r12, rax
      add r12, 7
      mov r8, rax
      add r8, 8
      mov rdx, rax
      add rdx, 9
      mov r11, rax
      add r11, 10
      mov r15, rax
      add r15, 11
      mov rcx, rax
      add rcx, 12
      mov [rbp + 24], rax
      add qword ptr [rbp + 24], 13
      mov rbx, rax
      add rbx, 14
      mov r10, rax
      add r10, 15
      push rax
      push rdx
      mov rdi, rax
      call helper
      mov [rbp + 32], rax
      pop rdx
      pop rax
      mov rax, [rbp]
      add rax, r13
      mov [rbp], rax
      push r11
      mov r11, [rbp]
      add r11, [rbp + 8]
      mov [rbp], r11
      pop r11
      mov r13, [rbp]
      add r13, [rbp + 16]
      mov [rbp], r13
      add [rbp], r14
      push r11
      mov r11, [rbp]
      mov [rbp + 8], r11
      pop r11
      add [rbp + 8], r9
      push r11
      mov r11, [rbp + 8]
      mov [rbp], r11
      pop r11
      add [rbp], r12
      push r11
      mov r11, [rbp]
      mov [rbp + 8], r11
      pop r11
      add [rbp + 8], r8
      push r11
      mov r11, [rbp + 8]
      mov [rbp], r11
      pop r11
      add [rbp], rdx
      mov r14, [rbp]
      add r14, r11
      mov [rbp], r14
      add [rbp], r15
      mov r15, [rbp]
      add r15, rcx
      mov [rbp], r15
      push r11
      mov r11, [rbp]
      add r11, [rbp + 24]
      mov [rbp], r11
      pop r11
      push r11
      mov r11, [rbp]
      mov [rbp + 8], r11
      pop r11
      add [rbp + 8], rbx
      push r11
      mov r11, [rbp + 8]
      mov [rbp], r11
      pop r11
      add [rbp], r10
      push r11
      mov r11, [rbp]
      mov [rbp + 8], r11
      pop r11
      push r11
      mov r11, [rbp + 8]
      add r11, [rbp + 32]
      mov [rbp + 8], r11
      pop r11
      mov rax, [rbp + 8]
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 48
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbx
      pop rbp
      add rsp, 40
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
      ((Mul
        ((dest ((name result) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 100))))
       (Return (Var ((name result) (type_ I64)))))))
    (%root
     (instrs
      ((Add
        ((dest ((name a1) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 1))))
       (Add
        ((dest ((name a2) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 2))))
       (Add
        ((dest ((name a3) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Add
        ((dest ((name a4) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 4))))
       (Add
        ((dest ((name a5) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 5))))
       (Add
        ((dest ((name a6) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 6))))
       (Add
        ((dest ((name a7) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 7))))
       (Add
        ((dest ((name a8) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 8))))
       (Add
        ((dest ((name a9) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 9))))
       (Add
        ((dest ((name a10) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Add
        ((dest ((name a11) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 11))))
       (Add
        ((dest ((name a12) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 12))))
       (Add
        ((dest ((name a13) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 13))))
       (Add
        ((dest ((name a14) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 14))))
       (Add
        ((dest ((name a15) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 15))))
       (Call (fn helper) (results (((name tmp) (type_ I64))))
        (args ((Var ((name x) (type_ I64))))))
       (Add
        ((dest ((name r1) (type_ I64))) (src1 (Var ((name a1) (type_ I64))))
         (src2 (Var ((name a2) (type_ I64))))))
       (Add
        ((dest ((name r2) (type_ I64))) (src1 (Var ((name r1) (type_ I64))))
         (src2 (Var ((name a3) (type_ I64))))))
       (Add
        ((dest ((name r3) (type_ I64))) (src1 (Var ((name r2) (type_ I64))))
         (src2 (Var ((name a4) (type_ I64))))))
       (Add
        ((dest ((name r4) (type_ I64))) (src1 (Var ((name r3) (type_ I64))))
         (src2 (Var ((name a5) (type_ I64))))))
       (Add
        ((dest ((name r5) (type_ I64))) (src1 (Var ((name r4) (type_ I64))))
         (src2 (Var ((name a6) (type_ I64))))))
       (Add
        ((dest ((name r6) (type_ I64))) (src1 (Var ((name r5) (type_ I64))))
         (src2 (Var ((name a7) (type_ I64))))))
       (Add
        ((dest ((name r7) (type_ I64))) (src1 (Var ((name r6) (type_ I64))))
         (src2 (Var ((name a8) (type_ I64))))))
       (Add
        ((dest ((name r8) (type_ I64))) (src1 (Var ((name r7) (type_ I64))))
         (src2 (Var ((name a9) (type_ I64))))))
       (Add
        ((dest ((name r9) (type_ I64))) (src1 (Var ((name r8) (type_ I64))))
         (src2 (Var ((name a10) (type_ I64))))))
       (Add
        ((dest ((name r10) (type_ I64))) (src1 (Var ((name r9) (type_ I64))))
         (src2 (Var ((name a11) (type_ I64))))))
       (Add
        ((dest ((name r11) (type_ I64))) (src1 (Var ((name r10) (type_ I64))))
         (src2 (Var ((name a12) (type_ I64))))))
       (Add
        ((dest ((name r12) (type_ I64))) (src1 (Var ((name r11) (type_ I64))))
         (src2 (Var ((name a13) (type_ I64))))))
       (Add
        ((dest ((name r13) (type_ I64))) (src1 (Var ((name r12) (type_ I64))))
         (src2 (Var ((name a14) (type_ I64))))))
       (Add
        ((dest ((name r14) (type_ I64))) (src1 (Var ((name r13) (type_ I64))))
         (src2 (Var ((name a15) (type_ I64))))))
       (Add
        ((dest ((name result) (type_ I64))) (src1 (Var ((name r14) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Return (Var ((name result) (type_ I64)))))))
    =================================
    (%root (args (((name x) (type_ I64))))
     (instrs
      ((Mul
        ((dest ((name result) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 100))))
       (Return (Var ((name result) (type_ I64)))))))
    (%root (args (((name x) (type_ I64))))
     (instrs
      ((Add
        ((dest ((name a1) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 1))))
       (Add
        ((dest ((name a2) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 2))))
       (Add
        ((dest ((name a3) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Add
        ((dest ((name a4) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 4))))
       (Add
        ((dest ((name a5) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 5))))
       (Add
        ((dest ((name a6) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 6))))
       (Add
        ((dest ((name a7) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 7))))
       (Add
        ((dest ((name a8) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 8))))
       (Add
        ((dest ((name a9) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 9))))
       (Add
        ((dest ((name a10) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Add
        ((dest ((name a11) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 11))))
       (Add
        ((dest ((name a12) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 12))))
       (Add
        ((dest ((name a13) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 13))))
       (Add
        ((dest ((name a14) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 14))))
       (Add
        ((dest ((name a15) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 15))))
       (Call (fn helper) (results (((name tmp) (type_ I64))))
        (args ((Var ((name x) (type_ I64))))))
       (Add
        ((dest ((name r1) (type_ I64))) (src1 (Var ((name a1) (type_ I64))))
         (src2 (Var ((name a2) (type_ I64))))))
       (Add
        ((dest ((name r2) (type_ I64))) (src1 (Var ((name r1) (type_ I64))))
         (src2 (Var ((name a3) (type_ I64))))))
       (Add
        ((dest ((name r3) (type_ I64))) (src1 (Var ((name r2) (type_ I64))))
         (src2 (Var ((name a4) (type_ I64))))))
       (Add
        ((dest ((name r4) (type_ I64))) (src1 (Var ((name r3) (type_ I64))))
         (src2 (Var ((name a5) (type_ I64))))))
       (Add
        ((dest ((name r5) (type_ I64))) (src1 (Var ((name r4) (type_ I64))))
         (src2 (Var ((name a6) (type_ I64))))))
       (Add
        ((dest ((name r6) (type_ I64))) (src1 (Var ((name r5) (type_ I64))))
         (src2 (Var ((name a7) (type_ I64))))))
       (Add
        ((dest ((name r7) (type_ I64))) (src1 (Var ((name r6) (type_ I64))))
         (src2 (Var ((name a8) (type_ I64))))))
       (Add
        ((dest ((name r8) (type_ I64))) (src1 (Var ((name r7) (type_ I64))))
         (src2 (Var ((name a9) (type_ I64))))))
       (Add
        ((dest ((name r9) (type_ I64))) (src1 (Var ((name r8) (type_ I64))))
         (src2 (Var ((name a10) (type_ I64))))))
       (Add
        ((dest ((name r10) (type_ I64))) (src1 (Var ((name r9) (type_ I64))))
         (src2 (Var ((name a11) (type_ I64))))))
       (Add
        ((dest ((name r11) (type_ I64))) (src1 (Var ((name r10) (type_ I64))))
         (src2 (Var ((name a12) (type_ I64))))))
       (Add
        ((dest ((name r12) (type_ I64))) (src1 (Var ((name r11) (type_ I64))))
         (src2 (Var ((name a13) (type_ I64))))))
       (Add
        ((dest ((name r13) (type_ I64))) (src1 (Var ((name r12) (type_ I64))))
         (src2 (Var ((name a14) (type_ I64))))))
       (Add
        ((dest ((name r14) (type_ I64))) (src1 (Var ((name r13) (type_ I64))))
         (src2 (Var ((name a15) (type_ I64))))))
       (Add
        ((dest ((name result) (type_ I64))) (src1 (Var ((name r14) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Return (Var ((name result) (type_ I64)))))))
    |}]
;;

let%expect_test "debug borked opt x86" =
  test ~opt_flags:Eir.Opt_flags.no_opt borked;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((helper__prologue (args (((name x0) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (ADD (Reg ((reg RBP) (class_ I64))) (Imm 24)))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum %root) (args (((name x) (type_ I64)))))) (args ())))))))
        (%root (args (((name x) (type_ I64))))
         (instrs
          ((X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 100)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (Tag_def
             (Tag_def
              (Tag_use (IMUL (Reg ((reg R15) (class_ I64))))
               (Reg ((reg RAX) (class_ I64))))
              (Reg ((reg RAX) (class_ I64))))
             (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum helper__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (helper__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 24)))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args (((name x) (type_ I64)))) (name helper) (prologue ()) (epilogue ())
      (bytes_alloca'd 0) (bytes_for_spills 0) (bytes_for_clobber_saves 24))
     ((call_conv Default)
      (root
       ((root__prologue (args (((name x16) (type_ I64))))
         (instrs
          ((X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 40)))
           (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg RBX) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R12) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R13) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (ADD (Reg ((reg RBP) (class_ I64))) (Imm 48)))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum %root) (args (((name x) (type_ I64)))))) (args ())))))))
        (%root (args (((name x) (type_ I64))))
         (instrs
          ((X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 0) (Imm 1)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R13) (class_ I64))) (Imm 2)))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 8) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 8) (Imm 3)))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 16)
             (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 16) (Imm 4)))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R14) (class_ I64))) (Imm 5)))
           (X86
            (MOV (Reg ((reg R9) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R9) (class_ I64))) (Imm 6)))
           (X86
            (MOV (Reg ((reg R12) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R12) (class_ I64))) (Imm 7)))
           (X86
            (MOV (Reg ((reg R8) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R8) (class_ I64))) (Imm 8)))
           (X86
            (MOV (Reg ((reg RDX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg RDX) (class_ I64))) (Imm 9)))
           (X86
            (MOV (Reg ((reg R11) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R11) (class_ I64))) (Imm 10)))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 11)))
           (X86
            (MOV (Reg ((reg RCX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg RCX) (class_ I64))) (Imm 12)))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 24)
             (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Mem ((reg RBP) (class_ I64)) 24) (Imm 13)))
           (X86
            (MOV (Reg ((reg RBX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg RBX) (class_ I64))) (Imm 14)))
           (X86
            (MOV (Reg ((reg R10) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (ADD (Reg ((reg R10) (class_ I64))) (Imm 15)))
           (X86 (PUSH (Reg ((reg RAX) (class_ I64)))))
           (X86 (PUSH (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (CALL (fn helper) (results (((reg RAX) (class_ I64))))
             (args ((Reg ((reg RAX) (class_ I64)))))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 32)
             (Reg ((reg RAX) (class_ I64)))))
           (X86 (POP ((reg RDX) (class_ I64))))
           (X86 (POP ((reg RAX) (class_ I64))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Reg ((reg RAX) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0)
             (Mem ((reg RBP) (class_ I64)) 8)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Reg ((reg R13) (class_ I64)))
             (Mem ((reg RBP) (class_ I64)) 16)))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 8)
             (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 8) (Reg ((reg R9) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0)
             (Mem ((reg RBP) (class_ I64)) 8)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R12) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 8)
             (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 8) (Reg ((reg R8) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0)
             (Mem ((reg RBP) (class_ I64)) 8)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Reg ((reg R14) (class_ I64))) (Reg ((reg R11) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R14) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg RCX) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R15) (class_ I64)))))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0)
             (Mem ((reg RBP) (class_ I64)) 24)))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 8)
             (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 8) (Reg ((reg RBX) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 0)
             (Mem ((reg RBP) (class_ I64)) 8)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 0) (Reg ((reg R10) (class_ I64)))))
           (X86
            (MOV (Mem ((reg RBP) (class_ I64)) 8)
             (Mem ((reg RBP) (class_ I64)) 0)))
           (X86
            (ADD (Mem ((reg RBP) (class_ I64)) 8)
             (Mem ((reg RBP) (class_ I64)) 32)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Mem ((reg RBP) (class_ I64)) 8)))
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
           (X86 (ADD (Reg ((reg RSP) (class_ I64))) (Imm 40)))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args (((name x) (type_ I64)))) (name root) (prologue ()) (epilogue ())
      (bytes_alloca'd 0) (bytes_for_spills 40) (bytes_for_clobber_saves 48)))
    |}]
;;

let%expect_test "debug borked" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      (block (block.id_hum helper__prologue))
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | ir                                                                                                                              | Ir.defs ir               |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(MOV(Reg((reg(Allocated((name x0)(type_ I64))(RDI)))(class_ I64)))(Reg((reg RDI)(class_ I64)))))                            | (((name x0)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                 | {}                       |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x0)(type_ I64))))(class_ I64))))) | (((name x)(type_ I64)))  |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(JMP((block((id_hum %root)(args(((name x)(type_ I64))))))(args(((name x0)(type_ I64)))))))                                  | {}                       |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      (block (block.id_hum %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | ir                                                                                                                                                                                                                                                                                                                  | Ir.defs ir                                                   |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(MOV(Reg((reg(Allocated((name tmp_imm)(type_ I64))()))(class_ I64)))(Imm 100)))                                                                                                                                                                                                                                 | (((name tmp_imm)(type_ I64)))                                |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(MOV(Reg((reg(Allocated((name tmp_rax)(type_ I64))(RAX)))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                                                                                                                                                             | (((name tmp_rax)(type_ I64)))                                |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(Tag_def(Tag_def(Tag_use(IMUL(Reg((reg(Allocated((name tmp_imm)(type_ I64))()))(class_ I64))))(Reg((reg(Allocated((name tmp_rax)(type_ I64))(RAX)))(class_ I64))))(Reg((reg(Allocated((name tmp_dst)(type_ I64))(RAX)))(class_ I64))))(Reg((reg(Allocated((name tmp_clobber)(type_ I64))(RDX)))(class_ I64))))) | (((name tmp_clobber)(type_ I64))((name tmp_dst)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Allocated((name tmp_dst)(type_ I64))(RAX)))(class_ I64)))))                                                                                                                                                                        | (((name result)(type_ I64)))                                 |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))))                                                                                                                                                                            | (((name res__0)(type_ I64)))                                 |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86_terminal((JMP((block((id_hum helper__epilogue)(args(((name res__0)(type_ I64))))))(args(((name result)(type_ I64))))))))                                                                                                                                                                                       | {}                                                           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      (block (block.id_hum helper__epilogue))
      +----------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                       | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))) | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                           | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      (block (block.id_hum root__prologue))
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | ir                                                                                                                               | Ir.defs ir                |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(MOV(Reg((reg(Allocated((name x16)(type_ I64))(RDI)))(class_ I64)))(Reg((reg RDI)(class_ I64)))))                            | (((name x16)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                  | {}                        |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x16)(type_ I64))))(class_ I64))))) | (((name x)(type_ I64)))   |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(JMP((block((id_hum %root)(args(((name x)(type_ I64))))))(args(((name x16)(type_ I64)))))))                                  | {}                        |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      (block (block.id_hum %root))
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | ir                                                                                                                                                                           | Ir.defs ir                               |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a1)(type_ I64))))(class_ I64)))(Imm 1)))                                                                                                 | (((name a1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a2)(type_ I64))))(class_ I64)))(Imm 2)))                                                                                                 | (((name a2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a3)(type_ I64))))(class_ I64)))(Imm 3)))                                                                                                 | (((name a3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a4)(type_ I64))))(class_ I64)))(Imm 4)))                                                                                                 | (((name a4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a5)(type_ I64))))(class_ I64)))(Imm 5)))                                                                                                 | (((name a5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a6)(type_ I64))))(class_ I64)))(Imm 6)))                                                                                                 | (((name a6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a7)(type_ I64))))(class_ I64)))(Imm 7)))                                                                                                 | (((name a7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a8)(type_ I64))))(class_ I64)))(Imm 8)))                                                                                                 | (((name a8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a9)(type_ I64))))(class_ I64)))(Imm 9)))                                                                                                 | (((name a9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a10)(type_ I64))))(class_ I64)))(Imm 10)))                                                                                               | (((name a10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a11)(type_ I64))))(class_ I64)))(Imm 11)))                                                                                               | (((name a11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a12)(type_ I64))))(class_ I64)))(Imm 12)))                                                                                               | (((name a12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a13)(type_ I64))))(class_ I64)))(Imm 13)))                                                                                               | (((name a13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a14)(type_ I64))))(class_ I64)))(Imm 14)))                                                                                               | (((name a14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a15)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a15)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a15)(type_ I64))))(class_ I64)))(Imm 15)))                                                                                               | (((name a15)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {X86,Save_clobbers}                                                                                                                                                          | {}                                       |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Allocated((name arg_reg)(type_ I64))(RDI)))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                      | (((name arg_reg)(type_ I64)))            |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(CALL(fn helper)(results(((reg(Allocated((name tmp_force_physical)(type_ I64))(RAX)))(class_ I64))))(args((Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64))))))) | (((name tmp_force_physical)(type_ I64))) |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name tmp)(type_ I64))))(class_ I64)))(Reg((reg(Allocated((name tmp_force_physical)(type_ I64))(RAX)))(class_ I64)))))                         | (((name tmp)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {X86,Restore_clobbers}                                                                                                                                                       | {}                                       |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a1)(type_ I64))))(class_ I64)))))                                             | (((name r1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a2)(type_ I64))))(class_ I64)))))                                             | (((name r1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r1)(type_ I64))))(class_ I64)))))                                             | (((name r2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a3)(type_ I64))))(class_ I64)))))                                             | (((name r2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r2)(type_ I64))))(class_ I64)))))                                             | (((name r3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a4)(type_ I64))))(class_ I64)))))                                             | (((name r3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r3)(type_ I64))))(class_ I64)))))                                             | (((name r4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a5)(type_ I64))))(class_ I64)))))                                             | (((name r4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r4)(type_ I64))))(class_ I64)))))                                             | (((name r5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a6)(type_ I64))))(class_ I64)))))                                             | (((name r5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r5)(type_ I64))))(class_ I64)))))                                             | (((name r6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a7)(type_ I64))))(class_ I64)))))                                             | (((name r6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r6)(type_ I64))))(class_ I64)))))                                             | (((name r7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a8)(type_ I64))))(class_ I64)))))                                             | (((name r7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r7)(type_ I64))))(class_ I64)))))                                             | (((name r8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a9)(type_ I64))))(class_ I64)))))                                             | (((name r8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r8)(type_ I64))))(class_ I64)))))                                             | (((name r9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a10)(type_ I64))))(class_ I64)))))                                            | (((name r9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r9)(type_ I64))))(class_ I64)))))                                            | (((name r10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a11)(type_ I64))))(class_ I64)))))                                           | (((name r10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r10)(type_ I64))))(class_ I64)))))                                           | (((name r11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a12)(type_ I64))))(class_ I64)))))                                           | (((name r11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r11)(type_ I64))))(class_ I64)))))                                           | (((name r12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a13)(type_ I64))))(class_ I64)))))                                           | (((name r12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r12)(type_ I64))))(class_ I64)))))                                           | (((name r13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a14)(type_ I64))))(class_ I64)))))                                           | (((name r13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r13)(type_ I64))))(class_ I64)))))                                           | (((name r14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a15)(type_ I64))))(class_ I64)))))                                           | (((name r14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r14)(type_ I64))))(class_ I64)))))                                        | (((name result)(type_ I64)))             |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name tmp)(type_ I64))))(class_ I64)))))                                        | (((name result)(type_ I64)))             |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))))                                     | (((name res__0)(type_ I64)))             |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86_terminal((JMP((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name result)(type_ I64))))))))                                                  | {}                                       |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      (block (block.id_hum root__epilogue))
      +----------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                       | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))) | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                           | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      |}]
;;

let%expect_test "debug borked opt" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.default borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      (block (block.id_hum helper__prologue))
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | ir                                                                                                                              | Ir.defs ir               |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(MOV(Reg((reg(Allocated((name x0)(type_ I64))(RDI)))(class_ I64)))(Reg((reg RDI)(class_ I64)))))                            | (((name x0)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                 | {}                       |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x0)(type_ I64))))(class_ I64))))) | (((name x)(type_ I64)))  |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (X86(JMP((block((id_hum %root)(args(((name x)(type_ I64))))))(args(((name x0)(type_ I64)))))))                                  | {}                       |
      +---------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      (block (block.id_hum %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | ir                                                                                                                                                                                                                                                                                                            | Ir.defs ir                                                   |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(MOV(Reg((reg(Allocated((name tmp_rax)(type_ I64))(RAX)))(class_ I64)))(Imm 100)))                                                                                                                                                                                                                        | (((name tmp_rax)(type_ I64)))                                |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(Tag_def(Tag_def(Tag_use(IMUL(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64))))(Reg((reg(Allocated((name tmp_rax)(type_ I64))(RAX)))(class_ I64))))(Reg((reg(Allocated((name tmp_dst)(type_ I64))(RAX)))(class_ I64))))(Reg((reg(Allocated((name tmp_clobber)(type_ I64))(RDX)))(class_ I64))))) | (((name tmp_clobber)(type_ I64))((name tmp_dst)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Allocated((name tmp_dst)(type_ I64))(RAX)))(class_ I64)))))                                                                                                                                                                  | (((name result)(type_ I64)))                                 |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))))                                                                                                                                                                      | (((name res__0)(type_ I64)))                                 |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      | (X86_terminal((JMP((block((id_hum helper__epilogue)(args(((name res__0)(type_ I64))))))(args(((name result)(type_ I64))))))))                                                                                                                                                                                 | {}                                                           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------+
      (block (block.id_hum helper__epilogue))
      +----------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                       | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))) | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                           | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      (block (block.id_hum root__prologue))
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | ir                                                                                                                               | Ir.defs ir                |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(MOV(Reg((reg(Allocated((name x16)(type_ I64))(RDI)))(class_ I64)))(Reg((reg RDI)(class_ I64)))))                            | (((name x16)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                  | {}                        |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x16)(type_ I64))))(class_ I64))))) | (((name x)(type_ I64)))   |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      | (X86(JMP((block((id_hum %root)(args(((name x)(type_ I64))))))(args(((name x16)(type_ I64)))))))                                  | {}                        |
      +----------------------------------------------------------------------------------------------------------------------------------+---------------------------+
      (block (block.id_hum %root))
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | ir                                                                                                                                                                           | Ir.defs ir                               |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a1)(type_ I64))))(class_ I64)))(Imm 1)))                                                                                                 | (((name a1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a2)(type_ I64))))(class_ I64)))(Imm 2)))                                                                                                 | (((name a2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a3)(type_ I64))))(class_ I64)))(Imm 3)))                                                                                                 | (((name a3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a4)(type_ I64))))(class_ I64)))(Imm 4)))                                                                                                 | (((name a4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a5)(type_ I64))))(class_ I64)))(Imm 5)))                                                                                                 | (((name a5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a6)(type_ I64))))(class_ I64)))(Imm 6)))                                                                                                 | (((name a6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a7)(type_ I64))))(class_ I64)))(Imm 7)))                                                                                                 | (((name a7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a8)(type_ I64))))(class_ I64)))(Imm 8)))                                                                                                 | (((name a8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a9)(type_ I64))))(class_ I64)))(Imm 9)))                                                                                                 | (((name a9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                              | (((name a9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a10)(type_ I64))))(class_ I64)))(Imm 10)))                                                                                               | (((name a10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a11)(type_ I64))))(class_ I64)))(Imm 11)))                                                                                               | (((name a11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a12)(type_ I64))))(class_ I64)))(Imm 12)))                                                                                               | (((name a12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a13)(type_ I64))))(class_ I64)))(Imm 13)))                                                                                               | (((name a13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a14)(type_ I64))))(class_ I64)))(Imm 14)))                                                                                               | (((name a14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name a15)(type_ I64))))(class_ I64)))(Imm 15)))                                                                                               | (((name a15)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name a15)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                             | (((name a15)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {X86,Save_clobbers}                                                                                                                                                          | {}                                       |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Allocated((name arg_reg)(type_ I64))(RDI)))(class_ I64)))(Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64)))))                                      | (((name arg_reg)(type_ I64)))            |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(CALL(fn helper)(results(((reg(Allocated((name tmp_force_physical)(type_ I64))(RAX)))(class_ I64))))(args((Reg((reg(Unallocated((name x)(type_ I64))))(class_ I64))))))) | (((name tmp_force_physical)(type_ I64))) |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name tmp)(type_ I64))))(class_ I64)))(Reg((reg(Allocated((name tmp_force_physical)(type_ I64))(RAX)))(class_ I64)))))                         | (((name tmp)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {X86,Restore_clobbers}                                                                                                                                                       | {}                                       |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a1)(type_ I64))))(class_ I64)))))                                             | (((name r1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a2)(type_ I64))))(class_ I64)))))                                             | (((name r1)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r1)(type_ I64))))(class_ I64)))))                                             | (((name r2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a3)(type_ I64))))(class_ I64)))))                                             | (((name r2)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r2)(type_ I64))))(class_ I64)))))                                             | (((name r3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a4)(type_ I64))))(class_ I64)))))                                             | (((name r3)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r3)(type_ I64))))(class_ I64)))))                                             | (((name r4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a5)(type_ I64))))(class_ I64)))))                                             | (((name r4)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r4)(type_ I64))))(class_ I64)))))                                             | (((name r5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a6)(type_ I64))))(class_ I64)))))                                             | (((name r5)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r5)(type_ I64))))(class_ I64)))))                                             | (((name r6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a7)(type_ I64))))(class_ I64)))))                                             | (((name r6)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r6)(type_ I64))))(class_ I64)))))                                             | (((name r7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a8)(type_ I64))))(class_ I64)))))                                             | (((name r7)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r7)(type_ I64))))(class_ I64)))))                                             | (((name r8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a9)(type_ I64))))(class_ I64)))))                                             | (((name r8)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r8)(type_ I64))))(class_ I64)))))                                             | (((name r9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a10)(type_ I64))))(class_ I64)))))                                            | (((name r9)(type_ I64)))                 |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r9)(type_ I64))))(class_ I64)))))                                            | (((name r10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a11)(type_ I64))))(class_ I64)))))                                           | (((name r10)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r10)(type_ I64))))(class_ I64)))))                                           | (((name r11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a12)(type_ I64))))(class_ I64)))))                                           | (((name r11)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r11)(type_ I64))))(class_ I64)))))                                           | (((name r12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a13)(type_ I64))))(class_ I64)))))                                           | (((name r12)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r12)(type_ I64))))(class_ I64)))))                                           | (((name r13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r13)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a14)(type_ I64))))(class_ I64)))))                                           | (((name r13)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name r14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r13)(type_ I64))))(class_ I64)))))                                           | (((name r14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name r14)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a15)(type_ I64))))(class_ I64)))))                                           | (((name r14)(type_ I64)))                |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name r14)(type_ I64))))(class_ I64)))))                                        | (((name result)(type_ I64)))             |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(ADD(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name tmp)(type_ I64))))(class_ I64)))))                                        | (((name result)(type_ I64)))             |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name result)(type_ I64))))(class_ I64)))))                                     | (((name res__0)(type_ I64)))             |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (X86_terminal((JMP((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name result)(type_ I64))))))))                                                  | {}                                       |
      +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      (block (block.id_hum root__epilogue))
      +----------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                       | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))) | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                           | {}         |
      +----------------------------------------------------------------------------------------------------------+------------+
      |}]
;;
