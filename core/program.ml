open! Core
open! Import

type 'block t =
  { globals : Global.t list
  ; functions : 'block Function0.t' String.Map.t
  }
[@@deriving sexp]

let map_functions t ~f = { t with functions = Map.map t.functions ~f }

let map_function_roots t ~f =
  { t with functions = Map.map t.functions ~f:(Function0.map_root ~f) }
