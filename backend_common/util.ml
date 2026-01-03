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

  let over_physical ~raw_to_raw_opt reg =
    match Reg.raw reg |> raw_to_raw_opt with
    | None -> None
    | Some raw ->
      (match A.Reg.Raw.class_ raw with
       | `Variable -> None
       | `Physical class_ -> Some (A.Reg.create ~class_ ~raw))
  ;;

  let of_raw_exn raw =
    match Reg.Raw.class_ raw with
    | `Variable -> failwith "[of_raw_exn] called on non physical register"
    | `Physical class_ -> Reg.create ~raw ~class_
  ;;

  let to_physical = over_physical ~raw_to_raw_opt:Reg.Raw.to_physical
  let should_save = over_physical ~raw_to_raw_opt:Reg.Raw.should_save

  let filter_physical_reg set =
    Set.to_list set
    |> List.filter_map ~f:to_physical
    |> List.dedup_and_sort ~compare:A.Reg.compare
  ;;

  let new_name map v =
    let v' =
      match Hashtbl.find map v with
      | None -> v
      | Some i -> v ^ Int.to_string i
    in
    Hashtbl.update map v ~f:(function
      | None -> 0
      | Some i -> i + 1);
    v'
  ;;
end
