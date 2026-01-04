open! Core
open! Import

let compile_low source =
  match Nod_low.Low.lower_string source with
  | Error err -> Error (Nod_low.Error.to_string err)
  | Ok eir ->
    (match Nod.Eir.compile_parsed (Ok eir) with
     | Ok functions -> Ok functions
     | Error err -> Error (Nod.Nod_error.to_string err))
;;

let check_low_program ?harness source expected =
  List.iter test_architectures ~f:(function
    | (`X86_64 | `Arm64) as arch ->
      let functions =
        match compile_low source with
        | Error err -> failwith err
        | Ok functions -> functions
      in
      let asm =
        Nod.compile_and_lower_functions ~arch ~system:host_system functions
      in
      let output = Nod.execute_asm ~arch ~system:host_system ?harness asm in
      if not (String.equal output expected)
      then
        failwithf
          "arch %s produced %s, expected %s"
          (match arch with
           | `X86_64 -> "x86_64"
           | `Arm64 -> "arm64"
           | `Other -> "other")
          output
          expected
          ()
    | `Other -> ())
;;

let%expect_test "exec struct by-value + sret" =
  check_low_program
    ~harness:
      (Nod.make_harness_source
         ~fn_name:"root"
         ~fn_arg_type:"int64_t"
         ~fn_arg:"40"
         ())
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
    "81"
;;

let%expect_test "exec recursive factorial" =
  check_low_program
    ~harness:
      (Nod.make_harness_source
         ~fn_name:"root"
         ~fn_arg_type:"int64_t"
         ~fn_arg:"6"
         ())
    {|
i64 fact(i64 n) {
  if (n) {
    return n * fact(n - 1);
  } else {
    return 1;
  }
}

i64 root(i64 n) {
  return fact(n);
}
|}
    "720"
;;
