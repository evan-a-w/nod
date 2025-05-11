open! Core

include
  String_id.Make
    (struct
      let module_name = "Mnemonic"
    end)
    ()

let of_string_opt s = Some (of_string s)
