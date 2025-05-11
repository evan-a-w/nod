open! Core

(* Monad.Make3 but also including some helpers for lists
   and maps *)
module Make3' (X : Monad.Basic3) = struct
  include Monad.Make3 (X)

  let all (l : ('res, 'state, _) X.t list) : ('res list, 'state, _) X.t =
    let open Let_syntax in
    let%map l =
      List.fold l ~init:(return []) ~f:(fun acc x ->
        let%bind acc = acc in
        let%map x = x in
        x :: acc)
    in
    List.rev l
  ;;

  let all_unit l =
    let open Let_syntax in
    List.fold l ~init:(return ()) ~f:(fun acc x ->
      let%bind () = acc in
      x)
  ;;

  let all_map
    (type a b)
    (module M : Map_intf.S
      with type Key.t = a
       and type Key.comparator_witness = b)
    m
    =
    let open Let_syntax in
    Map.fold m ~init:(return M.empty) ~f:(fun ~(key : a) ~data acc ->
      let%bind acc = acc in
      let%map data = data in
      Map.set acc ~key ~data)
  ;;

  let lift_opt x =
    let open Let_syntax in
    match x with
    | None -> return None
    | Some x ->
      let%map x = x in
      Some x
  ;;

  module Let_syntax = struct
    include Let_syntax

    let ( >> ) x y =
      let%bind _ = x in
      y
    ;;

    let ( << ) x y =
      let%bind x = x in
      y >> return x
    ;;
  end
end

module T = struct
  type ('res, 'state, 'unused) t = 'state -> 'res * 'state
end

include Make3' (struct
    include T

    let return x s = x, s
    let map = `Define_using_bind

    let bind t ~f s =
      let a, s = t s in
      f a s
    ;;
  end)

include T

type ('res, 'state) state = ('res, 'state, unit) t
type nonrec ('res, 'state) t = ('res, 'state, unit) t

let get s = s, s
let set s _ = (), s

let update f s =
  let s' = f s in
  (), s'
;;

module Result = struct
  module T = struct
    type ('res, 'state, 'err) t = 'state -> ('res * 'state, 'err) Result.t
  end

  include Make3' (struct
      include T

      let return x s = Result.return (x, s)
      let map = `Define_using_bind

      let bind t ~f s =
        let open Result.Let_syntax in
        let%bind a, s = t s in
        f a s
      ;;
    end)

  include T

  module Getters_and_setters = struct
    let get : ('state, 'state, 'err) t = fun s -> Ok (s, s)
    let set : 'state -> ('unit, 'state, 'err) t = fun s' _ -> Ok ((), s')
    let update f s = Ok ((), f s)
    let fail err : (_, 'state, 'err) t = fun _ -> Error err
  end

  module Let_syntax = struct
    include Let_syntax
    include Getters_and_setters
  end

  include Getters_and_setters

  let unlift t : (_, _) state =
    fun s ->
    match t s with
    | Ok (s, x) -> s, Ok x
    | Error _ as e -> s, e
  ;;

  let unlift' t : (_, _, _) t =
    fun s ->
    match t s with
    | Ok (s, x) -> Ok (s, Ok x)
    | Error _ as e -> Ok (s, e)
  ;;
end

let lift_result t : (_, _, _) Result.t =
  fun s ->
  match t s with
  | s, Ok x -> Ok (s, x)
  | _, (Error _ as e) -> e
;;
