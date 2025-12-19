open! Core
open! Import

module M (A : Arch.S) = struct
  open A

  let all_callee_saved ~call_conv =
    List.concat_map Reg.Class.all ~f:(fun class_ ->
      Reg.callee_saved ~call_conv class_)
    |> Reg.Set.of_list
  ;;

  let arch_reg_defs ir =
    A.to_arch_irs ir |> List.map ~f:Arch_ir.reg_defs |> Reg.Set.union_list
  ;;

  let arch_reg_uses ir =
    A.to_arch_irs ir |> List.map ~f:Arch_ir.reg_uses |> Reg.Set.union_list
  ;;

  let over_physical ~raw_to_raw_list reg =
    Reg.raw reg
    |> raw_to_raw_list
    |> List.filter_map ~f:(fun raw ->
      match A.Reg.Raw.class_ raw with
      | `Variable -> None
      | `Physical class_ -> Some (A.Reg.create ~class_ ~raw))
  ;;

  let get_physical = over_physical ~raw_to_raw_list:Reg.Raw.get_physical
  let should_save = over_physical ~raw_to_raw_list:Reg.Raw.should_save
end
