(* Architecture-specific peephole optimizations for ARM64 assembly.
   These optimizations run after register allocation on concrete assembly instructions.

   Optimizations include:
   - Eliminating redundant moves (mov r, r)
   - Simplifying arithmetic with same operands (sub r, r, r -> mov r, #0)
   - Simplifying logical operations (eor r, r, r -> mov r, #0)
   - Removing branches to the next instruction
   - Folding moves into subsequent operations
   - Simplifying comparisons of identical operands
*)

(* Optimize a single function's assembly items *)
val optimize_function : Arm64_asm.fn -> Arm64_asm.fn

(* Optimize an entire program *)
val optimize_program : Arm64_asm.program -> Arm64_asm.program

(* Low-level optimization with custom iteration limit *)
val optimize : ?max_iterations:int -> Arm64_asm.item list -> Arm64_asm.item list
