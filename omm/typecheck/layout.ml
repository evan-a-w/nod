open! Core
open! Import

type struct_def =
  { pos : Pos.t
  ; fields : (string * Ty.t) list
  }

type t =
  { structs : struct_def String.Map.t
  ; mutable size_cache : int String.Table.t
  ; mutable align_cache : int String.Table.t
  }

let create structs =
  { structs
  ; size_cache = String.Table.create ()
  ; align_cache = String.Table.create ()
  }
;;

let align_up ~align n =
  if align <= 0 then n else ((n + align - 1) / align) * align
;;

let rec align_of_ty t layout ~visiting =
  match t with
  | Ty.Prim _ -> Ok 8
  | Ty.Unit -> Ok 1
  | Ty.Ptr _ -> Ok 8
  | Ty.Struct name ->
    (match Hashtbl.find layout.align_cache name with
     | Some a -> Ok a
     | None ->
       if Set.mem visiting name
       then Error [%string "recursive struct layout for %{name}"]
       else (
         match Map.find layout.structs name with
         | None -> Error [%string "unknown struct %{name}"]
         | Some def ->
           let visiting = Set.add visiting name in
           let rec max_align = function
             | [] -> Ok 1
             | (_, ty) :: rest ->
               Result.bind (align_of_ty ty layout ~visiting) ~f:(fun a ->
                 Result.map (max_align rest) ~f:(fun rest_max -> Int.max a rest_max))
           in
           let res = max_align def.fields in
           (match res with
            | Ok a ->
              Hashtbl.set layout.align_cache ~key:name ~data:a;
              Ok a
            | Error _ as e -> e)))
;;

let rec size_of_ty t layout ~visiting =
  match t with
  | Ty.Prim _ -> Ok 8
  | Ty.Unit -> Ok 0
  | Ty.Ptr _ -> Ok 8
  | Ty.Struct name ->
    (match Hashtbl.find layout.size_cache name with
     | Some s -> Ok s
     | None ->
       if Set.mem visiting name
       then Error [%string "recursive struct layout for %{name}"]
       else (
         match Map.find layout.structs name with
         | None -> Error [%string "unknown struct %{name}"]
         | Some def ->
           let open Result.Let_syntax in
           let%bind struct_align = align_of_ty (Ty.Struct name) layout ~visiting in
           let visiting = Set.add visiting name in
           let rec loop offset = function
             | [] -> Ok (align_up ~align:struct_align offset)
             | (_, field_ty) :: rest ->
               let%bind field_align = align_of_ty field_ty layout ~visiting in
               let offset = align_up ~align:field_align offset in
               let%bind field_size = size_of_ty field_ty layout ~visiting in
               loop (offset + field_size) rest
           in
           let res = loop 0 def.fields in
           (match res with
            | Ok s ->
              Hashtbl.set layout.size_cache ~key:name ~data:s;
              Ok s
            | Error _ as e -> e)))
;;

let offset_of_field struct_name ~field layout =
  match Map.find layout.structs struct_name with
  | None -> Error [%string "unknown struct %{struct_name}"]
  | Some def ->
    let visiting = String.Set.empty in
    let open Result.Let_syntax in
    let rec loop offset = function
      | [] -> Error [%string "unknown field %{field} on %{struct_name}"]
      | (name, field_ty) :: rest ->
        let%bind field_align = align_of_ty field_ty layout ~visiting in
        let offset = align_up ~align:field_align offset in
        if String.equal name field
        then Ok offset
        else (
          let%bind field_size = size_of_ty field_ty layout ~visiting in
          loop (offset + field_size) rest)
    in
    loop 0 def.fields
;;

let size_of t layout = size_of_ty t layout ~visiting:String.Set.empty
let align_of t layout = align_of_ty t layout ~visiting:String.Set.empty
