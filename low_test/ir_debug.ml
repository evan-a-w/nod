open! Core
open! Import

let sret_program =
  {|
struct Pair {
  a: i64;
  b: i64;
};

struct Pair make(i64 x, i64 y) {
  struct Pair p;
  p.a = x;
  p.b = y;
  return p;
}

i64 sum(struct Pair p) {
  return p.a + p.b;
}

i64 root(i64 x) {
  struct Pair q;
  q = make(x, x + 1);
  return sum(q);
}
|}
;;

let print_ir0 name fn =
  let ~instrs_by_label, ~labels = fn.Function0.root in
  let blocks =
    Vec.to_list labels
    |> List.map ~f:(fun label ->
      label, Vec.to_list (Map.find_exn instrs_by_label label))
  in
  print_s [%sexp ((name, blocks) : string * (string * string Ir0.t list) list)]
;;

let host_system = Lazy.force Nod.host_system

let compile_low source =
  match Nod_low.Low.lower_string source with
  | Error err -> Error (Nod_low.Error.to_string err)
  | Ok eir ->
    (match Nod.Eir.compile_parsed ~opt_flags:Nod.Eir.Opt_flags.no_opt (Ok eir) with
     | Ok functions -> Ok functions
     | Error err -> Error (Nod.Nod_error.to_string err))
;;

let%expect_test "sret by-value ir0" =
  match Nod_low.Low.lower_string sret_program with
  | Error err -> Nod_low.Error.to_string err |> print_endline
  | Ok program ->
    print_ir0 "make" (Map.find_exn program "make");
    print_ir0 "sum" (Map.find_exn program "sum");
    print_ir0 "root" (Map.find_exn program "root");
  [%expect
    {|
    (make
     ((%root
       ((Alloca ((dest ((name p) (type_ Ptr))) (size (Lit 16))))
        (Store_field
         ((base (Var ((name p) (type_ Ptr)))) (src (Var ((name x) (type_ I64))))
          (type_ (Tuple (I64 I64))) (indices (0))))
        (Store_field
         ((base (Var ((name p) (type_ Ptr)))) (src (Var ((name y) (type_ I64))))
          (type_ (Tuple (I64 I64))) (indices (1))))
        (Memcpy
         ((dest (Var ((name __ret0) (type_ Ptr))))
          (src (Var ((name p) (type_ Ptr)))) (type_ (Tuple (I64 I64)))))
        (Return (Var ((name __ret0) (type_ Ptr))))))))
    (sum
     ((%root
       ((Load_field
         ((dest ((name __tmp0) (type_ I64))) (base (Var ((name p) (type_ Ptr))))
          (type_ (Tuple (I64 I64))) (indices (0))))
        (Load_field
         ((dest ((name __tmp1) (type_ I64))) (base (Var ((name p) (type_ Ptr))))
          (type_ (Tuple (I64 I64))) (indices (1))))
        (Add
         ((dest ((name __tmp2) (type_ I64)))
          (src1 (Var ((name __tmp0) (type_ I64))))
          (src2 (Var ((name __tmp1) (type_ I64))))))
        (Return (Var ((name __tmp2) (type_ I64))))))))
    (root
     ((%root
       ((Alloca ((dest ((name q) (type_ Ptr))) (size (Lit 16))))
        (Add
         ((dest ((name __tmp0) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
          (src2 (Lit 1))))
        (Alloca ((dest ((name __tmp1) (type_ Ptr))) (size (Lit 16))))
        (Call (fn make) (results ())
         (args
          ((Var ((name __tmp1) (type_ Ptr))) (Var ((name x) (type_ I64)))
           (Var ((name __tmp0) (type_ I64))))))
        (Memcpy
         ((dest (Var ((name q) (type_ Ptr))))
          (src (Var ((name __tmp1) (type_ Ptr)))) (type_ (Tuple (I64 I64)))))
        (Alloca ((dest ((name __tmp2) (type_ Ptr))) (size (Lit 16))))
        (Memcpy
         ((dest (Var ((name __tmp2) (type_ Ptr))))
          (src (Var ((name q) (type_ Ptr)))) (type_ (Tuple (I64 I64)))))
        (Call (fn sum) (results (((name __tmp3) (type_ I64))))
         (args ((Var ((name __tmp2) (type_ Ptr))))))
        (Return (Var ((name __tmp3) (type_ I64))))))))
    |}]
;;

let%expect_test "sret by-value compiled ir" =
  match Nod_low.Low.lower_string sret_program with
  | Error err -> Nod_low.Error.to_string err |> print_endline
  | Ok eir ->
    (match Nod.Eir.compile_parsed ~opt_flags:Nod.Eir.Opt_flags.no_opt (Ok eir) with
     | Error err -> Nod.Nod_error.to_string err |> print_endline
    | Ok functions ->
      Function.print_verbose (Map.find_exn functions "make");
      Function.print_verbose (Map.find_exn functions "sum");
      Function.print_verbose (Map.find_exn functions "root"));
  [%expect
    {|
    ((call_conv Default)
     (root
      ((%root
        (args
         (((name __ret0) (type_ Ptr)) ((name x) (type_ I64))
          ((name y) (type_ I64))))
        (instrs
         ((Alloca ((dest ((name p) (type_ Ptr))) (size (Lit 16))))
          (Store (Var ((name x) (type_ I64)))
           (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
          (Store (Var ((name y) (type_ I64)))
           (Address ((base (Var ((name p) (type_ Ptr)))) (offset 8))))
          (Load ((name __tmp0) (type_ I64))
           (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
          (Store (Var ((name __tmp0) (type_ I64)))
           (Address ((base (Var ((name __ret0) (type_ Ptr)))) (offset 0))))
          (Load ((name __tmp1) (type_ I64))
           (Address ((base (Var ((name p) (type_ Ptr)))) (offset 8))))
          (Store (Var ((name __tmp1) (type_ I64)))
           (Address ((base (Var ((name __ret0) (type_ Ptr)))) (offset 8))))
          (Return (Var ((name __ret0) (type_ Ptr)))))))))
     (args
      (((name __ret0) (type_ Ptr)) ((name x) (type_ I64)) ((name y) (type_ I64))))
     (name make) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
     (bytes_for_spills 0) (bytes_for_clobber_saves 0))
    ((call_conv Default)
     (root
      ((%root (args (((name p) (type_ Ptr))))
        (instrs
         ((Load ((name __tmp0) (type_ I64))
           (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
          (Load ((name __tmp1) (type_ I64))
           (Address ((base (Var ((name p) (type_ Ptr)))) (offset 8))))
          (Add
           ((dest ((name __tmp2) (type_ I64)))
            (src1 (Var ((name __tmp0) (type_ I64))))
            (src2 (Var ((name __tmp1) (type_ I64))))))
          (Return (Var ((name __tmp2) (type_ I64)))))))))
     (args (((name p) (type_ Ptr)))) (name sum) (prologue ()) (epilogue ())
     (bytes_alloca'd 0) (bytes_for_spills 0) (bytes_for_clobber_saves 0))
    ((call_conv Default)
     (root
      ((%root (args (((name x) (type_ I64))))
        (instrs
         ((Alloca ((dest ((name q) (type_ Ptr))) (size (Lit 16))))
          (Add
           ((dest ((name __tmp0) (type_ I64)))
            (src1 (Var ((name x) (type_ I64)))) (src2 (Lit 1))))
          (Alloca ((dest ((name __tmp1) (type_ Ptr))) (size (Lit 16))))
          (Call (fn make) (results ())
           (args
            ((Var ((name __tmp1) (type_ Ptr))) (Var ((name x) (type_ I64)))
             (Var ((name __tmp0) (type_ I64))))))
          (Load ((name __tmp4) (type_ I64))
           (Address ((base (Var ((name __tmp1) (type_ Ptr)))) (offset 0))))
          (Store (Var ((name __tmp4) (type_ I64)))
           (Address ((base (Var ((name q) (type_ Ptr)))) (offset 0))))
          (Load ((name __tmp5) (type_ I64))
           (Address ((base (Var ((name __tmp1) (type_ Ptr)))) (offset 8))))
          (Store (Var ((name __tmp5) (type_ I64)))
           (Address ((base (Var ((name q) (type_ Ptr)))) (offset 8))))
          (Alloca ((dest ((name __tmp2) (type_ Ptr))) (size (Lit 16))))
          (Load ((name __tmp6) (type_ I64))
           (Address ((base (Var ((name q) (type_ Ptr)))) (offset 0))))
          (Store (Var ((name __tmp6) (type_ I64)))
           (Address ((base (Var ((name __tmp2) (type_ Ptr)))) (offset 0))))
          (Load ((name __tmp7) (type_ I64))
           (Address ((base (Var ((name q) (type_ Ptr)))) (offset 8))))
          (Store (Var ((name __tmp7) (type_ I64)))
           (Address ((base (Var ((name __tmp2) (type_ Ptr)))) (offset 8))))
          (Call (fn sum) (results (((name __tmp3) (type_ I64))))
           (args ((Var ((name __tmp2) (type_ Ptr))))))
          (Return (Var ((name __tmp3) (type_ I64)))))))))
     (args (((name x) (type_ I64)))) (name root) (prologue ()) (epilogue ())
     (bytes_alloca'd 0) (bytes_for_spills 0) (bytes_for_clobber_saves 0))
    |}]
;;

let%expect_test "sret by-value x86 asm" =
  (match compile_low sret_program with
   | Error err -> print_endline err
   | Ok functions ->
     let asm =
       Nod.compile_and_lower_functions ~arch:`X86_64 ~system:host_system functions
     in
     print_endline asm);
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl make
    make:
      sub rsp, 16
      push rbp
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 40
      mov r12, rdi
      mov r13, rsi
      mov r15, rdx
    make___root:
      mov r14, rbp
      mov [r14], r13
      mov [r14 + 8], r15
      mov r15, [r14]
      mov [r12], r15
      mov r15, [r14 + 8]
      mov [r12 + 8], r15
      mov rax, r12
    make__make__epilogue:
      mov rsp, rbp
      sub rsp, 40
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      add rsp, 16
      ret

    .globl root
    root:
      sub rsp, 48
      push rbp
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 40
      mov r11, rdi
    root___root:
      mov r12, rbp
      mov r15, r11
      add r15, 1
      mov r13, rbp
      add r13, 16
      mov rdi, r13
      mov rsi, r11
      mov rdx, r15
      call make
      mov r15, [r13]
      mov [r12], r15
      mov r15, [r13 + 8]
      mov [r12 + 8], r15
      mov r14, rbp
      add r14, 32
      mov r15, [r12]
      mov [r14], r15
      mov r15, [r12 + 8]
      mov [r14 + 8], r15
      mov rdi, r14
      call sum
      mov r15, rax
      mov rax, r15
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 40
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      add rsp, 48
      ret

    .globl sum
    sum:
      push rbp
      push r14
      push r15
      mov rbp, rsp
      add rbp, 24
      mov r14, rdi
    sum___root:
      mov r15, [r14]
      mov r14, [r14 + 8]
      add r15, r14
      mov rax, r15
    sum__sum__epilogue:
      mov rsp, rbp
      sub rsp, 24
      pop r15
      pop r14
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "sret by-value arm64 asm" =
  (match compile_low sret_program with
   | Error err -> print_endline err
   | Ok functions ->
     let asm =
       Nod.compile_and_lower_functions ~arch:`Arm64 ~system:host_system functions
     in
     print_endline asm);
  [%expect
    {|
    .text
    .globl make
    make:
      mov x14, #16
      sub sp, sp, x14
      mov x14, #48
      sub sp, sp, x14
      str x25, [sp]
      str x26, [sp, #8]
      str x27, [sp, #16]
      str x28, [sp, #24]
      str x29, [sp, #32]
      str x30, [sp, #40]
      mov x29, sp
      mov x14, #48
      add x29, x29, x14
      mov x0, x0
      mov x1, x1
      mov x2, x2
      mov x25, x0
      mov x26, x1
      mov x28, x2
    make___root:
      mov x27, x29
      str x26, [x27]
      str x28, [x27, #8]
      ldr x28, [x27]
      str x28, [x25]
      ldr x28, [x27, #8]
      str x28, [x25, #8]
      mov x0, x25
    make__make__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #48
      sub sp, sp, x14
      ldr x30, [sp, #40]
      ldr x29, [sp, #32]
      ldr x28, [sp, #24]
      ldr x27, [sp, #16]
      ldr x26, [sp, #8]
      ldr x25, [sp]
      mov x14, #48
      add sp, sp, x14
      mov x14, #16
      add sp, sp, x14
      ret

    .globl root
    root:
      mov x14, #56
      sub sp, sp, x14
      mov x14, #56
      sub sp, sp, x14
      str x24, [sp]
      str x25, [sp, #8]
      str x26, [sp, #16]
      str x27, [sp, #24]
      str x28, [sp, #32]
      str x29, [sp, #40]
      str x30, [sp, #48]
      mov x29, sp
      mov x14, #56
      add x29, x29, x14
      mov x0, x0
      mov x24, x0
    root___root:
      mov x25, x29
      mov x14, #1
      add x28, x24, x14
      mov x26, x29
      mov x14, #16
      add x26, x26, x14
      mov x0, x26
      mov x1, x24
      mov x2, x28
      bl make
      ldr x28, [x26]
      str x28, [x25]
      ldr x28, [x26, #8]
      str x28, [x25, #8]
      mov x27, x29
      mov x14, #32
      add x27, x27, x14
      ldr x28, [x25]
      str x28, [x27]
      ldr x28, [x25, #8]
      str x28, [x27, #8]
      mov x0, x27
      bl sum
      mov x28, x0
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #56
      sub sp, sp, x14
      ldr x30, [sp, #48]
      ldr x29, [sp, #40]
      ldr x28, [sp, #32]
      ldr x27, [sp, #24]
      ldr x26, [sp, #16]
      ldr x25, [sp, #8]
      ldr x24, [sp]
      mov x14, #56
      add sp, sp, x14
      mov x14, #56
      add sp, sp, x14
      ret

    .globl sum
    sum:
      mov x14, #32
      sub sp, sp, x14
      str x27, [sp]
      str x28, [sp, #8]
      str x29, [sp, #16]
      str x30, [sp, #24]
      mov x29, sp
      mov x14, #32
      add x29, x29, x14
      mov x0, x0
      mov x28, x0
    sum___root:
      ldr x27, [x28]
      ldr x28, [x28, #8]
      add x28, x27, x28
      mov x0, x28
    sum__sum__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #32
      sub sp, sp, x14
      ldr x30, [sp, #24]
      ldr x29, [sp, #16]
      ldr x28, [sp, #8]
      ldr x27, [sp]
      mov x14, #32
      add sp, sp, x14
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;
