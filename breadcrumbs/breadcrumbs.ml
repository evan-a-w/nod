(* TODO: args should be typed - currently can only be in int regs not float *)
let add_typed_function_args = ()

(* as an optimisation *)
let frame_pointer_omission = ()
let add_return_values_on_stack = ()
let arm64_stack_args = ()

(* right now we just enforce that variables used in mem offsets CAN'T be spilled (I think) *)
let smarter_mem_offset_regalloc = ()

(* with enough spills / alloca'd memory stuff will die on arm because the offset bytes is relatively small. Maybe also true on x86? *)
let arm64_larger_stack_offsets = ()
