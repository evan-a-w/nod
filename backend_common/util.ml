open! Core
open! Import

module M (A : Arch.S) = struct
  open A

  let all_callee_saved ~call_conv =
    List.concat_map Reg.Class.all ~f:(fun class_ ->
      Reg.callee_saved ~call_conv class_)
    |> Reg.Set.of_list
  ;;
end
