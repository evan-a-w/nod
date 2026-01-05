open! Core
open! Import

module Asm = X86_asm
module Reg = X86_reg
module Raw = X86_reg.Raw

module Writer = struct
  type t =
    { bytes : Bytes.t option
    ; mutable pos : int
    }

  let create bytes = { bytes = Some bytes; pos = 0 }
  let create_counter () = { bytes = None; pos = 0 }
  let position t = t.pos

  let emit_u8 t v =
    let byte = Char.of_int_exn (v land 0xFF) in
    (match t.bytes with
     | Some bytes -> Bytes.set bytes t.pos byte
     | None -> ());
    t.pos <- t.pos + 1
  ;;

  let emit_int32_le t v =
    let open Int32 in
    let byte shift = to_int_exn (shift_right_logical v shift land 0xFFl) in
    emit_u8 t (byte 0);
    emit_u8 t (byte 8);
    emit_u8 t (byte 16);
    emit_u8 t (byte 24)
  ;;

  let emit_int64_le t v =
    let open Int64 in
    let byte shift = to_int_exn (shift_right_logical v shift land 0xFFL) in
    emit_u8 t (byte 0);
    emit_u8 t (byte 8);
    emit_u8 t (byte 16);
    emit_u8 t (byte 24);
    emit_u8 t (byte 32);
    emit_u8 t (byte 40);
    emit_u8 t (byte 48);
    emit_u8 t (byte 56)
  ;;
end

type literal =
  { id : int
  ; value : int64
  }

type instr_layout =
  { instr : Asm.instr
  ; size : int
  ; literal_id : int option
  }

type fn_layout =
  { fn : Asm.fn
  ; instrs : instr_layout list
  ; labels : int String.Map.t
  ; literals : literal list
  ; code_size : int
  ; size : int
  ; base : int
  }

type fixup =
  { offset : int
  ; symbol : Asm.symbol
  }

type layout =
  { fns : fn_layout list
  ; labels : int String.Map.t
  ; total_size : int
  ; entry_offsets : int String.Map.t
  }

type encoding =
  { bytes : Bytes.t
  ; fixups : fixup list
  ; entry_offsets : int String.Map.t
  }

let int32_of_int64_exn imm ~context =
  let min = Int64.of_int32 Int32.min_value in
  let max = Int64.of_int32 Int32.max_value in
  if Int64.compare imm min < 0 || Int64.compare imm max > 0
  then failwithf "immediate out of int32 range in %s: %Ld" context imm ()
  else Int64.to_int32_exn imm
;;

let int32_of_int_exn disp ~context =
  let min = Int64.of_int32 Int32.min_value in
  let max = Int64.of_int32 Int32.max_value in
  let disp64 = Int64.of_int disp in
  if Int64.compare disp64 min < 0 || Int64.compare disp64 max > 0
  then failwithf "displacement out of int32 range in %s: %d" context disp ()
  else Int64.to_int32_exn disp64
;;

let raw_code_exn raw =
  match raw with
  | Raw.RAX -> 0
  | Raw.RCX -> 1
  | Raw.RDX -> 2
  | Raw.RBX -> 3
  | Raw.RSP -> 4
  | Raw.RBP -> 5
  | Raw.RSI -> 6
  | Raw.RDI -> 7
  | Raw.R8 -> 8
  | Raw.R9 -> 9
  | Raw.R10 -> 10
  | Raw.R11 -> 11
  | Raw.R12 -> 12
  | Raw.R13 -> 13
  | Raw.R14 -> 14
  | Raw.R15 -> 15
  | Raw.XMM0 -> 0
  | Raw.XMM1 -> 1
  | Raw.XMM2 -> 2
  | Raw.XMM3 -> 3
  | Raw.XMM4 -> 4
  | Raw.XMM5 -> 5
  | Raw.XMM6 -> 6
  | Raw.XMM7 -> 7
  | Raw.XMM8 -> 8
  | Raw.XMM9 -> 9
  | Raw.XMM10 -> 10
  | Raw.XMM11 -> 11
  | Raw.XMM12 -> 12
  | Raw.XMM13 -> 13
  | Raw.XMM14 -> 14
  | Raw.XMM15 -> 15
  | Raw.Unallocated _ | Raw.Allocated _ ->
    failwith "expected physical register"
;;

let raw_is_xmm = function
  | Raw.XMM0
  | Raw.XMM1
  | Raw.XMM2
  | Raw.XMM3
  | Raw.XMM4
  | Raw.XMM5
  | Raw.XMM6
  | Raw.XMM7
  | Raw.XMM8
  | Raw.XMM9
  | Raw.XMM10
  | Raw.XMM11
  | Raw.XMM12
  | Raw.XMM13
  | Raw.XMM14
  | Raw.XMM15 -> true
  | _ -> false
;;

let reg_raw_exn reg =
  match Raw.to_physical (Reg.raw reg) with
  | Some raw -> raw
  | None -> failwith "expected allocated register"
;;

let reg_code_exn reg = reg_raw_exn reg |> raw_code_exn
let reg_is_xmm reg = reg_raw_exn reg |> raw_is_xmm

let expect_xmm_reg reg ~context =
  if not (reg_is_xmm reg)
  then failwithf "%s expects xmm register" context ()
;;

let rm_size_for_base base_code disp =
  let base_low = base_code land 7 in
  let needs_sib = base_low = 4 in
  let disp_size =
    if disp = 0 && base_low <> 5
    then 0
    else if disp >= -128 && disp <= 127
    then 1
    else 4
  in
  let disp_size =
    if disp = 0 && (base_code = 5 || base_code = 13) then 1 else disp_size
  in
  1 + (if needs_sib then 1 else 0) + disp_size
;;

let rm_size = function
  | Reg reg ->
    let _ = reg_code_exn reg in
    1
  | Mem (reg, disp) ->
    let base = reg_code_exn reg in
    rm_size_for_base base disp
  | Imm _ | Spill_slot _ | Symbol _ -> failwith "unexpected rm operand"
;;

let rex_needed ~w ~reg ~rm =
  let reg_high = reg lsr 3 = 1 in
  let rm_high = rm lsr 3 = 1 in
  w || reg_high || rm_high
;;

type rm_operand =
  | Rm_reg of int
  | Rm_mem of
      { base : int
      ; disp : int
      }
  | Rm_rip of int

let rex_b = function
  | Rm_reg code -> code lsr 3
  | Rm_mem { base; _ } -> base lsr 3
  | Rm_rip _ -> 0
;;

let emit_rex w ~w_bit ~r ~x ~b =
  if w_bit || r || x || b
  then
    Writer.emit_u8 w
      (0x40 lor ((if w_bit then 1 else 0) lsl 3) lor ((if r then 1 else 0) lsl 2)
       lor ((if x then 1 else 0) lsl 1) lor (if b then 1 else 0))
;;

let emit_modrm w ~reg ~rm =
  match rm with
  | Rm_reg rm_code ->
    Writer.emit_u8 w ((0b11 lsl 6) lor ((reg land 7) lsl 3) lor (rm_code land 7))
  | Rm_rip disp ->
    Writer.emit_u8 w ((0b00 lsl 6) lor ((reg land 7) lsl 3) lor 0b101);
    Writer.emit_int32_le w (int32_of_int_exn disp ~context:"rip")
  | Rm_mem { base; disp } ->
    let base_low = base land 7 in
    let needs_sib = base_low = 4 in
    let disp_size =
      if disp = 0 && base_low <> 5
      then 0
      else if disp >= -128 && disp <= 127
      then 1
      else 4
    in
    let disp_size =
      if disp = 0 && (base = 5 || base = 13) then 1 else disp_size
    in
    let mod_bits =
      match disp_size with
      | 0 -> 0b00
      | 1 -> 0b01
      | _ -> 0b10
    in
    let rm_field = if needs_sib then 0b100 else base_low in
    Writer.emit_u8 w
      ((mod_bits lsl 6) lor ((reg land 7) lsl 3) lor rm_field);
    if needs_sib
    then Writer.emit_u8 w ((0b00 lsl 6) lor (0b100 lsl 3) lor base_low);
    (match disp_size with
     | 0 -> ()
     | 1 -> Writer.emit_u8 w disp
     | _ -> Writer.emit_int32_le w (int32_of_int_exn disp ~context:"disp32"))
;;

let rm_of_operand = function
  | Reg reg -> Rm_reg (reg_code_exn reg)
  | Mem (reg, disp) -> Rm_mem { base = reg_code_exn reg; disp }
  | Imm _ | Spill_slot _ | Symbol _ -> failwith "unexpected rm operand"
;;

let rm_code_of_operand = function
  | Reg reg -> reg_code_exn reg
  | Mem (reg, _) -> reg_code_exn reg
  | Imm _ | Spill_slot _ | Symbol _ -> failwith "unexpected rm operand"
;;

let rex_size ~w ~reg ~rm = if rex_needed ~w ~reg ~rm then 1 else 0

let sse_size ~reg ~rm ~rm_size = rex_size ~w:false ~reg ~rm + 3 + rm_size
let sse_size_rip ~reg = rex_size ~w:false ~reg ~rm:0 + 3 + 5

let size_of_instr instr ~add_literal =
  match instr with
  | Asm.Mov (dst, src) ->
    (match dst, src with
     | Reg dst_reg, Imm imm when reg_is_xmm dst_reg ->
       let id = add_literal imm in
       sse_size_rip ~reg:(reg_code_exn dst_reg), Some id
     | Reg dst_reg, (Reg _ | Mem _ as src_op) when reg_is_xmm dst_reg ->
       let rm = rm_size src_op in
       let rm_code = rm_code_of_operand src_op in
       let size = sse_size ~reg:(reg_code_exn dst_reg) ~rm:rm_code ~rm_size:rm in
       size, None
     | Mem _, Reg src_reg when reg_is_xmm src_reg ->
       let rm = rm_size dst in
       let rm_code = rm_code_of_operand dst in
       let size = sse_size ~reg:(reg_code_exn src_reg) ~rm:rm_code ~rm_size:rm in
       size, None
     | Reg _, Imm _ ->
       let rex = 1 in
       (rex + 1 + 8), None
     | Reg _, (Reg _ | Mem _) ->
       let rm = rm_size src in
       let rex = 1 in
       (rex + 1 + rm), None
     | Mem _, Reg _ ->
       let rm = rm_size dst in
       let rex = 1 in
       (rex + 1 + rm), None
     | Mem _, Imm imm ->
       let _ = int32_of_int64_exn imm ~context:"mov mem, imm" in
       let rm = rm_size dst in
       let rex = 1 in
       (rex + 1 + rm + 4), None
     | _ -> failwith "unsupported mov operands")
  | Movsd (dst, src) ->
    (match dst, src with
     | Reg dst_reg, Imm imm ->
       let id = add_literal imm in
       sse_size_rip ~reg:(reg_code_exn dst_reg), Some id
     | Reg dst_reg, (Reg _ | Mem _ as src_op) ->
       let rm = rm_size src_op in
       let rm_code = rm_code_of_operand src_op in
       let size = sse_size ~reg:(reg_code_exn dst_reg) ~rm:rm_code ~rm_size:rm in
       size, None
     | Mem _, Reg src_reg ->
       let rm = rm_size dst in
       let rm_code = rm_code_of_operand dst in
       let size = sse_size ~reg:(reg_code_exn src_reg) ~rm:rm_code ~rm_size:rm in
       size, None
     | _ -> failwith "unsupported movsd operands")
  | Movq (dst, src) ->
    (match dst, src with
     | Reg dst_reg, (Reg _ | Mem _ as src_op) when reg_is_xmm dst_reg ->
       let rm = rm_size src_op in
       let rm_code = rm_code_of_operand src_op in
       let size = rex_size ~w:true ~reg:(reg_code_exn dst_reg) ~rm:rm_code + 3 + rm in
       size, None
     | (Reg _ | Mem _ as dst_op), Reg src_reg when reg_is_xmm src_reg ->
       let rm = rm_size dst_op in
       let rm_code = rm_code_of_operand dst_op in
       let size = rex_size ~w:true ~reg:(reg_code_exn src_reg) ~rm:rm_code + 3 + rm in
       size, None
     | _ -> failwith "unsupported movq operands")
  | Cvtsi2sd (_dst, src) ->
    let literal_id =
      match src with
      | Imm imm -> Some (add_literal imm)
      | _ -> None
    in
    let rm_size' =
      match literal_id with
      | Some _ -> 5
      | None -> rm_size src
    in
    let rex = 1 in
    (rex + 3 + rm_size'), literal_id
  | Cvttsd2si (_dst, src) ->
    let literal_id =
      match src with
      | Imm imm -> Some (add_literal imm)
      | _ -> None
    in
    let rm_size' =
      match literal_id with
      | Some _ -> 5
      | None -> rm_size src
    in
    let rex = 1 in
    (rex + 3 + rm_size'), literal_id
  | Add (dst, src)
  | Sub (dst, src)
  | And (dst, src)
  | Or (dst, src)
  | Cmp (dst, src) ->
    (match dst, src with
     | (Reg _ | Mem _ as dst_op), (Reg _ | Mem _ as src_op) ->
       let rm =
         match dst_op, src_op with
         | Reg _, Mem _ -> rm_size src_op
         | Mem _, _ | Reg _, Reg _ -> rm_size dst_op
         | _ -> failwith "unexpected binop operands"
       in
       let rex = 1 in
       (rex + 1 + rm), None
     | (Reg _ | Mem _ as dst_op), Imm imm ->
       let _ = int32_of_int64_exn imm ~context:"binop imm" in
       let rm = rm_size dst_op in
       let rex = 1 in
       (rex + 1 + rm + 4), None
     | _ -> failwith "unsupported binop operands")
  | Addsd (dst, src)
  | Subsd (dst, src)
  | Mulsd (dst, src)
  | Divsd (dst, src) ->
    let literal_id =
      match src with
      | Imm imm -> Some (add_literal imm)
      | _ -> None
    in
    let rm_size' =
      match literal_id with
      | Some _ -> 5
      | None -> rm_size src
    in
    let rm_code =
      match literal_id with
      | Some _ -> 0
      | None -> rm_code_of_operand src
    in
    let dst_reg =
      match dst with
      | Reg reg -> reg
      | _ -> failwith "sse op expects register dst"
    in
    let size =
      sse_size ~reg:(reg_code_exn dst_reg) ~rm:rm_code ~rm_size:rm_size'
    in
    size, literal_id
  | Imul op | Idiv op | Mod op ->
    let rm = rm_size op in
    let rex = 1 in
    (rex + 1 + rm), None
  | Call _ -> 12, None
  | Push op ->
    (match op with
     | Reg reg ->
       let code = reg_code_exn reg in
       let rex = if code >= 8 then 1 else 0 in
       (rex + 1), None
     | Imm imm ->
       let _ = int32_of_int64_exn imm ~context:"push imm" in
       (1 + 4), None
     | Mem _ ->
       let rm = rm_size op in
       let rm_code = rm_code_of_operand op in
       let rex = rex_size ~w:false ~reg:0 ~rm:rm_code in
       (rex + 1 + rm), None
     | Spill_slot _ -> failwith "unexpected spill slot"
     | Symbol _ -> failwith "globals are not supported in the x86 jit")
  | Pop reg ->
    let code = reg_code_exn reg in
    let rex = if code >= 8 then 1 else 0 in
    (rex + 1), None
  | Jmp _ -> 5, None
  | Je _ | Jne _ -> 6, None
  | Ret -> 1, None
;;

let layout_fn (fn : Asm.fn) =
  let literals_rev = ref [] in
  let add_literal value =
    let id = List.length !literals_rev in
    literals_rev := { id; value } :: !literals_rev;
    id
  in
  let labels = String.Map.empty in
  let labels = ref labels in
  let instrs_rev = ref [] in
  let offset = ref 0 in
  let add_instr instr =
    let size, literal_id = size_of_instr instr ~add_literal in
    instrs_rev := { instr; size; literal_id } :: !instrs_rev;
    offset := !offset + size
  in
  List.iter fn.items ~f:(function
    | Asm.Label label -> labels := Map.set !labels ~key:label ~data:!offset
    | Asm.Instr instr -> add_instr instr);
  let literals = List.rev !literals_rev in
  let instrs = List.rev !instrs_rev in
  let code_size = !offset in
  let size = code_size + (List.length literals * 8) in
  { fn; instrs; labels = !labels; literals; code_size; size; base = 0 }
;;

let layout_program (program : Asm.program) =
  let layouts = List.map program ~f:layout_fn in
  let total_size = ref 0 in
  let labels = ref String.Map.empty in
  let entry_offsets = ref String.Map.empty in
  let fns =
    List.map layouts ~f:(fun layout ->
      let base = !total_size in
      total_size := !total_size + layout.size;
      let labels_with_base =
        Map.map layout.labels ~f:(fun offset -> offset + base)
      in
      labels := Map.merge !labels labels_with_base ~f:(fun ~key:_ -> function
        | `Left v -> Some v
        | `Right v -> Some v
        | `Both _ -> failwith "duplicate label")
      ;
      entry_offsets :=
        Map.set
          !entry_offsets
          ~key:layout.fn.name
          ~data:(Map.find_exn labels_with_base layout.fn.asm_label);
      { layout with base })
  in
  { fns; labels = !labels; total_size = !total_size; entry_offsets = !entry_offsets }
;;

let emit_binop w ~opcode_rm_reg ~opcode_reg_rm ~imm_reg ~dst ~src =
  match dst, src with
  | Reg dst_reg, Mem _ ->
    let rm = rm_of_operand src in
    let reg = reg_code_exn dst_reg in
    let rex_r = reg lsr 3 = 1 in
    let rex_b = rex_b rm = 1 in
    emit_rex w ~w_bit:true ~r:rex_r ~x:false ~b:rex_b;
    Writer.emit_u8 w opcode_reg_rm;
    emit_modrm w ~reg ~rm
  | Reg dst_reg, Reg src_reg ->
    let rm = Rm_reg (reg_code_exn dst_reg) in
    let reg = reg_code_exn src_reg in
    let rex_r = reg lsr 3 = 1 in
    let rex_b = rex_b rm = 1 in
    emit_rex w ~w_bit:true ~r:rex_r ~x:false ~b:rex_b;
    Writer.emit_u8 w opcode_rm_reg;
    emit_modrm w ~reg ~rm
  | Mem _, Reg src_reg ->
    let rm = rm_of_operand dst in
    let reg = reg_code_exn src_reg in
    let rex_r = reg lsr 3 = 1 in
    let rex_b = rex_b rm = 1 in
    emit_rex w ~w_bit:true ~r:rex_r ~x:false ~b:rex_b;
    Writer.emit_u8 w opcode_rm_reg;
    emit_modrm w ~reg ~rm
  | (Reg _ | Mem _), Imm imm ->
    let rm = rm_of_operand dst in
    let reg = imm_reg in
    let rex_r = reg lsr 3 = 1 in
    let rex_b = rex_b rm = 1 in
    emit_rex w ~w_bit:true ~r:rex_r ~x:false ~b:rex_b;
    Writer.emit_u8 w 0x81;
    emit_modrm w ~reg ~rm;
    Writer.emit_int32_le w (int32_of_int64_exn imm ~context:"binop imm")
  | _ -> failwith "unsupported binop"
;;

let emit_sse_rm_reg w ~prefix ~opcode ~dst_reg ~src_rm =
  Writer.emit_u8 w prefix;
  emit_rex w
    ~w_bit:false
    ~r:(reg_code_exn dst_reg lsr 3 = 1)
    ~x:false
    ~b:(rex_b src_rm = 1);
  Writer.emit_u8 w 0x0F;
  Writer.emit_u8 w opcode;
  emit_modrm w ~reg:(reg_code_exn dst_reg) ~rm:src_rm
;;

let emit_sse_reg_rm w ~prefix ~opcode ~dst_rm ~src_reg =
  Writer.emit_u8 w prefix;
  emit_rex w
    ~w_bit:false
    ~r:(reg_code_exn src_reg lsr 3 = 1)
    ~x:false
    ~b:(rex_b dst_rm = 1);
  Writer.emit_u8 w 0x0F;
  Writer.emit_u8 w opcode;
  emit_modrm w ~reg:(reg_code_exn src_reg) ~rm:dst_rm
;;

let encode_instr
  ~writer
  ~labels
  ~literal_offsets
  ~call_fixups
  instr_layout
  =
  let instr = instr_layout.instr in
  let emit_literal_rm () =
    match instr_layout.literal_id with
    | None -> failwith "missing literal id"
    | Some id ->
      let literal_offset = List.nth_exn literal_offsets id in
      let disp = literal_offset - (Writer.position writer + instr_layout.size) in
      Rm_rip disp
  in
  match instr with
  | Asm.Mov (dst, src) ->
    (match dst, src with
     | Reg dst_reg, Imm _ when reg_is_xmm dst_reg ->
       expect_xmm_reg dst_reg ~context:"mov xmm, imm";
       let rm = emit_literal_rm () in
       emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x10 ~dst_reg ~src_rm:rm
     | Reg dst_reg, (Reg _ | Mem _ as src_op) when reg_is_xmm dst_reg ->
       (match src_op with
        | Reg src_reg -> expect_xmm_reg src_reg ~context:"mov xmm, reg"
        | Mem _ -> ()
        | _ -> assert false);
       let rm = rm_of_operand src_op in
       emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x10 ~dst_reg ~src_rm:rm
     | Mem _, Reg src_reg when reg_is_xmm src_reg ->
       expect_xmm_reg src_reg ~context:"mov mem, xmm";
       let rm = rm_of_operand dst in
       emit_sse_reg_rm writer ~prefix:0xF2 ~opcode:0x11 ~dst_rm:rm ~src_reg
     | Reg dst_reg, Imm imm ->
       let reg = reg_code_exn dst_reg in
       emit_rex writer ~w_bit:true ~r:false ~x:false ~b:(reg lsr 3 = 1);
       Writer.emit_u8 writer (0xB8 + (reg land 7));
       Writer.emit_int64_le writer imm
     | Reg dst_reg, (Reg _ | Mem _ as src_op) ->
       (match src_op with
        | Reg _ ->
          let rm = Rm_reg (reg_code_exn dst_reg) in
          let src_reg = reg_of_operand_exn src_op in
          if reg_is_xmm src_reg
          then failwith "mov gpr from xmm without movq";
          let reg = reg_code_exn src_reg in
          emit_rex writer
            ~w_bit:true
            ~r:(reg lsr 3 = 1)
            ~x:false
            ~b:(rex_b rm = 1);
          Writer.emit_u8 writer 0x89;
          emit_modrm writer ~reg ~rm
        | Mem _ ->
          let rm = rm_of_operand src_op in
          let reg = reg_code_exn dst_reg in
          emit_rex writer
            ~w_bit:true
            ~r:(reg lsr 3 = 1)
            ~x:false
            ~b:(rex_b rm = 1);
          Writer.emit_u8 writer 0x8B;
          emit_modrm writer ~reg ~rm
        | _ -> assert false)
     | Mem _, Reg src_reg ->
       let rm = rm_of_operand dst in
       let reg = reg_code_exn src_reg in
       emit_rex writer
         ~w_bit:true
         ~r:(reg lsr 3 = 1)
         ~x:false
         ~b:(rex_b rm = 1);
       Writer.emit_u8 writer 0x89;
       emit_modrm writer ~reg ~rm
     | Mem _, Imm imm ->
       let rm = rm_of_operand dst in
       emit_rex writer ~w_bit:true ~r:false ~x:false ~b:(rex_b rm = 1);
       Writer.emit_u8 writer 0xC7;
       emit_modrm writer ~reg:0 ~rm;
       Writer.emit_int32_le writer (int32_of_int64_exn imm ~context:"mov")
     | _ -> failwith "unsupported mov")
  | Movsd (dst, src) ->
    (match dst, src with
     | Reg dst_reg, Imm _ ->
       expect_xmm_reg dst_reg ~context:"movsd xmm, imm";
       let rm = emit_literal_rm () in
       emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x10 ~dst_reg ~src_rm:rm
     | Reg dst_reg, (Reg _ | Mem _ as src_op) ->
       expect_xmm_reg dst_reg ~context:"movsd dst";
       (match src_op with
        | Reg src_reg -> expect_xmm_reg src_reg ~context:"movsd src"
        | Mem _ -> ()
        | _ -> assert false);
       let rm = rm_of_operand src_op in
       emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x10 ~dst_reg ~src_rm:rm
     | Mem _, Reg src_reg ->
       expect_xmm_reg src_reg ~context:"movsd store";
       let rm = rm_of_operand dst in
       emit_sse_reg_rm writer ~prefix:0xF2 ~opcode:0x11 ~dst_rm:rm ~src_reg
     | _ -> failwith "unsupported movsd")
  | Movq (dst, src) ->
    (match dst, src with
     | Reg dst_reg, (Reg _ | Mem _ as src_op) when reg_is_xmm dst_reg ->
       expect_xmm_reg dst_reg ~context:"movq dst";
       (match src_op with
        | Reg src_reg when reg_is_xmm src_reg ->
          failwith "movq expects gpr/mem source, got xmm"
        | _ -> ());
       let rm = rm_of_operand src_op in
       Writer.emit_u8 writer 0x66;
       emit_rex writer
         ~w_bit:true
         ~r:(reg_code_exn dst_reg lsr 3 = 1)
         ~x:false
         ~b:(rex_b rm = 1);
       Writer.emit_u8 writer 0x0F;
       Writer.emit_u8 writer 0x6E;
       emit_modrm writer ~reg:(reg_code_exn dst_reg) ~rm
     | (Reg _ | Mem _ as dst_op), Reg src_reg ->
       if not (reg_is_xmm src_reg)
       then failwith "movq expects xmm source for store";
       let rm = rm_of_operand dst_op in
       Writer.emit_u8 writer 0x66;
       emit_rex writer
         ~w_bit:true
         ~r:(reg_code_exn src_reg lsr 3 = 1)
         ~x:false
         ~b:(rex_b rm = 1);
       Writer.emit_u8 writer 0x0F;
       Writer.emit_u8 writer 0x7E;
       emit_modrm writer ~reg:(reg_code_exn src_reg) ~rm
     | _ -> failwith "unsupported movq")
  | Cvtsi2sd (dst, src) ->
    let dst_reg =
      match dst with
      | Reg reg -> reg
      | _ -> failwith "cvtsi2sd expects register dst"
    in
    expect_xmm_reg dst_reg ~context:"cvtsi2sd dst";
    let rm =
      match src with
      | Imm _ -> emit_literal_rm ()
      | _ -> rm_of_operand src
    in
    Writer.emit_u8 writer 0xF2;
    emit_rex writer
      ~w_bit:true
      ~r:(reg_code_exn dst_reg lsr 3 = 1)
      ~x:false
      ~b:(rex_b rm = 1);
    Writer.emit_u8 writer 0x0F;
    Writer.emit_u8 writer 0x2A;
    emit_modrm writer ~reg:(reg_code_exn dst_reg) ~rm
  | Cvttsd2si (dst, src) ->
    let dst_reg =
      match dst with
      | Reg reg -> reg
      | _ -> failwith "cvttsd2si expects register dst"
    in
    (match src with
     | Reg src_reg -> expect_xmm_reg src_reg ~context:"cvttsd2si src"
     | _ -> ());
    let rm =
      match src with
      | Imm _ -> emit_literal_rm ()
      | _ -> rm_of_operand src
    in
    Writer.emit_u8 writer 0xF2;
    emit_rex writer
      ~w_bit:true
      ~r:(reg_code_exn dst_reg lsr 3 = 1)
      ~x:false
      ~b:(rex_b rm = 1);
    Writer.emit_u8 writer 0x0F;
    Writer.emit_u8 writer 0x2C;
    emit_modrm writer ~reg:(reg_code_exn dst_reg) ~rm
  | Addsd (dst, src) ->
    let dst_reg =
      match dst with
      | Reg reg -> reg
      | _ -> failwith "addsd expects register dst"
    in
    expect_xmm_reg dst_reg ~context:"addsd dst";
    (match src with
     | Reg src_reg -> expect_xmm_reg src_reg ~context:"addsd src"
     | _ -> ());
    let rm =
      match src with
      | Imm _ -> emit_literal_rm ()
      | _ -> rm_of_operand src
    in
    emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x58 ~dst_reg ~src_rm:rm
  | Subsd (dst, src) ->
    let dst_reg =
      match dst with
      | Reg reg -> reg
      | _ -> failwith "subsd expects register dst"
    in
    expect_xmm_reg dst_reg ~context:"subsd dst";
    (match src with
     | Reg src_reg -> expect_xmm_reg src_reg ~context:"subsd src"
     | _ -> ());
    let rm =
      match src with
      | Imm _ -> emit_literal_rm ()
      | _ -> rm_of_operand src
    in
    emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x5C ~dst_reg ~src_rm:rm
  | Mulsd (dst, src) ->
    let dst_reg =
      match dst with
      | Reg reg -> reg
      | _ -> failwith "mulsd expects register dst"
    in
    expect_xmm_reg dst_reg ~context:"mulsd dst";
    (match src with
     | Reg src_reg -> expect_xmm_reg src_reg ~context:"mulsd src"
     | _ -> ());
    let rm =
      match src with
      | Imm _ -> emit_literal_rm ()
      | _ -> rm_of_operand src
    in
    emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x59 ~dst_reg ~src_rm:rm
  | Divsd (dst, src) ->
    let dst_reg =
      match dst with
      | Reg reg -> reg
      | _ -> failwith "divsd expects register dst"
    in
    expect_xmm_reg dst_reg ~context:"divsd dst";
    (match src with
     | Reg src_reg -> expect_xmm_reg src_reg ~context:"divsd src"
     | _ -> ());
    let rm =
      match src with
      | Imm _ -> emit_literal_rm ()
      | _ -> rm_of_operand src
    in
    emit_sse_rm_reg writer ~prefix:0xF2 ~opcode:0x5E ~dst_reg ~src_rm:rm
  | Add (dst, src) ->
    emit_binop writer ~opcode_rm_reg:0x01 ~opcode_reg_rm:0x03 ~imm_reg:0 ~dst ~src
  | Sub (dst, src) ->
    emit_binop writer ~opcode_rm_reg:0x29 ~opcode_reg_rm:0x2B ~imm_reg:5 ~dst ~src
  | And (dst, src) ->
    emit_binop writer ~opcode_rm_reg:0x21 ~opcode_reg_rm:0x23 ~imm_reg:4 ~dst ~src
  | Or (dst, src) ->
    emit_binop writer ~opcode_rm_reg:0x09 ~opcode_reg_rm:0x0B ~imm_reg:1 ~dst ~src
  | Cmp (dst, src) ->
    (match dst, src with
     | (Reg _ | Mem _ as dst_op), (Reg _ | Mem _ as src_op) ->
       let rm, reg, opcode =
         match dst_op, src_op with
         | Reg dst_reg, Mem _ ->
           rm_of_operand src_op, reg_code_exn dst_reg, 0x3B
         | Reg dst_reg, Reg src_reg ->
           Rm_reg (reg_code_exn dst_reg), reg_code_exn src_reg, 0x39
         | Mem _, Reg src_reg -> rm_of_operand dst_op, reg_code_exn src_reg, 0x39
         | _ -> failwith "unexpected cmp operands"
       in
       emit_rex writer
         ~w_bit:true
         ~r:(reg lsr 3 = 1)
         ~x:false
         ~b:(rex_b rm = 1);
       Writer.emit_u8 writer opcode;
       emit_modrm writer ~reg ~rm
     | (Reg _ | Mem _ as dst_op), Imm imm ->
       let rm = rm_of_operand dst_op in
       emit_rex writer ~w_bit:true ~r:false ~x:false ~b:(rex_b rm = 1);
       Writer.emit_u8 writer 0x81;
       emit_modrm writer ~reg:7 ~rm;
       Writer.emit_int32_le writer (int32_of_int64_exn imm ~context:"cmp")
     | _ -> failwith "unsupported cmp")
  | Imul op ->
    let rm = rm_of_operand op in
    emit_rex writer ~w_bit:true ~r:false ~x:false ~b:(rex_b rm = 1);
    Writer.emit_u8 writer 0xF7;
    emit_modrm writer ~reg:5 ~rm
  | Idiv op | Mod op ->
    let rm = rm_of_operand op in
    emit_rex writer ~w_bit:true ~r:false ~x:false ~b:(rex_b rm = 1);
    Writer.emit_u8 writer 0xF7;
    emit_modrm writer ~reg:7 ~rm
  | Call symbol ->
    let imm_offset = Writer.position writer + 2 in
    call_fixups := { offset = imm_offset; symbol } :: !call_fixups;
    emit_rex writer ~w_bit:true ~r:false ~x:false ~b:false;
    Writer.emit_u8 writer 0xB8;
    Writer.emit_int64_le writer 0L;
    Writer.emit_u8 writer 0xFF;
    Writer.emit_u8 writer 0xD0
  | Push op ->
    (match op with
     | Reg reg ->
       let code = reg_code_exn reg in
       emit_rex writer ~w_bit:false ~r:false ~x:false ~b:(code lsr 3 = 1);
       Writer.emit_u8 writer (0x50 + (code land 7))
     | Imm imm ->
       Writer.emit_u8 writer 0x68;
       Writer.emit_int32_le writer (int32_of_int64_exn imm ~context:"push")
     | Mem _ ->
       let rm = rm_of_operand op in
       emit_rex writer ~w_bit:false ~r:false ~x:false ~b:(rex_b rm = 1);
       Writer.emit_u8 writer 0xFF;
       emit_modrm writer ~reg:6 ~rm
     | Spill_slot _ -> failwith "unexpected spill slot"
     | Symbol _ -> failwith "globals are not supported in the x86 jit")
  | Pop reg ->
    let code = reg_code_exn reg in
    emit_rex writer ~w_bit:false ~r:false ~x:false ~b:(code lsr 3 = 1);
    Writer.emit_u8 writer (0x58 + (code land 7))
  | Jmp target ->
    let target_offset = Map.find_exn labels target in
    let disp = target_offset - (Writer.position writer + instr_layout.size) in
    Writer.emit_u8 writer 0xE9;
    Writer.emit_int32_le writer (int32_of_int_exn disp ~context:"jmp")
  | Je target ->
    let target_offset = Map.find_exn labels target in
    let disp = target_offset - (Writer.position writer + instr_layout.size) in
    Writer.emit_u8 writer 0x0F;
    Writer.emit_u8 writer 0x84;
    Writer.emit_int32_le writer (int32_of_int_exn disp ~context:"je")
  | Jne target ->
    let target_offset = Map.find_exn labels target in
    let disp = target_offset - (Writer.position writer + instr_layout.size) in
    Writer.emit_u8 writer 0x0F;
    Writer.emit_u8 writer 0x85;
    Writer.emit_int32_le writer (int32_of_int_exn disp ~context:"jne")
  | Ret -> Writer.emit_u8 writer 0xC3
;;

let encode (program : Asm.program) =
  let layout = layout_program program in
  let bytes = Bytes.create layout.total_size in
  let writer = Writer.create bytes in
  let fixups = ref [] in
  List.iter layout.fns ~f:(fun fn_layout ->
    let literal_offsets =
      List.mapi fn_layout.literals ~f:(fun idx _ ->
        fn_layout.base + fn_layout.code_size + (idx * 8))
    in
    List.iter fn_layout.instrs ~f:(fun instr_layout ->
      encode_instr
        ~writer
        ~labels:layout.labels
        ~literal_offsets
        ~call_fixups:fixups
        instr_layout);
    List.iter fn_layout.literals ~f:(fun lit ->
      Writer.emit_int64_le writer lit.value));
  { bytes; fixups = !fixups; entry_offsets = layout.entry_offsets }
;;
