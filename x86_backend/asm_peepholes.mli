(* Architecture-specific peephole optimizations for x86_64 assembly.
   These optimizations run after register allocation on concrete assembly instructions.

   Optimizations include:
   - Eliminating redundant moves (mov r, r)
   - Removing identity operations (add r, 0; sub r, 0)
   - Removing push/pop pairs
   - Simplifying jumps to the next instruction
   - Folding moves into subsequent operations
*)

(* Optimize a single function's assembly items *)
val optimize_function : X86_asm.fn -> X86_asm.fn

(* Optimize an entire program *)
val optimize_program : X86_asm.program -> X86_asm.program

(* Low-level optimization with custom iteration limit *)
val optimize : ?max_iterations:int -> X86_asm.item list -> X86_asm.item list
