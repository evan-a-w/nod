open! Core
open! Import

type t =
  | Duplicate_name of
      { kind : string
      ; name : string
      ; pos : Pos.t
      }
  | Unknown_struct of { name : string; pos : Pos.t }
  | Unknown_field of
      { struct_name : string
      ; field : string
      ; pos : Pos.t
      }
  | Unknown_variable of { name : string; pos : Pos.t }
  | Unknown_function of { name : string; pos : Pos.t }
  | Expected_type of
      { expected : Ty.t
      ; got : Ty.t
      ; pos : Pos.t
      ; context : string
      }
  | Expected_i64_condition of { got : Ty.t; pos : Pos.t }
  | Expected_pointer of { got : Ty.t; pos : Pos.t }
  | Expected_struct of { got : Ty.t; pos : Pos.t }
  | Expected_struct_ptr of { got : Ty.t; pos : Pos.t }
  | Wrong_arity of
      { name : string
      ; expected : int
      ; got : int
      ; pos : Pos.t
      }
  | Duplicate_field_init of
      { struct_name : string
      ; field : string
      ; pos : Pos.t
      }
  | Missing_field_init of
      { struct_name : string
      ; field : string
      ; pos : Pos.t
      }
  | Extra_field_init of
      { struct_name : string
      ; field : string
      ; pos : Pos.t
      }
  | Invalid_intrinsic of { msg : string; pos : Pos.t }
  | Missing_return of { fn_name : string; pos : Pos.t }
  | Layout_error of { msg : string; pos : Pos.t }

let to_string = function
  | Duplicate_name { kind; name; pos } ->
    [%string "Error: duplicate %{kind} '%{name}' at %{Pos.to_string pos}\n"]
  | Unknown_struct { name; pos } ->
    [%string "Error: unknown struct '%{name}' at %{Pos.to_string pos}\n"]
  | Unknown_field { struct_name; field; pos } ->
    [%string
      "Error: unknown field '%{field}' on struct '%{struct_name}' at %{Pos.to_string pos}\n"]
  | Unknown_variable { name; pos } ->
    [%string "Error: unknown variable '%{name}' at %{Pos.to_string pos}\n"]
  | Unknown_function { name; pos } ->
    [%string "Error: unknown function '%{name}' at %{Pos.to_string pos}\n"]
  | Expected_type { expected; got; pos; context } ->
    [%string
      "Error: type mismatch (%{context}) at %{Pos.to_string pos}: expected %{Ty.to_string expected} but got %{Ty.to_string got}\n"]
  | Expected_i64_condition { got; pos } ->
    [%string
      "Error: expected i64 condition at %{Pos.to_string pos} but got %{Ty.to_string got}\n"]
  | Expected_pointer { got; pos } ->
    [%string
      "Error: expected pointer at %{Pos.to_string pos} but got %{Ty.to_string got}\n"]
  | Expected_struct { got; pos } ->
    [%string
      "Error: expected struct at %{Pos.to_string pos} but got %{Ty.to_string got}\n"]
  | Expected_struct_ptr { got; pos } ->
    [%string
      "Error: expected struct pointer at %{Pos.to_string pos} but got %{Ty.to_string got}\n"]
  | Wrong_arity { name; expected; got; pos } ->
    [%string
      "Error: wrong arity for '%{name}' at %{Pos.to_string pos}: expected %{Int.to_string expected} args but got %{Int.to_string got}\n"]
  | Duplicate_field_init { struct_name; field; pos } ->
    [%string
      "Error: duplicate initializer for field '%{field}' of '%{struct_name}' at %{Pos.to_string pos}\n"]
  | Missing_field_init { struct_name; field; pos } ->
    [%string
      "Error: missing initializer for field '%{field}' of '%{struct_name}' at %{Pos.to_string pos}\n"]
  | Extra_field_init { struct_name; field; pos } ->
    [%string
      "Error: extra initializer for field '%{field}' of '%{struct_name}' at %{Pos.to_string pos}\n"]
  | Invalid_intrinsic { msg; pos } ->
    [%string "Error: invalid intrinsic at %{Pos.to_string pos}: %{msg}\n"]
  | Missing_return { fn_name; pos } ->
    [%string "Error: missing return in '%{fn_name}' at %{Pos.to_string pos}\n"]
  | Layout_error { msg; pos } ->
    [%string "Error: layout error at %{Pos.to_string pos}: %{msg}\n"]
;;

