(**
  * export_to_KaSim.ml
  * openkappa
  * Jérôme Feret, projet Abstraction/Antique, INRIA Paris-Rocquencourt
  *
  * Creation: Aug 23 2016
  * Last modification: Time-stamp: <Nov 27 2016>
  * *
  *
  * Copyright 2010,2011 Institut National de Recherche en Informatique et
  * en Automatique.  All rights reserved.  This file is distributed
  * under the terms of the GNU Library General Public License *)

module type Type =
sig
  type state

  val init:
    ?compil:(string Location.annot * Ast.port list, Ast.mixture, string, Ast.rule) Ast.compil ->
    unit -> state

  val get_contact_map:
    ?accuracy_level:Remanent_state.accuracy_level ->
    state -> state * Yojson.Basic.json

  val get_influence_map:
    ?accuracy_level:Remanent_state.accuracy_level ->
    state -> state * Yojson.Basic.json

  val get_dead_rules: state -> state * Yojson.Basic.json

  val get_constraints_list: state -> state * Yojson.Basic.json

  val to_json: state -> Yojson.Basic.json

end

module Export =
functor (A:Analyzer.Analyzer) ->
  struct

    include Export.Export(A)

    let init ?compil () =
      init ?compil ~called_from:Remanent_parameters_sig.Server ()

    let get_contact_map
        ?accuracy_level:(accuracy_level=Remanent_state.Low) state =
      let state, cm = get_contact_map ~accuracy_level state in
      state, Remanent_state.contact_map_to_json (accuracy_level,cm)

    let get_influence_map
        ?accuracy_level:(accuracy_level=Remanent_state.Low) state =
      let state, influence_map = get_influence_map ~accuracy_level state in
      state, Remanent_state.influence_map_to_json (accuracy_level,influence_map)

    let get_dead_rules state =
      let state, rules = get_dead_rules state in
      state, Remanent_state.dead_rules_to_json rules

    let get_constraints_list state =
      get_constraints_list_to_json state

    let to_json = Remanent_state.to_json

  end
