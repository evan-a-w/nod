open! Core
open! Import

type ('var, 'block) t =
  { globals : Global.t list
  ; functions : ('var, 'block) Function.t String.Map.t
  }
[@@deriving sexp]

let empty = { globals = []; functions = String.Map.empty }
let map_functions t ~f = { t with functions = Map.map t.functions ~f }

let map_function_roots t ~f =
  { t with functions = Map.map t.functions ~f:(Function.map_root ~f) }
;;
