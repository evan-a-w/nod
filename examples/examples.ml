open! Core

module Textual = struct
  let a =
    {|
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
|}
  ;;

  let super_triv =
    {|
a:
  mov %x:i64, 10

  mov %y:i64, 20

  sub %z:i64, %y, %x

  ret %z

|}
  ;;

  let b =
    {|
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
|}
  ;;

  let c =
    {|
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
|}
  ;;

  let d =
    {|
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
|}
  ;;

  let e =
    {|
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
|}
  ;;

  let c2 =
    {|
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
|}
  ;;

  let e2 =
    {|
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
|}
  ;;

  let f_but_simple =
    {|
(* --- Program: nested-loops with conditionals --------------------------------- *)

start:
  mov %n:i64,    7          (* outer loop upper-bound  (change to taste) *)
  mov %i:i64,    0
  mov %total:i64, 0
  b outerCheck

(* ---------- outer loop ------------------------------------------------------- *)

outerCheck:
  sub %condOuter:i64, %i, %n            (* condOuter = i - n *)
  branch %condOuter, outerBody, exit  (* if i < n → body, else exit *)

outerBody:
  mov %j:i64,      0
  mov %partial:i64, 0
  b innerCheck

(* ---------- inner loop ------------------------------------------------------- *)

innerCheck:
  sub %condInner:i64, %j, 3             (* run while j < 3 *)
  branch %condInner, innerBody, innerExit

(* -- inner loop body (may jump to skipEven) ----------------------------------- *)

innerBody:
  mul %tmp:i64, %i, %j                  (* tmp = i * j *)
  add %partial:i64, %partial, %tmp      (* accumulate into partial *)
  add %j:i64, %j, 1
  b innerCheck

(* ---------- after inner loop ------------------------------------------------- *)

innerExit:
  add %total:i64, %total, %partial      (* fold inner result into total *)

outerInc:
  add %i:i64, %i, 1
  b outerCheck

(* ---------- program end ------------------------------------------------------ *)

exit:
  return %total

|}
  ;;

  let f =
    {|
(* --- Program: nested-loops with conditionals --------------------------------- *)

start:
  mov %n:i64,    7          (* outer loop upper-bound  (change to taste) *)
  mov %i:i64,    0
  mov %total:i64, 0
  branch 1, outerCheck, exit        (* jump into the outer loop *)

(* ---------- outer loop ------------------------------------------------------- *)

outerCheck:
  sub %condOuter:i64, %i, %n            (* condOuter = i - n *)
  branch %condOuter, outerBody, exit  (* if i < n → body, else exit *)

outerBody:
  mov %j:i64,      0
  mov %partial:i64, 0
  branch 1, innerCheck, outerInc    (* enter the inner loop *)

(* ---------- inner loop ------------------------------------------------------- *)

innerCheck:
  sub %condInner:i64, %j, 3             (* run while j < 3 *)
  branch %condInner, innerBody, innerExit

(* -- inner loop body (may jump to skipEven) ----------------------------------- *)

innerBody:
  (* If (j & 1) == 0 we’ll skip this iteration to create an extra edge *)
  and %isEven:i64, %j, 1
  sub %condSkip:i64, %isEven, 0         (* 0 → even, 1 → odd *)
  branch %condSkip, doWork, skipEven

skipEven:
  add %j:i64, %j, 1
  branch 1, innerCheck, innerExit

doWork:
  mul %tmp:i64, %i, %j                  (* tmp = i * j *)
  add %partial:i64, %partial, %tmp      (* accumulate into partial *)
  add %j:i64, %j, 1
  branch 1, innerCheck, innerExit

(* ---------- after inner loop ------------------------------------------------- *)

innerExit:
  add %total:i64, %total, %partial      (* fold inner result into total *)
  branch 1, outerInc, exit

(* ---------- outer-loop increment --------------------------------------------- *)

outerInc:
  add %i:i64, %i, 1
  b outerCheck

(* ---------- program end ------------------------------------------------------ *)

exit:
  return %total

|}
  ;;

  let fib =
    {|
  mov %arg:i64, 10
fib_start:
  mov   %count:i64,  %arg
  mov   %a:i64,      0
  mov   %b:i64,      1
  b     fib_check

fib_check:
  branch %count, fib_body, fib_exit

fib_body:
  add   %next:i64,    %a,      %b
  mov   %a:i64,       %b
  mov   %b:i64,       %next
  sub   %count:i64,   %count,   1
  b     fib_check

fib_exit:
  return %a
|}
  ;;

  let fib_recursive =
    {|
fib(%arg:i64) {
    branch %arg, check1_, ret_1
check1_:
    sub %m1:i64, %arg, 1
    branch %m1, rec, ret_1
ret_1:
      ret 1
rec:
    call fib(%m1) -> %sub1_res:i64

    sub %m2:i64, %m1, 1
    call fib(%m2) -> %sub2_res:i64

    add %res:i64, %sub1_res, %sub2_res
    ret %res
}
|}
  ;;

  let call_chains =
    [ {|
root(%init:i64) {
    call first(%init) -> %first:i64
    call second(%first) -> %second:i64
    call third(%second, %first) -> %third:i64
    ret %third
}
|}
    ; {|
first(%x:i64) {
    add %one:i64, %x, 1
    call fourth(%one, %x) -> %fourth:i64
    ret %fourth
}
|}
    ; {|
second(%y:i64) {
    call third(%y, %y) -> %tmp:i64
    add %res:i64, %tmp, 2
    ret %res
}
|}
    ; {|
third(%u:i64, %v:i64) {
    add %sum:i64, %u, %v
    call helper(%sum) -> %helped:i64
    ret %helped
}
|}
    ; {|
fourth(%p:i64, %q:i64) {
    add %mix:i64, %p, %q
    ret %mix
}
|}
    ; {|
helper(%h:i64) {
    add %res:i64, %h, 3
    ret %res
}
|}
    ]
  ;;

  let sum_100 =
    {|
start:
  mov   %i:i64,    1          
  mov   %sum:i64,  0          
  branch 1,       check, exit    

check:
  sub   %cond:i64,  %i,   100   
  branch %cond,  body, exit 

body:
  add   %sum:i64,  %sum, %i    
  add   %i:i64,    %i,   1    
  branch 1,       check, exit    

exit:
  return %sum              
|}
  ;;

  let all = [ a; b; c; d; e; c2; e2 ]
end
