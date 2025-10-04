open! Core

type 'a t [@@deriving sexp]

val create : ?capacity:int -> unit -> 'a t
val length : 'a t -> int
val get : 'a t -> int -> 'a
val get_opt : 'a t -> int -> 'a option
val set : 'a t -> int -> 'a -> unit
val iter : 'a t -> f:('a -> unit) -> unit
val iter_nested : 'a t t -> f:('a -> unit) -> unit
val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
val iteri_rev : 'a t -> f:(int -> 'a -> unit) -> unit
val fold : 'a t -> init:'b -> f:('b -> 'a -> 'b) -> 'b
val push : 'a t -> 'a -> unit
val pop_exn : 'a t -> 'a
val fill_to_length : 'a t -> length:int -> f:(int -> 'a) -> unit
val map : 'a t -> f:('a -> 'b) -> 'b t
val of_list : 'a list -> 'a t
val to_list : 'a t -> 'a list
val to_array : 'a t -> 'a array
val mem : 'a t -> 'a -> compare:('a -> 'a -> int) -> bool
val take : 'a t -> other:'a t -> unit
val switch : 'a t -> 'a t -> unit
val last : 'a t -> 'a option
val last_exn : 'a t -> 'a
val filter : 'a t -> f:('a -> bool) -> 'a t
val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
val filter_inplace : 'a t -> f:('a -> bool) -> unit
val filter_map_inplace : 'a t -> f:('a -> 'a option) -> unit
val findi : 'a t -> f:(int -> 'a -> 'b option) -> 'b option
val map_inplace : 'a t -> f:('a -> 'a) -> unit
val singleton : 'a -> 'a t
val concat_map : 'a t -> f:('a -> 'b t) -> 'b t
val concat_mapi : 'a t -> f:(int -> 'a -> 'b t) -> 'b t
val concat : 'a t t -> 'a t
val concat_list : 'a t list -> 'a t
val append_list : 'a t -> 'a list -> unit
val append : 'a t -> 'a t -> unit
val to_sequence : 'a t -> 'a Sequence.t
val clear : 'a t -> unit
