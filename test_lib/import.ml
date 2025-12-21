include Nod_core
include Nod_common
include Nod

let host_system = Lazy.force Nod.host_system

let should_run_arm64_tests =
  match Core.Sys.getenv "NOD_RUN_ARM64_TESTS" with
  | Some "1" | Some "true" | Some "TRUE" -> true
  | _ -> false
;;

let test_architectures : [ `X86_64 | `Arm64 | `Other ] list =
  match Lazy.force Nod.host_arch with
  | `Arm64 when should_run_arm64_tests -> [ `X86_64; `Arm64 ]
  | `Arm64 -> [ `X86_64 ]
  | `X86_64 -> [ `X86_64 ]
  | `Other -> []
;;

let arch_to_string = function
  | `X86_64 -> "x86_64"
  | `Arm64 -> "arm64"
  | `Other -> "other"
;;

let compile_and_execute_on_arch
  arch
  ?harness
  ?opt_flags
  program
  =
  Nod.compile_and_execute ~arch ~system:host_system ?harness ?opt_flags program
;;
