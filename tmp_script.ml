open Core
let () =
  let program = "
mov %a:i64, 5
ret %a
" in
  match Nod.compile program with
  | Error err -> print_endline (Nod_common.Nod_error.to_string err)
  | Ok functions ->
    let asm = Nod_x86_backend.X86_backend.compile_to_asm functions in
    print_endline asm
