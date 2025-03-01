type 'a t [@@deriving sexp]

val create : ?capacity:int -> unit -> 'a t
val length : 'a t -> int
val get : 'a t -> int -> 'a
val set : 'a t -> int -> 'a -> unit
val iter : 'a t -> f:('a -> unit) -> unit
val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
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
