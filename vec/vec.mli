open! Core

type ('a, +'perms) permissioned [@@deriving sexp]
type 'a t = ('a, [ `Read | `Write ]) permissioned [@@deriving sexp]
type 'a read = ('a, [ `Read ]) permissioned [@@deriving sexp]

val read : 'a t -> 'a read
val create : ?capacity:int -> unit -> ('a, [ `Read | `Write ]) permissioned
val length : ('a, [> `Read ]) permissioned -> int
val get : ('a, [> `Read ]) permissioned -> int -> 'a
val get_opt : ('a, [> `Read ]) permissioned -> int -> 'a option
val set : ('a, [> `Write ]) permissioned -> int -> 'a -> unit
val iter : ('a, [> `Read ]) permissioned -> f:('a -> unit) -> unit

val iter_nested
  :  (('a, [> `Read ]) permissioned, [> `Read ]) permissioned
  -> f:('a -> unit)
  -> unit

val iteri : ('a, [> `Read ]) permissioned -> f:(int -> 'a -> unit) -> unit
val iteri_rev : ('a, [> `Read ]) permissioned -> f:(int -> 'a -> unit) -> unit
val iter_rev : ('a, [> `Read ]) permissioned -> f:('a -> unit) -> unit
val fold : ('a, [> `Read ]) permissioned -> init:'b -> f:('b -> 'a -> 'b) -> 'b
val foldr : ('a, [> `Read ]) permissioned -> init:'b -> f:('b -> 'a -> 'b) -> 'b
val push : ('a, [> `Write ]) permissioned -> 'a -> unit
val pop_exn : ('a, [> `Read | `Write ]) permissioned -> 'a
val pop : ('a, [> `Read | `Write ]) permissioned -> 'a option

val fill_to_length
  :  ('a, [> `Write ]) permissioned
  -> length:int
  -> f:(int -> 'a)
  -> unit

val map
  :  ('a, [> `Read ]) permissioned
  -> f:('a -> 'b)
  -> ('b, [ `Read | `Write ]) permissioned

val fold_map
  :  ('a, [> `Read ]) permissioned
  -> init:'acc
  -> f:('acc -> 'a -> 'acc * 'b)
  -> ('b, [ `Read | `Write ]) permissioned

val of_list : 'a list -> ('a, [ `Read | `Write ]) permissioned
val to_list : ('a, [> `Read ]) permissioned -> 'a list
val to_array : ('a, [> `Read ]) permissioned -> 'a array

val mem
  :  ('a, [> `Read ]) permissioned
  -> 'a
  -> compare:('a -> 'a -> int)
  -> bool

val take
  :  ('a, [> `Write ]) permissioned
  -> other:('a, [> `Write ]) permissioned
  -> unit

val switch
  :  ('a, [> `Write ]) permissioned
  -> ('a, [> `Write ]) permissioned
  -> unit

val last : ('a, [> `Read ]) permissioned -> 'a option
val last_exn : ('a, [> `Read ]) permissioned -> 'a

val filter
  :  ('a, [> `Read ]) permissioned
  -> f:('a -> bool)
  -> ('a, [ `Read | `Write ]) permissioned

val filter_map
  :  ('a, [> `Read ]) permissioned
  -> f:('a -> 'b option)
  -> ('b, [ `Read | `Write ]) permissioned

val filter_inplace
  :  ('a, [> `Read | `Write ]) permissioned
  -> f:('a -> bool)
  -> unit

val filter_map_inplace
  :  ('a, [> `Read | `Write ]) permissioned
  -> f:('a -> 'a option)
  -> unit

val findi
  :  ('a, [> `Read ]) permissioned
  -> f:(int -> 'a -> 'b option)
  -> 'b option

val map_inplace : ('a, [> `Read | `Write ]) permissioned -> f:('a -> 'a) -> unit
val singleton : 'a -> ('a, [ `Read | `Write ]) permissioned

val concat_map
  :  ('a, [> `Read ]) permissioned
  -> f:('a -> ('b, [> `Read ]) permissioned)
  -> ('b, [ `Read | `Write ]) permissioned

val concat_mapi
  :  ('a, [> `Read ]) permissioned
  -> f:(int -> 'a -> ('b, [> `Read ]) permissioned)
  -> ('b, [ `Read | `Write ]) permissioned

val concat
  :  (('a, [> `Read ]) permissioned, [> `Read ]) permissioned
  -> ('a, [ `Read | `Write ]) permissioned

val concat_list
  :  ('a, [> `Read ]) permissioned list
  -> ('a, [ `Read | `Write ]) permissioned

val append_list : ('a, [> `Write ]) permissioned -> 'a list -> unit

val append
  :  ('a, [> `Write ]) permissioned
  -> ('a, [> `Read ]) permissioned
  -> unit

val to_sequence : ('a, [> `Read ]) permissioned -> 'a Sequence.t
val clear : ('a, [> `Write ]) permissioned -> unit

val reverse
  :  ('a, [> `Read ]) permissioned
  -> ('a, [ `Read | `Write ]) permissioned

val reverse_inplace : ('a, [> `Read | `Write ]) permissioned -> unit

val zip_exn
  :  ('a, [> `Read ]) permissioned
  -> ('b, [> `Read ]) permissioned
  -> ('a * 'b, [ `Read | `Write ]) permissioned
