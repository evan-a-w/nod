open! Core
open! Nod_core

type int64

module Atom : sig
  type _ t
end

val int_lit : int -> int64 Atom.t
val var : 'a -> 'b
val global : 'a -> 'b
val mov : 'a -> dest:'b -> 'c
val add : 'a -> 'b -> dest:'c -> 'd
val sub : 'a -> 'b -> dest:'c -> 'd
val mul : 'a -> 'b -> dest:'c -> 'd
val div : 'a -> 'b -> dest:'c -> 'd
val mod_ : 'a -> 'b -> dest:'c -> 'd
val and_ : 'a -> 'b -> dest:'c -> 'd
val or_ : 'a -> 'b -> dest:'c -> 'd
val fadd : 'a -> 'b -> dest:'c -> 'd
val fsub : 'a -> 'b -> dest:'c -> 'd
val fmul : 'a -> 'b -> dest:'c -> 'd
val fdiv : 'a -> 'b -> dest:'c -> 'd
val load : 'a -> dest:'b -> 'c
val store : 'a -> 'b -> 'c
val load_addr : 'a -> 'b -> dest:'c -> 'd
val store_addr : 'a -> 'b -> 'c -> 'd
val alloca : 'a -> dest:'b -> 'c
val cast : 'a -> dest:'b -> 'c
val call : 'a -> 'b -> results:'c -> 'd
val call0 : 'a -> 'b -> 'c
val call1 : 'a -> 'b -> dest:'c -> 'd
val call2 : 'a -> 'b -> 'b -> dest:'c -> 'd
val call3 : 'a -> 'b -> 'b -> 'b -> dest:'c -> 'd
val call4 : 'a -> 'b -> 'b -> 'b -> 'b -> dest:'c -> 'd
val call5 : 'a -> 'b -> 'b -> 'b -> 'b -> 'b -> dest:'c -> 'd
val load_field : 'a -> 'b -> 'c -> dest:'d -> 'e
val store_field : 'a -> 'b -> 'c -> 'd -> 'e
val memcpy : 'a -> 'b -> 'c -> 'd
val atomic_load : 'a -> 'b -> dest:'c -> 'd
val atomic_store : 'a -> 'b -> 'c -> 'd
val atomic_rmw : 'a -> 'b -> 'c -> 'd -> dest:'e -> 'f
val atomic_cmpxchg : 'a -> 'b -> 'c -> 'd -> 'e -> dest:'f -> success:'g -> 'h
