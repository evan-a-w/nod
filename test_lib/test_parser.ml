open! Core
open! Import

let test s =
  s
  |> Parser.parse_string
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok output -> print_s [%sexp (output : Parser.output)]
;;

let%expect_test "simple" =
  {|
mov %a:i64, 3
branch 1, a, b
a:
add %a:i64, 1, 2
b:
add %a:i64, %a, 4
|}
  |> test;
  [%expect
    {|
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Move ((name a) (type_ I64)) (Lit 3))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block a) (args ())))
               (if_false ((block b) (args ())))))))
           (a
            ((Add ((dest ((name a) (type_ I64))) (src1 (Lit 1)) (src2 (Lit 2))))))
           (b
            ((Add
              ((dest ((name a) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
               (src2 (Lit 4))))))))
         (~labels (%root a b))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let%expect_test "simple with comment" =
  {|
mov %a:i64, 3
    (* CommenT!!*)
branch 1, a, b
a:
add %a:i64, 1, 2
b end
b:
add %a:i64, %a, 4
end:
    unreachable

|}
  |> test;
  [%expect
    {|
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Move ((name a) (type_ I64)) (Lit 3))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block a) (args ())))
               (if_false ((block b) (args ())))))))
           (a
            ((Add ((dest ((name a) (type_ I64))) (src1 (Lit 1)) (src2 (Lit 2))))
             (Branch (Uncond ((block end) (args ()))))))
           (b
            ((Add
              ((dest ((name a) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
               (src2 (Lit 4))))))
           (end (Unreachable))))
         (~labels (%root a b end))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let%expect_test "alloca parses" =
  {|
mov %len:i64, 8
alloca %ptr:ptr, 16
alloca %dyn:ptr, %len
ret %ptr
|}
  |> test;
  [%expect
    {|
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Move ((name len) (type_ I64)) (Lit 8))
             (Alloca ((dest ((name ptr) (type_ Ptr))) (size (Lit 16))))
             (Alloca
              ((dest ((name dyn) (type_ Ptr)))
               (size (Var ((name len) (type_ I64))))))
             (Return (Var ((name ptr) (type_ Ptr))))))))
         (~labels (%root))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let%expect_test "call parses" =
  {|
call bar(%a:i64, 7) -> (%r0:i64, %r1:i64)
call foo()
ret %r0
|} |> test;
  [%expect
    {|
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Call (fn bar)
              (results (((name r0) (type_ I64)) ((name r1) (type_ I64))))
              (args ((Var ((name a) (type_ I64))) (Lit 7))))
             (Call (fn foo) (results ()) (args ()))
             (Return (Var ((name r0) (type_ I64))))))))
         (~labels (%root))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let%expect_test "aggregate helpers parse" =
  {|
alloca %ptr:ptr, (i64, f64)
load_field %hi:i64, %ptr, (i64, f64), 0
load_field %lo:f64, %ptr, (i64, f64), 1
store_field %ptr, %lo, (i64, f64), 1
memcpy %ptr, %ptr, (i64, (f64, i32))
|}
  |> test;
  [%expect
    {|
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Alloca ((dest ((name ptr) (type_ Ptr))) (size (Lit 16))))
             (Load ((name hi) (type_ I64))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 0))))
             (Load ((name lo) (type_ F64))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 8))))
             (Store (Var ((name lo) (type_ F64)))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 8))))
             (Load ((name __tmp0) (type_ I64))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 0))))
             (Store (Var ((name __tmp0) (type_ I64)))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 0))))
             (Load ((name __tmp1) (type_ F64))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 8))))
             (Store (Var ((name __tmp1) (type_ F64)))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 8))))
             (Load ((name __tmp2) (type_ I32))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 16))))
             (Store (Var ((name __tmp2) (type_ I32)))
              (Address ((base (Var ((name ptr) (type_ Ptr)))) (offset 16))))))))
         (~labels (%root))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let%expect_test "sizeof literal" =
  {|
mov %a:i64, sizeof[i64]
alloca %buf:ptr, sizeof[(i64, f64)]
ret %a
|}
  |> test;
  [%expect
    {|
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Move ((name a) (type_ I64)) (Lit 8))
             (Alloca ((dest ((name buf) (type_ Ptr))) (size (Lit 16))))
             (Return (Var ((name a) (type_ I64))))))))
         (~labels (%root))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let%expect_test "all examples" =
  List.iter Examples.Textual.all ~f:(fun s ->
    print_endline "---------------------------------";
    print_endline s;
    print_endline "=================================";
    test s;
    print_endline "---------------------------------");
  [%expect
    {|
    ---------------------------------

    a:
      mov %x:i64, 10

      mov %y:i64, 20

      sub %z:i64, %y, %x

      branch 1, b, c

    b:
      add %z:i64, %z, 5
      branch 1, end, end

    c:
      mov %z:i64, 0
      branch 1, end, end

    end:
      ret %z

    =================================
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((a
            ((Move ((name x) (type_ I64)) (Lit 10))
             (Move ((name y) (type_ I64)) (Lit 20))
             (Sub
              ((dest ((name z) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
               (src2 (Var ((name x) (type_ I64))))))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block b) (args ())))
               (if_false ((block c) (args ())))))))
           (b
            ((Add
              ((dest ((name z) (type_ I64))) (src1 (Var ((name z) (type_ I64))))
               (src2 (Lit 5))))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
               (if_false ((block end) (args ())))))))
           (c
            ((Move ((name z) (type_ I64)) (Lit 0))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
               (if_false ((block end) (args ())))))))
           (end ((Return (Var ((name z) (type_ I64))))))))
         (~labels (a b c end))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    ---------------------------------
    ---------------------------------

      (* Initialize two variables *)
      mov %a:i64, 4
      mov %b:i64, 5

      (* Multiply a * b -> %c *)
      mul %c:i64, %a, %b

      (* If we treat '1' as always-true, jump to label "divide" *)
      branch 1, divide, end

    divide:
      (* Divide %c by 2 *)
      div %c:i64, %c, 2
      branch 1, end, end

    end:
      unreachable

    =================================
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Move ((name a) (type_ I64)) (Lit 4))
             (Move ((name b) (type_ I64)) (Lit 5))
             (Mul
              ((dest ((name c) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
               (src2 (Var ((name b) (type_ I64))))))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block divide) (args ())))
               (if_false ((block end) (args ())))))))
           (divide
            ((Div
              ((dest ((name c) (type_ I64))) (src1 (Var ((name c) (type_ I64))))
               (src2 (Lit 2))))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
               (if_false ((block end) (args ())))))))
           (end (Unreachable))))
         (~labels (%root divide end))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    ---------------------------------
    ---------------------------------

    entry:
      (* Put 100 into %a *)
      mov %a:i64, 100

      (* Put 6 into %b *)
      mov %b:i64, 6

      (* Compute a mod b -> %res *)
      mod %res:i64, %a, %b

      (* Add 1 to %res *)
      add %res:i64, %res, 1

      (* End of the program *)
      unreachable

    =================================
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((entry
            ((Move ((name a) (type_ I64)) (Lit 100))
             (Move ((name b) (type_ I64)) (Lit 6))
             (Mod
              ((dest ((name res) (type_ I64)))
               (src1 (Var ((name a) (type_ I64))))
               (src2 (Var ((name b) (type_ I64))))))
             (Add
              ((dest ((name res) (type_ I64)))
               (src1 (Var ((name res) (type_ I64)))) (src2 (Lit 1))))
             Unreachable))))
         (~labels (entry))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    ---------------------------------
    ---------------------------------

      (* Initialize iteration counter *)
      mov %i:i64, 0

      (* Initialize sum *)
      mov %sum:i64, 0

      (* Jump to the loop *)
      branch 1, loop, loop

    loop:
      (* sum = sum + i *)
      add %sum:i64, %sum, %i

      add %i:i64, %i, 1

      (* We want to continue looping if i < 10
         We'll synthesize i < 10 by: cond = 10 - i
         If cond != 0, keep looping. If cond == 0, end. *)
      sub %cond:i64, 10, %i

      branch %cond, loop, end

    end:
      unreachable

    =================================
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((%root
            ((Move ((name i) (type_ I64)) (Lit 0))
             (Move ((name sum) (type_ I64)) (Lit 0))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block loop) (args ())))
               (if_false ((block loop) (args ())))))))
           (end (Unreachable))
           (loop
            ((Add
              ((dest ((name sum) (type_ I64)))
               (src1 (Var ((name sum) (type_ I64))))
               (src2 (Var ((name i) (type_ I64))))))
             (Add
              ((dest ((name i) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
               (src2 (Lit 1))))
             (Sub
              ((dest ((name cond) (type_ I64))) (src1 (Lit 10))
               (src2 (Var ((name i) (type_ I64))))))
             (Branch
              (Cond (cond (Var ((name cond) (type_ I64))))
               (if_true ((block loop) (args ())))
               (if_false ((block end) (args ())))))))))
         (~labels (%root loop end))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    ---------------------------------
    ---------------------------------

    start:
      mov %x:i64, 7
      mov %y:i64, 2

      mul %x:i64, %x, 3

      div %x:i64, %x, %y

      (* Then check if y == 2 to decide next path
         We emulate a check by subtracting 2 from y *)
      sub %cond:i64, %y, 2
      branch %cond, ifTrue, ifFalse

    ifTrue:
      (* If y != 2, we would land here
         For illustration, set x = 999 *)
      mov %x:i64, 999
      branch 1, end, end

    ifFalse:
      (* If y == 2, we come here
         Let’s set x = x + 10 *)
      add %x:i64, %x, 10
      branch 1, end, end

    end:
      unreachable

    =================================
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((end (Unreachable))
           (ifFalse
            ((Add
              ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
               (src2 (Lit 10))))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
               (if_false ((block end) (args ())))))))
           (ifTrue
            ((Move ((name x) (type_ I64)) (Lit 999))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
               (if_false ((block end) (args ())))))))
           (start
            ((Move ((name x) (type_ I64)) (Lit 7))
             (Move ((name y) (type_ I64)) (Lit 2))
             (Mul
              ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
               (src2 (Lit 3))))
             (Div
              ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
               (src2 (Var ((name y) (type_ I64))))))
             (Sub
              ((dest ((name cond) (type_ I64)))
               (src1 (Var ((name y) (type_ I64)))) (src2 (Lit 2))))
             (Branch
              (Cond (cond (Var ((name cond) (type_ I64))))
               (if_true ((block ifTrue) (args ())))
               (if_false ((block ifFalse) (args ())))))))))
         (~labels (start ifTrue ifFalse end))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    ---------------------------------
    ---------------------------------

    entry:
      (* Put 100 into %a *)
      mov %a:i64, 100

      (* Put 6 into %b *)
      mov %b:i64, 6

      (* Compute a mod b -> %res *)
      mod %res:i64, %a, %b

      (* Add 1 to %res *)
      add %res:i64, %res, 1

      (* End of the program *)
      return %res

    =================================
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((entry
            ((Move ((name a) (type_ I64)) (Lit 100))
             (Move ((name b) (type_ I64)) (Lit 6))
             (Mod
              ((dest ((name res) (type_ I64)))
               (src1 (Var ((name a) (type_ I64))))
               (src2 (Var ((name b) (type_ I64))))))
             (Add
              ((dest ((name res) (type_ I64)))
               (src1 (Var ((name res) (type_ I64)))) (src2 (Lit 1))))
             (Return (Var ((name res) (type_ I64))))))))
         (~labels (entry))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    ---------------------------------
    ---------------------------------

    start:
      mov %x:i64, 7
      mov %y:i64, 2

      mul %x:i64, %x, 3

      div %x:i64, %x, %y

      (* Then check if y == 2 to decide next path
         We emulate a check by subtracting 2 from y *)
      sub %cond:i64, %y, 2
      branch %cond, ifTrue, ifFalse

    ifTrue:
      (* If y != 2, we would land here
         For illustration, set x = 999 *)
      mov %x:i64, 999
      branch 1, end, end

    ifFalse:
      (* If y == 2, we come here
         Let’s set x = x + 10 *)
      add %x:i64, %x, 10
      branch 1, end, end

    end:
      return %x

    =================================
    ((root
      ((call_conv Default)
       (root
        ((~instrs_by_label
          ((end ((Return (Var ((name x) (type_ I64))))))
           (ifFalse
            ((Add
              ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
               (src2 (Lit 10))))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
               (if_false ((block end) (args ())))))))
           (ifTrue
            ((Move ((name x) (type_ I64)) (Lit 999))
             (Branch
              (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
               (if_false ((block end) (args ())))))))
           (start
            ((Move ((name x) (type_ I64)) (Lit 7))
             (Move ((name y) (type_ I64)) (Lit 2))
             (Mul
              ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
               (src2 (Lit 3))))
             (Div
              ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
               (src2 (Var ((name y) (type_ I64))))))
             (Sub
              ((dest ((name cond) (type_ I64)))
               (src1 (Var ((name y) (type_ I64)))) (src2 (Lit 2))))
             (Branch
              (Cond (cond (Var ((name cond) (type_ I64))))
               (if_true ((block ifTrue) (args ())))
               (if_false ((block ifFalse) (args ())))))))))
         (~labels (start ifTrue ifFalse end))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    ---------------------------------
    |}]
;;
