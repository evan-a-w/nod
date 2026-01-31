open! Core
open! Import

include
  String_id.Make
    (struct
      let module_name = "Block_id"
    end)
    ()
