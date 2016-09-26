(*
   * communication.ml
   * openkappa
   * Jérôme Feret & Ly Kim Quyen, projet Abstraction, INRIA Paris-Rocquencourt
   *
   * Creation: 2016, the 22th of February
   * Last modification: Time-stamp: <Sep 26 2016>
   *
   * Abstract domain to record live rules
   *
   * Copyright 2010,2011,2012,2013,2014,2015,2016 Institut National de Recherche
   * en Informatique et en Automatique.
   * All rights reserved.  This file is distributed
   * under the terms of the GNU Library General Public License *)

type path_defined_in =
  | LHS of (Ckappa_sig.c_rule_id * Cckappa_sig.enriched_rule)
  | RHS of (Ckappa_sig.c_rule_id * Cckappa_sig.enriched_rule)
  | Pattern

type event =
  | Dummy (* to avoid compilation warning *)
  | Check_rule of Ckappa_sig.c_rule_id
  | See_a_new_bond of
      ((Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name * Ckappa_sig.c_state) *
       (Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name * Ckappa_sig.c_state))
  | Modified_sites of (*a tuple that are modified*)
      ((Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name) *
      (Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name) *
      (Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name) *
      (Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name))

type step =
  {
    site_out: Ckappa_sig.c_site_name;
    site_in: Ckappa_sig.c_site_name;
    agent_type_in: Ckappa_sig.c_agent_name
  }

type path =
  {
    agent_id: Ckappa_sig.c_agent_id;
    relative_address: step list;
    site: Ckappa_sig.c_site_name;
  }

type path_in_pattern =
  {
    defined_in: path_defined_in ;
    path:path ;
  }

type output =
  | Cannot_exist
  | May_exist of path
  | Located of Ckappa_sig.c_agent_id

val get_defined_in: path_in_pattern -> path_defined_in
val get_agent_id: path_in_pattern -> Ckappa_sig.c_agent_id
val get_site: path_in_pattern -> Ckappa_sig.c_site_name
val get_relative_address: path_in_pattern -> step list

module type PathMap =
sig
  type 'a t
  val empty: 'a -> 'a t
  val add: path -> 'a -> 'a t -> 'a t
  val find: path -> 'a t -> 'a option
end

module PathMap:PathMap

type precondition

type 'a fold =
  Remanent_parameters_sig.parameters ->
  Exception.method_handler ->
  Ckappa_sig.c_agent_name ->
  Ckappa_sig.c_site_name ->
  Exception.method_handler *
  ((Remanent_parameters_sig.parameters ->
    Ckappa_sig.c_state ->
    Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name * Ckappa_sig.c_state ->
    Exception.method_handler * 'a ->
    Exception.method_handler * 'a) ->
   Exception.method_handler -> 'a ->
   Exception.method_handler * 'a) Usual_domains.flat_lattice

val dummy_precondition: precondition

val is_the_rule_applied_for_the_first_time:
  precondition -> Usual_domains.maybe_bool

val the_rule_is_applied_for_the_first_time:
  Remanent_parameters_sig.parameters ->
  Exception.method_handler ->
  precondition ->
  Exception.method_handler * precondition

val the_rule_is_not_applied_for_the_first_time:
  Remanent_parameters_sig.parameters ->
  Exception.method_handler ->
  precondition ->
  Exception.method_handler * precondition

(*val get_state_of_site:
  Exception.method_handler ->
  Analyzer_headers.global_dynamic_information ->
  precondition ->
  path ->
  Exception.method_handler * Analyzer_headers.global_dynamic_information * precondition *
    Ckappa_sig.c_state list Usual_domains.flat_lattice*)

type prefold = { fold: 'a. 'a fold}

(*fill in is_enable where it output the precondition, take the
  precondition, refine, the previous result, and output the new
  precondition*)

val refine_information_about_state_of_sites_in_precondition:
  precondition ->
  (Remanent_parameters_sig.parameters ->
   Exception.method_handler ->
   Analyzer_headers.global_dynamic_information ->
   path ->
   Ckappa_sig.c_state list Usual_domains.flat_lattice ->
   Exception.method_handler * Analyzer_headers.global_dynamic_information *
   Ckappa_sig.c_state list Usual_domains.flat_lattice) ->
  precondition

val get_potential_partner:
  precondition ->
  (Exception.method_handler -> Ckappa_sig.c_agent_name -> Ckappa_sig.c_site_name -> Ckappa_sig.c_state ->
   Exception.method_handler * precondition *
   (((Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name * Ckappa_sig.c_state) Usual_domains.flat_lattice)))

val fold_over_potential_partners:
  Remanent_parameters_sig.parameters ->
  Exception.method_handler ->
  precondition ->
  Ckappa_sig.c_agent_name ->
  Ckappa_sig.c_site_name ->
  (Remanent_parameters_sig.parameters ->
   Ckappa_sig.c_state ->
   Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name * Ckappa_sig.c_state ->
   Exception.method_handler * 'a -> Exception.method_handler * 'a) ->
  'a ->
  Exception.method_handler * precondition * 'a Usual_domains.top_or_not

val overwrite_potential_partners_map:
  Remanent_parameters_sig.parameters ->
  Exception.method_handler ->
  precondition ->
  (Exception.method_handler -> Ckappa_sig.c_agent_name ->
   Ckappa_sig.c_site_name ->
   Ckappa_sig.c_state ->
   Exception.method_handler *
   (Ckappa_sig.c_agent_name * Ckappa_sig.c_site_name * Ckappa_sig.c_state) Usual_domains.flat_lattice)
  -> prefold ->
  Exception.method_handler * precondition

val get_state_of_site:
  Exception.method_handler ->
  precondition ->
  Analyzer_headers.global_static_information ->
  Analyzer_headers.global_dynamic_information ->
  path_in_pattern ->
  Exception.method_handler * Analyzer_headers.global_dynamic_information *
  precondition *
  Ckappa_sig.c_state list Usual_domains.flat_lattice

val follow_path_inside_cc:
  Remanent_parameters_sig.parameters ->
  Exception.method_handler ->
  Cckappa_sig.kappa_handler ->
  Cckappa_sig.mixture ->
  path -> Exception.method_handler * output

val get_state_of_site_in_precondition:
  ('static -> Analyzer_headers.global_static_information) ->
  ('dynamic -> Analyzer_headers.global_dynamic_information) ->
  (Analyzer_headers.global_dynamic_information -> 'dynamic -> 'c) ->
  Exception.method_handler ->
  'static -> 'dynamic ->
  (Ckappa_sig.c_rule_id * Cckappa_sig.enriched_rule) ->
  Ckappa_sig.c_agent_id ->
  Ckappa_sig.c_site_name ->
  precondition ->
  Exception.method_handler * 'c * precondition *
  Ckappa_sig.c_state list

val get_state_of_site_in_postcondition:
  ('static -> Analyzer_headers.global_static_information) ->
  ('dynamic -> Analyzer_headers.global_dynamic_information) ->
  (Analyzer_headers.global_dynamic_information -> 'dynamic -> 'b) ->
  Exception.method_handler ->
  'static -> 'dynamic ->
  (Ckappa_sig.c_rule_id * Cckappa_sig.enriched_rule) ->
  Ckappa_sig.c_agent_id ->
  Ckappa_sig.c_site_name ->
  precondition ->
  Exception.method_handler * 'b * precondition *
  Ckappa_sig.c_state list
