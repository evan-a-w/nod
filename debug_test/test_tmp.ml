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

let borked = Examples.Textual.f_but_simple

let%expect_test "borked" =
  compile_and_lower ~opt_flags:Eir.Opt_flags.default borked;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl root
    root:
      push rbp
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 40
    root__start:
      mov r15, 0
      mov r12, 0
    root__outercheck:
      mov r14, r15
      sub r14, 7
      cmp r14, 0
      je root__intermediate_outercheck_to_exit
    root__intermediate_outercheck_to_outerbody:
      jmp root__outerbody
    root__intermediate_outercheck_to_exit:
      jmp root__exit
    root__outerbody:
      mov r14, 0
      mov r13, 0
      jmp root__innercheck
    root__exit:
      mov rax, r12
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 40
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret
    root__innercheck:
      mov r11, r14
      sub r11, 3
      cmp r11, 0
      je root__intermediate_innercheck_to_innerexit
    root__intermediate_innercheck_to_innerbody:
      jmp root__innerbody
    root__intermediate_innercheck_to_innerexit:
      jmp root__innerexit
    root__innerbody:
      mov rax, r15
      imul r14
      mov r11, rax
      mov r10, r13
      add r10, r11
      mov r11, 1
      add r11, r14
      jmp root__innercheck
    root__innerexit:
      add r12, r13
    root__outerinc:
      mov r11, 1
      add r11, r15
      mov r15, r11
      mov r14, r13
      mov r13, r14
      jmp root__outercheck
    .section .note.GNU-stack,"",@progbits
    |}]
;;
(* FIXME: bug in innerbody ^ where r11 and r14 are mismatched somehow *)


let%expect_test "debug borked opt ssa" = test_ssa borked;
  [%expect {|
    (start
     (instrs
      ((Move ((name n) (type_ I64)) (Lit 7))
       (Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name total) (type_ I64)) (Lit 0))
       (Branch (Uncond ((block ((id_hum outerCheck) (args ()))) (args ())))))))
    (outerCheck
     (instrs
      ((Sub
        ((dest ((name condOuter) (type_ I64)))
         (src1 (Var ((name i) (type_ I64)))) (src2 (Var ((name n) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name condOuter) (type_ I64))))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody
     (instrs
      ((Move ((name j) (type_ I64)) (Lit 0))
       (Move ((name partial) (type_ I64)) (Lit 0))
       (Branch (Uncond ((block ((id_hum innerCheck) (args ()))) (args ())))))))
    (innerCheck
     (instrs
      ((Sub
        ((dest ((name condInner) (type_ I64)))
         (src1 (Var ((name j) (type_ I64)))) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var ((name condInner) (type_ I64))))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerBody
     (instrs
      ((Mul
        ((dest ((name tmp) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Var ((name j) (type_ I64))))))
       (Add
        ((dest ((name partial) (type_ I64)))
         (src1 (Var ((name partial) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Add
        ((dest ((name j) (type_ I64))) (src1 (Var ((name j) (type_ I64))))
         (src2 (Lit 1))))
       (Branch (Uncond ((block ((id_hum innerCheck) (args ()))) (args ())))))))
    (innerExit
     (instrs
      ((Add
        ((dest ((name total) (type_ I64)))
         (src1 (Var ((name total) (type_ I64))))
         (src2 (Var ((name partial) (type_ I64))))))
       (Branch (Uncond ((block ((id_hum outerInc) (args ()))) (args ())))))))
    (outerInc
     (instrs
      ((Add
        ((dest ((name i) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Lit 1))))
       (Branch (Uncond ((block ((id_hum outerCheck) (args ()))) (args ())))))))
    (exit (instrs ((Return (Var ((name total) (type_ I64)))))))
    =================================
    (start (args ())
     (instrs
      ((Move ((name n) (type_ I64)) (Lit 7))
       (Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name total) (type_ I64)) (Lit 0))
       (Branch
        (Uncond
         ((block
           ((id_hum outerCheck)
            (args
             (((name i%0) (type_ I64)) ((name total%0) (type_ I64))
              ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))
          (args
           (((name i) (type_ I64)) ((name total) (type_ I64))
            ((name j) (type_ I64)) ((name partial) (type_ I64))))))))))
    (outerCheck
     (args
      (((name i%0) (type_ I64)) ((name total%0) (type_ I64))
       ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))
     (instrs
      ((Sub
        ((dest ((name condOuter) (type_ I64)))
         (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Var ((name n) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name condOuter) (type_ I64))))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody (args ())
     (instrs
      ((Move ((name j%0) (type_ I64)) (Lit 0))
       (Move ((name partial%0) (type_ I64)) (Lit 0))
       (Branch
        (Uncond
         ((block
           ((id_hum innerCheck)
            (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
          (args (((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))))))
    (innerCheck (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))
     (instrs
      ((Sub
        ((dest ((name condInner) (type_ I64)))
         (src1 (Var ((name j%0) (type_ I64)))) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var ((name condInner) (type_ I64))))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerBody (args ())
     (instrs
      ((Mul
        ((dest ((name tmp) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Var ((name j%0) (type_ I64))))))
       (Add
        ((dest ((name partial%2) (type_ I64)))
         (src1 (Var ((name partial%0) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Add
        ((dest ((name j%2) (type_ I64))) (src1 (Var ((name j%0) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Uncond
         ((block
           ((id_hum innerCheck)
            (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
          (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))))))
    (innerExit (args ())
     (instrs
      ((Add
        ((dest ((name total%1) (type_ I64)))
         (src1 (Var ((name total%0) (type_ I64))))
         (src2 (Var ((name partial%0) (type_ I64))))))
       (Branch (Uncond ((block ((id_hum outerInc) (args ()))) (args ())))))))
    (outerInc (args ())
     (instrs
      ((Add
        ((dest ((name i%1) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Uncond
         ((block
           ((id_hum outerCheck)
            (args
             (((name i%0) (type_ I64)) ((name total%0) (type_ I64))
              ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))
          (args
           (((name i%1) (type_ I64)) ((name total%1) (type_ I64))
            ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))))))
    (exit (args ()) (instrs ((Return (Var ((name total%0) (type_ I64)))))))
    ******************************
    (start (args ())
     (instrs
      ((Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name total) (type_ I64)) (Lit 0))
       (Branch
        (Uncond
         ((block
           ((id_hum outerCheck)
            (args
             (((name i%0) (type_ I64)) ((name total%0) (type_ I64))
              ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))
          (args
           (((name i) (type_ I64)) ((name total) (type_ I64))
            ((name j) (type_ I64)) ((name partial) (type_ I64))))))))))
    (outerCheck
     (args
      (((name i%0) (type_ I64)) ((name total%0) (type_ I64))
       ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))
     (instrs
      ((Sub
        ((dest ((name condOuter) (type_ I64)))
         (src1 (Var ((name i%0) (type_ I64)))) (src2 (Lit 7))))
       (Branch
        (Cond (cond (Var ((name condOuter) (type_ I64))))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody (args ())
     (instrs
      ((Move ((name j%0) (type_ I64)) (Lit 0))
       (Move ((name partial%0) (type_ I64)) (Lit 0))
       (Branch (Uncond ((block ((id_hum innerCheck) (args ()))) (args ())))))))
    (innerCheck (args ())
     (instrs
      ((Sub
        ((dest ((name condInner) (type_ I64)))
         (src1 (Var ((name j%0) (type_ I64)))) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var ((name condInner) (type_ I64))))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerBody (args ())
     (instrs
      ((Mul
        ((dest ((name tmp) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Var ((name j%0) (type_ I64))))))
       (Add
        ((dest ((name partial%2) (type_ I64)))
         (src1 (Var ((name partial%0) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Add
        ((dest ((name j%2) (type_ I64))) (src1 (Lit 1))
         (src2 (Var ((name j%0) (type_ I64))))))
       (Branch (Uncond ((block ((id_hum innerCheck) (args ()))) (args ())))))))
    (innerExit (args ())
     (instrs
      ((Add
        ((dest ((name total%1) (type_ I64)))
         (src1 (Var ((name total%0) (type_ I64))))
         (src2 (Var ((name partial%0) (type_ I64))))))
       (Branch (Uncond ((block ((id_hum outerInc) (args ()))) (args ())))))))
    (outerInc (args ())
     (instrs
      ((Add
        ((dest ((name i%1) (type_ I64))) (src1 (Lit 1))
         (src2 (Var ((name i%0) (type_ I64))))))
       (Branch
        (Uncond
         ((block
           ((id_hum outerCheck)
            (args
             (((name i%0) (type_ I64)) ((name total%0) (type_ I64))
              ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))
          (args
           (((name i%1) (type_ I64)) ((name total%1) (type_ I64))
            ((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))))))
    (exit (args ()) (instrs ((Return (Var ((name total%0) (type_ I64)))))))
    |}]


let%expect_test "debug borked" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | block      | instruction                                                                                                                                                                                                                                                                | live_in                                                                                                                                                                           | live_out                                                                                                                                                                          |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (block start(args()))                                                                                                                                                                                                                                                      | (((name j)(type_ I64))((name partial)(type_ I64)))                                                                                                                                | (((name j)(type_ I64))((name partial)(type_ I64)))                                                                                                                                |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (Move((name n)(type_ I64))(Lit 7))                                                                                                                                                                                                                                         | (((name j)(type_ I64))((name partial)(type_ I64)))                                                                                                                                | (((name n)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                                                                           |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (Move((name i)(type_ I64))(Lit 0))                                                                                                                                                                                                                                         | (((name n)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                                                                           | (((name n)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                                                      |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (Move((name total)(type_ I64))(Lit 0))                                                                                                                                                                                                                                     | (((name n)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                                                      | (((name n)(type_ I64))((name i)(type_ I64))((name total)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                             |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (Branch(Uncond((block((id_hum outerCheck)(args(((name i%0)(type_ I64))((name total%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))))))(args(((name i)(type_ I64))((name total)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))))))         | (((name n)(type_ I64))((name i)(type_ I64))((name total)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                             | (((name n)(type_ I64)))                                                                                                                                                           |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | start      | block end                                                                                                                                                                                                                                                                  | (((name n)(type_ I64)))                                                                                                                                                           | (((name n)(type_ I64)))                                                                                                                                                           |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | (block start(args(((name i%0)(type_ I64))((name total%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64)))))                                                                                                                                                | (((name n)(type_ I64)))                                                                                                                                                           | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | (Sub((dest((name condOuter)(type_ I64)))(src1(Var((name i%0)(type_ I64))))(src2(Var((name n)(type_ I64))))))                                                                                                                                                               | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         | (((name n)(type_ I64))((name i%0)(type_ I64))((name condOuter)(type_ I64))((name total%0)(type_ I64)))                                                                            |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | (Branch(Cond(cond(Var((name condOuter)(type_ I64))))(if_true((block((id_hum outerBody)(args())))(args())))(if_false((block((id_hum exit)(args())))(args())))))                                                                                                             | (((name n)(type_ I64))((name i%0)(type_ I64))((name condOuter)(type_ I64))((name total%0)(type_ I64)))                                                                            | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | block end                                                                                                                                                                                                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (block start(args()))                                                                                                                                                                                                                                                      | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (Move((name j%0)(type_ I64))(Lit 0))                                                                                                                                                                                                                                       | (((name n)(type_ I64))((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                                         | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (Move((name partial%0)(type_ I64))(Lit 0))                                                                                                                                                                                                                                 | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (Branch(Uncond((block((id_hum innerCheck)(args(((name j%1)(type_ I64))((name partial%1)(type_ I64))))))(args(((name j%0)(type_ I64))((name partial%0)(type_ I64)))))))                                                                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | block end                                                                                                                                                                                                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | (block start(args(((name j%1)(type_ I64))((name partial%1)(type_ I64)))))                                                                                                                                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | (Sub((dest((name condInner)(type_ I64)))(src1(Var((name j%0)(type_ I64))))(src2(Lit 3))))                                                                                                                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name condInner)(type_ I64))((name total%0)(type_ I64)))                        |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | (Branch(Cond(cond(Var((name condInner)(type_ I64))))(if_true((block((id_hum innerBody)(args())))(args())))(if_false((block((id_hum innerExit)(args())))(args())))))                                                                                                        | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name condInner)(type_ I64))((name total%0)(type_ I64)))                        | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | block end                                                                                                                                                                                                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (block start(args()))                                                                                                                                                                                                                                                      | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Mul((dest((name tmp)(type_ I64)))(src1(Var((name i%0)(type_ I64))))(src2(Var((name j%0)(type_ I64))))))                                                                                                                                                                   | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name tmp)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Add((dest((name partial%2)(type_ I64)))(src1(Var((name partial%0)(type_ I64))))(src2(Var((name tmp)(type_ I64))))))                                                                                                                                                       | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name tmp)(type_ I64))((name total%0)(type_ I64)))                              | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name partial%2)(type_ I64))((name total%0)(type_ I64)))                        |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Add((dest((name j%2)(type_ I64)))(src1(Var((name j%0)(type_ I64))))(src2(Lit 1))))                                                                                                                                                                                        | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name partial%2)(type_ I64))((name total%0)(type_ I64)))                        | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name partial%2)(type_ I64))((name j%2)(type_ I64))((name total%0)(type_ I64))) |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Branch(Uncond((block((id_hum innerCheck)(args(((name j%1)(type_ I64))((name partial%1)(type_ I64))))))(args(((name j%2)(type_ I64))((name partial%2)(type_ I64)))))))                                                                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name partial%2)(type_ I64))((name j%2)(type_ I64))((name total%0)(type_ I64))) | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | block end                                                                                                                                                                                                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | (block start(args()))                                                                                                                                                                                                                                                      | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | (Add((dest((name total%1)(type_ I64)))(src1(Var((name total%0)(type_ I64))))(src2(Var((name partial%0)(type_ I64))))))                                                                                                                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | (Branch(Uncond((block((id_hum outerInc)(args())))(args()))))                                                                                                                                                                                                               | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | block end                                                                                                                                                                                                                                                                  | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | (block start(args()))                                                                                                                                                                                                                                                      | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | (Add((dest((name i%1)(type_ I64)))(src1(Var((name i%0)(type_ I64))))(src2(Lit 1))))                                                                                                                                                                                        | (((name n)(type_ I64))((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                                                     | (((name n)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64))((name i%1)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | (Branch(Uncond((block((id_hum outerCheck)(args(((name i%0)(type_ I64))((name total%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))))))(args(((name i%1)(type_ I64))((name total%1)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))))))) | (((name n)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64))((name i%1)(type_ I64)))                                                     | (((name n)(type_ I64)))                                                                                                                                                           |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | block end                                                                                                                                                                                                                                                                  | (((name n)(type_ I64)))                                                                                                                                                           | (((name n)(type_ I64)))                                                                                                                                                           |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | exit       | (block start(args()))                                                                                                                                                                                                                                                      | (((name total%0)(type_ I64)))                                                                                                                                                     | (((name total%0)(type_ I64)))                                                                                                                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | exit       | (Return(Var((name total%0)(type_ I64))))                                                                                                                                                                                                                                   | (((name total%0)(type_ I64)))                                                                                                                                                     | {}                                                                                                                                                                                |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | exit       | block end                                                                                                                                                                                                                                                                  | {}                                                                                                                                                                                | {}                                                                                                                                                                                |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |}]
;;


let%expect_test "debug borked opt" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.default borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | block      | instruction                                                                                                                                                                                                                                                                | live_in                                                                                                                               | live_out                                                                                                                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (block start(args()))                                                                                                                                                                                                                                                      | (((name j)(type_ I64))((name partial)(type_ I64)))                                                                                    | (((name j)(type_ I64))((name partial)(type_ I64)))                                                                                    |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (Move((name i)(type_ I64))(Lit 0))                                                                                                                                                                                                                                         | (((name j)(type_ I64))((name partial)(type_ I64)))                                                                                    | (((name i)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                               |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (Move((name total)(type_ I64))(Lit 0))                                                                                                                                                                                                                                     | (((name i)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                                               | (((name i)(type_ I64))((name total)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                      |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | start      | (Branch(Uncond((block((id_hum outerCheck)(args(((name i%0)(type_ I64))((name total%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))))))(args(((name i)(type_ I64))((name total)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))))))         | (((name i)(type_ I64))((name total)(type_ I64))((name j)(type_ I64))((name partial)(type_ I64)))                                      | {}                                                                                                                                    |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | start      | block end                                                                                                                                                                                                                                                                  | {}                                                                                                                                    | {}                                                                                                                                    |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | (block start(args(((name i%0)(type_ I64))((name total%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64)))))                                                                                                                                                | {}                                                                                                                                    | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | (Sub((dest((name condOuter)(type_ I64)))(src1(Var((name i%0)(type_ I64))))(src2(Lit 7))))                                                                                                                                                                                  | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  | (((name i%0)(type_ I64))((name condOuter)(type_ I64))((name total%0)(type_ I64)))                                                     |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | (Branch(Cond(cond(Var((name condOuter)(type_ I64))))(if_true((block((id_hum outerBody)(args())))(args())))(if_false((block((id_hum exit)(args())))(args())))))                                                                                                             | (((name i%0)(type_ I64))((name condOuter)(type_ I64))((name total%0)(type_ I64)))                                                     | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerCheck | block end                                                                                                                                                                                                                                                                  | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (block start(args()))                                                                                                                                                                                                                                                      | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (Move((name j%0)(type_ I64))(Lit 0))                                                                                                                                                                                                                                       | (((name i%0)(type_ I64))((name total%0)(type_ I64)))                                                                                  | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name total%0)(type_ I64)))                                                           |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (Move((name partial%0)(type_ I64))(Lit 0))                                                                                                                                                                                                                                 | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name total%0)(type_ I64)))                                                           | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | (Branch(Uncond((block((id_hum innerCheck)(args())))(args()))))                                                                                                                                                                                                             | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerBody  | block end                                                                                                                                                                                                                                                                  | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | (block start(args()))                                                                                                                                                                                                                                                      | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | (Sub((dest((name condInner)(type_ I64)))(src1(Var((name j%0)(type_ I64))))(src2(Lit 3))))                                                                                                                                                                                  | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name condInner)(type_ I64))((name total%0)(type_ I64))) |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | (Branch(Cond(cond(Var((name condInner)(type_ I64))))(if_true((block((id_hum innerBody)(args())))(args())))(if_false((block((id_hum innerExit)(args())))(args())))))                                                                                                        | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name condInner)(type_ I64))((name total%0)(type_ I64))) | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerCheck | block end                                                                                                                                                                                                                                                                  | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (block start(args()))                                                                                                                                                                                                                                                      | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Mul((dest((name tmp)(type_ I64)))(src1(Var((name i%0)(type_ I64))))(src2(Var((name j%0)(type_ I64))))))                                                                                                                                                                   | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name tmp)(type_ I64))((name total%0)(type_ I64)))       |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Add((dest((name partial%2)(type_ I64)))(src1(Var((name partial%0)(type_ I64))))(src2(Var((name tmp)(type_ I64))))))                                                                                                                                                       | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name tmp)(type_ I64))((name total%0)(type_ I64)))       | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Add((dest((name j%2)(type_ I64)))(src1(Lit 1))(src2(Var((name j%0)(type_ I64))))))                                                                                                                                                                                        | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | (Branch(Uncond((block((id_hum innerCheck)(args())))(args()))))                                                                                                                                                                                                             | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerBody  | block end                                                                                                                                                                                                                                                                  | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | (block start(args()))                                                                                                                                                                                                                                                      | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | (Add((dest((name total%1)(type_ I64)))(src1(Var((name total%0)(type_ I64))))(src2(Var((name partial%0)(type_ I64))))))                                                                                                                                                     | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%0)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | (Branch(Uncond((block((id_hum outerInc)(args())))(args()))))                                                                                                                                                                                                               | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | innerExit  | block end                                                                                                                                                                                                                                                                  | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | (block start(args()))                                                                                                                                                                                                                                                      | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | (Add((dest((name i%1)(type_ I64)))(src1(Lit 1))(src2(Var((name i%0)(type_ I64))))))                                                                                                                                                                                        | (((name i%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64)))                              | (((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64))((name i%1)(type_ I64)))                              |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | (Branch(Uncond((block((id_hum outerCheck)(args(((name i%0)(type_ I64))((name total%0)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))))))(args(((name i%1)(type_ I64))((name total%1)(type_ I64))((name j%0)(type_ I64))((name partial%0)(type_ I64))))))) | (((name j%0)(type_ I64))((name partial%0)(type_ I64))((name total%1)(type_ I64))((name i%1)(type_ I64)))                              | {}                                                                                                                                    |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | outerInc   | block end                                                                                                                                                                                                                                                                  | {}                                                                                                                                    | {}                                                                                                                                    |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | exit       | (block start(args()))                                                                                                                                                                                                                                                      | (((name total%0)(type_ I64)))                                                                                                         | (((name total%0)(type_ I64)))                                                                                                         |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | exit       | (Return(Var((name total%0)(type_ I64))))                                                                                                                                                                                                                                   | (((name total%0)(type_ I64)))                                                                                                         | {}                                                                                                                                    |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      | exit       | block end                                                                                                                                                                                                                                                                  | {}                                                                                                                                    | {}                                                                                                                                    |
      +------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------+
      |}]
;;
