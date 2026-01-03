open! Core
open! Import

let () = Breadcrumbs.add_typed_function_args

type 'block t' =
  { call_conv : Call_conv.t
  ; mutable root : 'block [@hash.ignore]
  ; args : Var.t list
  ; name : string
  ; mutable prologue : 'block option [@hash.ignore]
  ; mutable epilogue : 'block option [@hash.ignore]
  ; mutable bytes_for_clobber_saves : int
       [@hash.ignore]
       (* this is the bytes AFTER rbp (which may or may not be exclusive of the rbp push *)
  ; mutable bytes_for_padding : int [@hash.ignore]
  ; mutable bytes_for_spills : int [@hash.ignore]
  ; mutable bytes_statically_alloca'd : int [@hash.ignore]
  }
[@@deriving sexp, compare, equal, hash, fields]

let stack_header_bytes
  { name = _
  ; root = _
  ; call_conv = _
  ; args = _
  ; prologue = _
  ; epilogue = _
  ; bytes_statically_alloca'd
  ; bytes_for_clobber_saves
  ; bytes_for_spills
  ; bytes_for_padding
  }
  =
  bytes_statically_alloca'd
  + bytes_for_clobber_saves
  + bytes_for_spills
  + bytes_for_padding
;;

let create ~name ~args ~root =
  { name
  ; call_conv = Default
  ; root
  ; args
  ; prologue = None
  ; epilogue = None
  ; bytes_statically_alloca'd = 0
  ; bytes_for_spills = 0
  ; bytes_for_clobber_saves = 0
  ; bytes_for_padding = 0
  }
;;

let map_root
  { name
  ; root
  ; call_conv
  ; args
  ; prologue = _
  ; epilogue = _
  ; bytes_statically_alloca'd
  ; bytes_for_clobber_saves
  ; bytes_for_spills
  ; bytes_for_padding
  }
  ~f
  =
  { name
  ; call_conv
  ; root = f root
  ; args
  ; prologue = None
  ; epilogue = None
  ; bytes_statically_alloca'd
  ; bytes_for_spills
  ; bytes_for_clobber_saves
  ; bytes_for_padding
  }
;;

let iter_root
  { root
  ; name = _
  ; call_conv = _
  ; args = _
  ; prologue = _
  ; epilogue = _
  ; bytes_statically_alloca'd = _
  ; bytes_for_clobber_saves = _
  ; bytes_for_spills = _
  ; bytes_for_padding = _
  }
  ~f
  =
  f root
;;
