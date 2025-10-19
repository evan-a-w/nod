open! Core

type 'block t' =
  { call_conv : Call_conv.t
  ; mutable root : 'block [@hash.ignore]
  ; args : string list
  ; name : string
  ; mutable prologue : 'block option [@hash.ignore]
  ; mutable epilogue : 'block option [@hash.ignore]
  ; (* stack layout: *) mutable bytes_alloca'd : int [@hash.ignore]
  ; mutable bytes_for_spills : int [@hash.ignore]
  ; mutable bytes_for_clobber_saves : int [@hash.ignore]
  }
[@@deriving sexp, compare, equal, hash, fields]

let create ~name ~args ~root =
  { name
  ; call_conv = Default
  ; root
  ; args
  ; prologue = None
  ; epilogue = None
  ; bytes_alloca'd = 0
  ; bytes_for_spills = 0
  ; bytes_for_clobber_saves = 0
  }
;;

let map_root
  { name
  ; root
  ; call_conv
  ; args
  ; prologue = _
  ; epilogue = _
  ; bytes_alloca'd
  ; bytes_for_clobber_saves
  ; bytes_for_spills
  }
  ~f
  =
  { name
  ; call_conv
  ; root = f root
  ; args
  ; prologue = None
  ; epilogue = None
  ; bytes_alloca'd
  ; bytes_for_spills
  ; bytes_for_clobber_saves
  }
;;

let iter_root
  { root
  ; name = _
  ; call_conv = _
  ; args = _
  ; prologue = _
  ; epilogue = _
  ; bytes_alloca'd = _
  ; bytes_for_clobber_saves = _
  ; bytes_for_spills = _
  }
  ~f
  =
  f root
;;
