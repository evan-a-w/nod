open! Core

module Textual = struct
  let a =
    {|
a:
  mov %x, 10

  mov %y, 20

  sub %z, %y, %x

  branch 1, b, c

b:
  add %z, %z, 5
  branch 1, end, end

c:
  mov %z, 0
  branch 1, end, end

end:
  unreachable
|}
  ;;

  let b =
    {|
  (* Initialize two variables *)
  mov %a, 4
  mov %b, 5

  (* Multiply a * b -> %c *)
  mul %c, %a, %b

  (* If we treat '1' as always-true, jump to label "divide" *)
  branch 1, divide, end

divide:
  (* Divide %c by 2 *)
  div %c, %c, 2
  branch 1, end, end

end:
  unreachable
|}
  ;;

  let c =
    {|
entry:
  (* Put 100 into %a *)
  mov %a, 100

  (* Put 6 into %b *)
  mov %b, 6

  (* Compute a mod b -> %res *)
  mod %res, %a, %b

  (* Add 1 to %res *)
  add %res, %res, 1

  (* End of the program *)
  unreachable
|}
  ;;

  let d =
    {|
  (* Initialize iteration counter *)
  mov %i, 0

  (* Initialize sum *)
  mov %sum, 0

  (* Jump to the loop *)
  branch 1, loop, loop

loop:
  (* sum = sum + i *)
  add %sum, %sum, %i

  add %i, %i, 1

  (* We want to continue looping if i < 10
     We'll synthesize i < 10 by: cond = 10 - i
     If cond != 0, keep looping. If cond == 0, end. *)
  sub %cond, 10, %i

  branch %cond, loop, end

end:
  unreachable
|}
  ;;

  let e =
    {|
start:
  mov %x, 7
  mov %y, 2

  mul %x, %x, 3

  div %x, %x, %y

  (* Then check if y == 2 to decide next path
     We emulate a check by subtracting 2 from y
     sub %cond, %y, 2 *)
  branch %cond, ifTrue, ifFalse

ifTrue:
  (* If y != 2, we would land here
     For illustration, set x = 999 *)
  mov %x, 999
  branch 1, end, end

ifFalse:
  (* If y == 2, we come here
     Let’s set x = x + 10 *)
  add %x, %x, 10
  branch 1, end, end

end:
  unreachable
|}
  ;;

  let all = [ a; b; c; d; e ]
end
