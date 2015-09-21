(** Compiled representation of a full Kappa model *)

type t

val init :
  Signature.s -> unit NamedDecls.t -> Alg_expr.t Location.annot NamedDecls.t ->
  (Operator.DepSet.t * Operator.DepSet.t * Operator.DepSet.t array) ->
  ((string Location.annot option * Ast.rule Location.annot) array *
     Primitives.elementary_rule NamedDecls.t * Alg_expr.t Mods.IntMap.t) ->
  Alg_expr.t Location.annot array -> Primitives.perturbation array -> t
(** [init sigs tokens algs dependencies (ast_rules,rules,unary_rules) obs perts]
 *)

val nb_tokens : t -> int
val nb_algs : t -> int
val nb_rules : t -> int
val nb_syntactic_rules : t -> int
val nb_perturbations : t -> int
val signatures : t -> Signature.s

val get_alg : t -> int -> Alg_expr.t
val get_perturbation : t -> int -> Primitives.perturbation
val get_rule : t -> int -> Primitives.elementary_rule
val map_observables : (Alg_expr.t -> 'a) -> t -> 'a array
val iteri_rules : (int -> Primitives.elementary_rule -> unit) -> t -> unit

val get_reverse_dependencies : t -> int -> Operator.DepSet.t
val get_always_outdated : t -> Operator.DepSet.t

val num_of_agent : string Location.annot -> t -> int
val num_of_rule : string Location.annot -> t -> int
val num_of_alg : string Location.annot -> t -> int
val num_of_token : string Location.annot -> t -> int

val print_ast_rule : ?env:t -> Format.formatter -> int -> unit
val print_agent : ?env:t -> Format.formatter -> int -> unit
val print_rule : ?env:t -> Format.formatter -> int -> unit
val print_alg : ?env:t -> Format.formatter -> int -> unit
val print_token : ?env:t -> Format.formatter -> int -> unit

val get_desc : string -> t -> Format.formatter
val close_desc : t -> unit

val print :
  (t -> Format.formatter -> Alg_expr.t -> unit) ->
  (t -> Format.formatter -> Primitives.elementary_rule -> unit) ->
  (t -> Format.formatter -> Primitives.perturbation -> unit) ->
  Format.formatter -> t -> unit
