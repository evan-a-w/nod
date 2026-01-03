open! Core

module M (A : Arch.S) = struct
  open A

  module Internal = struct
    type t =
      { ret : unit
      ; rbp : unit
      ; callee_saved : Reg.t list
      ; padding_bytes : int
      ; spill_bytes : int
      ; statically_alloca'd : int
      }

    let callee_saved_bytes t =
      List.map t.callee_saved ~f:(fun reg -> Reg.class_ reg |> Reg.Class.bytes)
      |> List.sum (module Int)
    ;;
  end

  module External = struct
    type t =
      { reg_args : Reg.t list
      ; stack_args : int
      ; reg_results : Reg.t list
      ; stack_results : int
      }
  end
end
