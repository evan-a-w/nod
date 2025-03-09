type 'instr block =
  { mutable args : string Vec.t
  ; parents : 'instr block Vec.t
  ; children : 'instr block Vec.t
  ; mutable instructions : 'instr Vec.t
  ; mutable terminal : 'instr
  ; mutable dfs_id : int option
  }
[@@deriving fields]
