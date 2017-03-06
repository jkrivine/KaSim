(******************************************************************************)
(*  _  __ * The Kappa Language                                                *)
(* | |/ / * Copyright 2010-2017 CNRS - Harvard Medical School - INRIA - IRIF  *)
(* | ' /  *********************************************************************)
(* | . \  * This file is distributed under the terms of the                   *)
(* |_|\_\ * GNU Lesser General Public License Version 3                       *)
(******************************************************************************)

(** Domain to navigate in the graph *)

type link = UnSpec | Free | Link of int * int
type cc
type t = cc (**type for domain points*)

type id

module ObsMap : sig
  (** Maps from patterns to something *)

  type 'a t

  val dummy : 'a -> 'a t

  val get : 'a t -> id -> 'a
  val set : 'a t -> id -> 'a -> unit

  val fold_lefti : (id -> 'a -> 'b -> 'a) -> 'a -> 'b t -> 'a
  val map : ('a -> 'b) -> 'a t -> 'b t
  val print :
    ?trailing:(Format.formatter -> unit) ->
    (Format.formatter -> unit) ->
    (id -> Format.formatter -> 'a -> unit) ->
    Format.formatter -> 'a t -> unit
end

module Env : sig
  type transition = private {
    next: Navigation.t;
    dst: id; (** id of cc and also address in the Env.domain map *)
    inj: Renaming.t; (** From dst To ("this" cc + extra edge) *)
  }

  type point

  val content: point -> cc

  val roots: point -> (int list * int) option (** (ids,ty) *)

  val deps: point -> Operator.DepSet.t

  val sons: point -> transition list

  type t

  val get : t -> id -> point

  val get_single_agent : int -> t -> (id * Operator.DepSet.t) option

  val get_elementary : t -> Navigation.step ->
    (id * point * Renaming.t) option

  val signatures : t -> Signature.s

  val new_obs_map : t -> (id -> 'a) -> 'a ObsMap.t

  val print : Format.formatter -> t -> unit

  val to_yojson : t -> Yojson.Basic.json

  val of_yojson : Yojson.Basic.json -> t

end

module PreEnv : sig
  type t

  type stat = { nodes: int; nav_steps: int }

  val sigs : t -> Signature.s

  val finalize : max_sharing:bool -> t -> Env.t * stat

  val of_env : Env.t -> t

end

(** {6 Create a connected component} *)
type work (** type of a PreEnv during a pattern construction *)

val empty_cc : Signature.s -> cc

val begin_new : PreEnv.t -> work
(** Starts creation *)

val new_node : work -> int -> (Agent.t*work)
(** [new_node wk node_type] *)

val new_link :
  work -> (Agent.t * int) -> (Agent.t * int) -> work
(** [new_link wk (node, site_id) (node', site_id')] *)

val new_free : work -> (Agent.t * int) -> work

val new_internal_state : work -> (Agent.t * int) -> int -> work
(** [new_link_type work (node,site) type] *)

val finish_new : ?origin:Operator.rev_dep -> work ->
  (PreEnv.t*Renaming.t*cc*id)

val minimal_env : Signature.s -> Contact_map.t -> PreEnv.t

(** {6 Use a connected component } *)

val compare_canonicals : id -> id -> int

val is_equal_canonicals : id -> id -> bool

val print_cc :
  ?sigs:Signature.s -> ?cc_id:id -> Format.formatter -> t -> unit

val print : ?domain:Env.t -> with_id:bool ->
  Format.formatter -> id -> unit
(** [print ~domain ?with_id:None form cc] *)

val id_to_yojson : id -> Yojson.Basic.json

val id_of_yojson : Yojson.Basic.json -> id

val reconstruction_navigation : t -> Navigation.t

val find_ty : cc -> int -> int (** Abstraction leak, please do not use *)

val automorphisms : t -> Renaming.t list

val embeddings_to_fully_specified : Env.t -> id -> cc -> Renaming.t list

val add_fully_specified_to_graph :
  Signature.s -> Edges.t -> cc -> Edges.t * Renaming.t

val fold:
  (pos:int -> agent_type:int -> 'a -> 'a) ->
  (pos:int -> site:int -> link * int -> 'a -> 'a) ->
  cc ->
  'a ->
  'a

module Set : SetMap.Set with type elt=id
