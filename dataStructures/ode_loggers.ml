(**
  * graph_loggers.ml
  *
  * a module for KaSim
  * Jérôme Feret, projet Antique, INRIA Paris
  *
  * KaSim
  * Jean Krivine, Université Paris-Diderot, CNRS
  *
  * Creation: 22/07/2016
  * Last modification: Time-stamp: <Jul 25 2016>
  * *
  *
  *
  * Copyright 2016  Institut National de Recherche en Informatique et
  * en Automatique.  All rights reserved.  This file is distributed
  * under the terms of the GNU Library General Public License *)


let string_of_variable_octave var =
  match var with
  | Ode_loggers_sig.Rate int
  | Ode_loggers_sig.Rated int
  | Ode_loggers_sig.Rateun int
  | Ode_loggers_sig.Rateund int
  | Ode_loggers_sig.Expr int
  | Ode_loggers_sig.Obs int
  | Ode_loggers_sig.Init int
  | Ode_loggers_sig.Initbis int
  | Ode_loggers_sig.Concentration int
  | Ode_loggers_sig.Deriv int ->
    Printf.sprintf "%s(%i)"
      (Ode_loggers_sig.string_of_array_name var) int
  | Ode_loggers_sig.Jacobian_rate (int1,int2)
  | Ode_loggers_sig.Jacobian_rated (int1,int2)
  | Ode_loggers_sig.Jacobian_rateun (int1,int2)
  | Ode_loggers_sig.Jacobian_rateund (int1,int2)
  | Ode_loggers_sig.Jacobian (int1,int2)
  | Ode_loggers_sig.Jacobian_var (int1,int2) ->
    Printf.sprintf "%s(%i,%i)"
      (Ode_loggers_sig.string_of_array_name var)  int1 int2
  | Ode_loggers_sig.Tinit
  | Ode_loggers_sig.Tend
  | Ode_loggers_sig.InitialStep
  | Ode_loggers_sig.Period_t_points
  | Ode_loggers_sig.N_ode_var
  | Ode_loggers_sig.N_var
  | Ode_loggers_sig.N_obs
  | Ode_loggers_sig.N_rules
  | Ode_loggers_sig.N_rows
  | Ode_loggers_sig.Tmp
  | Ode_loggers_sig.Current_time
  | Ode_loggers_sig.Time_scale_factor ->
    (Ode_loggers_sig.string_of_array_name var)

type side = LHS | RHS

let string_of_variable_mathematica ~side var =
  let side_ext =
    match side
    with
    | LHS -> "_"
    | RHS -> ""
  in
  match var with
  | Ode_loggers_sig.Rate int
  | Ode_loggers_sig.Rated int
  | Ode_loggers_sig.Rateun int
  | Ode_loggers_sig.Rateund int
  | Ode_loggers_sig.Obs int
  | Ode_loggers_sig.Concentration int
  | Ode_loggers_sig.Deriv int ->
    Printf.sprintf "%s%i[t%s]"
      (Ode_loggers_sig.string_of_array_name var) int side_ext
  | Ode_loggers_sig.Expr int ->
    Printf.sprintf "%s%i[t%s]"
      (Ode_loggers_sig.string_of_array_name var) int side_ext
  | Ode_loggers_sig.Init int
  | Ode_loggers_sig.Initbis int ->
    Printf.sprintf "%s%i"
      (Ode_loggers_sig.string_of_array_name var) int
  | Ode_loggers_sig.Jacobian_rate _
  | Ode_loggers_sig.Jacobian_rated _
  | Ode_loggers_sig.Jacobian_rateun _
  | Ode_loggers_sig.Jacobian_rateund _
  | Ode_loggers_sig.Jacobian _
  | Ode_loggers_sig.Jacobian_var _ -> ""
  | Ode_loggers_sig.Tinit
  | Ode_loggers_sig.Tend
  | Ode_loggers_sig.InitialStep
  | Ode_loggers_sig.Period_t_points
  | Ode_loggers_sig.N_ode_var
  | Ode_loggers_sig.N_var
  | Ode_loggers_sig.N_obs
  | Ode_loggers_sig.N_rules
  | Ode_loggers_sig.N_rows
  | Ode_loggers_sig.Tmp
  | Ode_loggers_sig.Current_time
  | Ode_loggers_sig.Time_scale_factor ->
    (Ode_loggers_sig.string_of_array_name var)

let string_of_variable_maple var =
  match var with
  | Ode_loggers_sig.Rate int
  | Ode_loggers_sig.Rated int
  | Ode_loggers_sig.Rateun int
  | Ode_loggers_sig.Rateund int
  | Ode_loggers_sig.Obs int
  | Ode_loggers_sig.Concentration int
  | Ode_loggers_sig.Deriv int
  | Ode_loggers_sig.Expr int ->
    Printf.sprintf "%s%i(t)"
      (Ode_loggers_sig.string_of_array_name var) int
  | Ode_loggers_sig.Init int
  | Ode_loggers_sig.Initbis int ->
    Printf.sprintf "%s%i"
      (Ode_loggers_sig.string_of_array_name var) int
  | Ode_loggers_sig.Jacobian_rate _
  | Ode_loggers_sig.Jacobian_rated _
  | Ode_loggers_sig.Jacobian_rateun _
  | Ode_loggers_sig.Jacobian_rateund _
  | Ode_loggers_sig.Jacobian _
  | Ode_loggers_sig.Jacobian_var _ -> ""
  | Ode_loggers_sig.Tinit
  | Ode_loggers_sig.Tend
  | Ode_loggers_sig.InitialStep
  | Ode_loggers_sig.Period_t_points
  | Ode_loggers_sig.N_ode_var
  | Ode_loggers_sig.N_var
  | Ode_loggers_sig.N_obs
  | Ode_loggers_sig.N_rules
  | Ode_loggers_sig.N_rows
  | Ode_loggers_sig.Tmp
  | Ode_loggers_sig.Current_time
  | Ode_loggers_sig.Time_scale_factor ->
    (Ode_loggers_sig.string_of_array_name var)


let string_of_variable ~side loggers variable =
  match
    Loggers.get_encoding_format loggers
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    string_of_variable_octave variable
  | Loggers.Mathematica ->
    string_of_variable_mathematica ~side variable
  | Loggers.Maple ->
    string_of_variable_maple variable
  | Loggers.Matrix
  | Loggers.HTML_Graph
  | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.DOT
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS
  | Loggers.SBML
  | Loggers.Json -> ""

let variable_of_derived_variable var id =
  match var with
  | Ode_loggers_sig.Rate int -> Ode_loggers_sig.Jacobian_rate (int,id)
  | Ode_loggers_sig.Rated int -> Ode_loggers_sig.Jacobian_rated (int,id)
  | Ode_loggers_sig.Rateun int -> Ode_loggers_sig.Jacobian_rateun (int,id)
  | Ode_loggers_sig.Rateund int -> Ode_loggers_sig.Jacobian_rateund (int,id)
  | Ode_loggers_sig.Expr int -> Ode_loggers_sig.Jacobian_var (int, id)
  | Ode_loggers_sig.Concentration int -> Ode_loggers_sig.Jacobian (int, id)
  | Ode_loggers_sig.Obs _ -> assert false
  | Ode_loggers_sig.Init _ -> assert false
  | Ode_loggers_sig.Initbis _ -> assert false
  | Ode_loggers_sig.Deriv _ -> assert false
  | Ode_loggers_sig.Jacobian_rate _ -> assert false
  | Ode_loggers_sig.Jacobian_rated _ -> assert false
  | Ode_loggers_sig.Jacobian_rateun _ -> assert false
  | Ode_loggers_sig.Jacobian_rateund _ -> assert false
  | Ode_loggers_sig.Jacobian _ -> assert false
  | Ode_loggers_sig.Jacobian_var _ -> assert false
  | Ode_loggers_sig.Tinit -> assert false
  | Ode_loggers_sig.Tend -> assert false
  | Ode_loggers_sig.InitialStep -> assert false
  | Ode_loggers_sig.Period_t_points -> assert false
  | Ode_loggers_sig.N_ode_var -> assert false
  | Ode_loggers_sig.N_var -> assert false
  | Ode_loggers_sig.N_obs -> assert false
  | Ode_loggers_sig.N_rules -> assert false
  | Ode_loggers_sig.N_rows -> assert false
  | Ode_loggers_sig.Tmp -> assert false
  | Ode_loggers_sig.Current_time -> assert false
  | Ode_loggers_sig.Time_scale_factor -> assert false

type correct = Div of int | Mul of int | Nil

type options =
  | Comment of string

let shall_I_do_it format filter_in filter_out =
  let b1 =
    match
      filter_in
    with
    | None -> true
    | Some l -> List.mem format l
  in
  b1 && (not (List.mem format filter_out))


let print_list logger l =
  List.iter
    (fun s ->
       let () = Loggers.fprintf logger "%s" s in Loggers.print_newline logger)
    l

let print_ode_preamble
    logger
    command_line
    ~may_be_not_time_homogeneous
    ~count
    ~rate_convention
    ?filter_in:(filter_in=None) ?filter_out:(filter_out=[])
    ()
  =
  let format = Loggers.get_encoding_format logger in
  if shall_I_do_it format filter_in filter_out
  then
    match
      format
    with
    | Loggers.Matlab  | Loggers.Octave ->
      begin
        let () = command_line logger in
        let () = print_list logger
            [
              "%% THINGS THAT ARE KNOWN FROM KAPPA FILE AND KaSim OPTIONS:";
              "%% ";
              "%% init - the initial abundances of each species and token";
              "%% tinit - the initial simulation time (likely 0)";
              "%% tend - the final simulation time ";
              "%% initialstep - initial time step at the beginning of numerical integration";
              "%% "^(Ode_loggers_sig.string_of_array_name Ode_loggers_sig.Period_t_points)^" - the time period between points to return";
              "%%" ;
              "%% "^
              (match
                 count
               with
               | Ode_args.Embeddings -> "variables (init(i),y(i)) denote numbers of embeddings "
               | Ode_args.Occurrences -> "variables (init(i),y(i)) denote numbers occurrences");
              "%% "^
              (match
                 rate_convention
               with
               | Remanent_parameters_sig.Common ->
                 "rule rates are corrected by automorphisms of the lhs that induce an automorphism in the rhs as weel; and by the automorphisms of the rhs that induce an automorphism in the lhs as well "
               | Remanent_parameters_sig.Biochemist ->
                 "rule rates are corrected by the number of automorphisms that induce an automorphism in the rhs as well"
               | Remanent_parameters_sig.Divide_by_nbr_of_autos_in_lhs ->
                 "rule rates are corrected by the number of automorphisms in the lhs of rules"
               | Remanent_parameters_sig.No_correction ->
                 "no correcion is applied on rule rates")]
            in
        let () = Loggers.print_newline logger in
        ()
      end
    | Loggers.SBML ->
      begin
        let () = print_list logger
            [
              "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";] in
        let () = command_line logger in
        let () = print_list logger
            ([
              "<sbml xmlns=\"http://www.sbml.org/sbml/level2/version4\" xmlns:celldesigner=\"http://www.sbml.org/2001/ns/celldesigner\" level=\"2\" version=\"4\">";
              "<model name=\"KaDe output:\">";
              "<!--";
              "THINGS THAT ARE KNOWN FROM KAPPA FILE AND KaSim OPTIONS:";
              "";
              "init - the initial abundances of each species and token";
              "tinit - the initial simulation time (likely 0)";
              "tend - the final simulation time ";
              "initialstep - initial time step at the beginning of numerical integration";
              (Ode_loggers_sig.string_of_array_name Ode_loggers_sig.Period_t_points)^" - the time period between points to return";
              "" ;
              ""^
              (match
                 count
               with
               | Ode_args.Embeddings -> "variables denote number of embeddings "
               | Ode_args.Occurrences -> "variables denote numbers occurrences");
              ""^
              (match
                 rate_convention
               with
               | Remanent_parameters_sig.Common ->
                 "rule rates are corrected by automorphisms of the lhs that induce an automorphism in the rhs as weel; and by the automorphisms of the rhs that induce an automorphism in the lhs as well "
               | Remanent_parameters_sig.Biochemist ->
                 "rule rates are corrected by the number of automorphisms that induce an automorphism in the rhs as well"
               | Remanent_parameters_sig.Divide_by_nbr_of_autos_in_lhs ->
                 "rule rates are corrected by the number of automorphisms in the lhs of rules"
               | Remanent_parameters_sig.No_correction ->
                 "no correcion is applied on rule rates");
              "-->";
              "<listOfUnitDefinitions>";
              "<unitDefinition metaid=\"substance\" id=\"substance\" name=\"substance\">";
              "<listOfUnits>";
              "<unit metaid=\""^(Sbml_backend.meta_id_of_logger logger)^"\"  kind=\"mole\"/>";
              "</listOfUnits>";
              "</unitDefinition>";
              "<unitDefinition metaid=\"volume\" id=\"volume\" name=\"volume\">";
              "<listOfUnits>";
              "<unit metaid=\""^(Sbml_backend.meta_id_of_logger logger)^"\" kind=\"litre\"/>";
              "</listOfUnits>";
              "</unitDefinition>";]@(if may_be_not_time_homogeneous then
                                       [
              "<unitDefinition metaid=\"time\" id=\"time\" name=\"time\">";
              "<listOfUnits>";
              "<unit metaid=\""^(Sbml_backend.meta_id_of_logger logger)^"\" kind=\"second\"/>";
              "</listOfUnits>";
              "</unitDefinition>";
              "<unitDefinition metaid=\"time_per_substance\" id=\"time_per_substance\" name=\"time_per_substance\">";
              "<listOfUnits>";
              "<unit metaid=\""^(Sbml_backend.meta_id_of_logger logger)^"\" kind=\"second\"/>";
              "<unit metaid=\""^(Sbml_backend.meta_id_of_logger logger)^"\" kind=\"mole\" exponent=\"-1\"/>";
              "</listOfUnits>";
              "</unitDefinition>";] else [])@[
              "</listOfUnitDefinitions>";
              "<listOfCompartments>";
              "<compartment metaid=\"default\" id=\"default\" size=\"1\" units=\"volume\"/>";
              "</listOfCompartments>";

              ])
        in ()
      end
    | Loggers.Maple ->
      begin
        let () = command_line logger in
        let () = print_list logger
            [
              "## THINGS THAT ARE KNOWN FROM KAPPA FILE AND KaSim OPTIONS:";
              "## ";
              "## init - the initial abundances of each species and token";
              "## tinit - the initial simulation time (likely 0)";
              "## tend - the final simulation time ";
              "## initialstep - initial time step at the beginning of numerical integration";
              "## "^(Ode_loggers_sig.string_of_array_name Ode_loggers_sig.Period_t_points)^" - the time period between points to return";
              "##" ;
              "## "^
              (match
                 count
               with
               | Ode_args.Embeddings -> "variables (initi(t),yi(t)) denote numbers of embeddings "
               | Ode_args.Occurrences -> "variables (initi(t)),yi(t)) denote numbers occurrences");
              "## "^
              (match
                 rate_convention
               with
               | Remanent_parameters_sig.Common ->
                 "rule rates are corrected by automorphisms of the lhs that induce an automorphism in the rhs as weel; and by the automorphisms of the rhs that induce an automorphism in the lhs as well "
               | Remanent_parameters_sig.Biochemist ->
                 "rule rates are corrected by the number of automorphisms that induce an automorphism in the rhs as well"
               | Remanent_parameters_sig.Divide_by_nbr_of_autos_in_lhs ->
                 "rule rates are corrected by the number of automorphisms in the lhs of rules"
               | Remanent_parameters_sig.No_correction ->
                 "no correcion is applied on rule rates")]
        in
        let () = Loggers.print_newline logger in
        ()
      end
    | Loggers.Mathematica ->
      begin
        let () = command_line logger in
        let () = print_list logger
            [
              "(* THINGS THAT ARE KNOWN FROM KAPPA FILE AND KaSim OPTIONS: *)";
              "(* *) ";
              "(* init - the initial abundances of each species and token *)";
              "(* tinit - the initial simulation time (likely 0) *)";
              "(* tend - the final simulation time *)";
              "(* initialstep - initial time step at the beginning of numerical integration *)";
              "(* "^(Ode_loggers_sig.string_of_array_name
                       Ode_loggers_sig.Period_t_points)^" - the time period between points to return *)";
              "(* *)" ;
              "(* "^
              (match
                 count
               with
               | Ode_args.Embeddings -> "variables (initi[t],yi[t]) denote numbers of embeddings *)"
               | Ode_args.Occurrences -> "variables (initi[t]),yi[t]) denote numbers occurrences *)");
              "(* "^
              (match
                 rate_convention
               with
               | Remanent_parameters_sig.Common ->
                 "rule rates are corrected by automorphisms of the lhs that induce an automorphism in the rhs as weel; and by the automorphisms of the rhs that induce an automorphism in the lhs as well *)"
               | Remanent_parameters_sig.Biochemist ->
                 "rule rates are corrected by the number of automorphisms that induce an automorphism in the rhs as well *)"
               | Remanent_parameters_sig.Divide_by_nbr_of_autos_in_lhs ->
                 "rule rates are corrected by the number of automorphisms in the lhs of rules *)"
               | Remanent_parameters_sig.No_correction ->
                 "no correcion is applied on rule rates*)")]
        in
        let () = Loggers.print_newline logger in
        ()
      end
    | Loggers.Json
    | Loggers.DOT
    | Loggers.Matrix
    | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular | Loggers.TXT
    | Loggers.TXT_Tabular | Loggers.XLS -> ()

let declare_global logger string =
  let format = Loggers.get_encoding_format logger in
  let string = Ode_loggers_sig.string_of_array_name string in
  match
    format
  with
  | Loggers.Matlab  | Loggers.Octave ->
    begin
      let () = Loggers.fprintf logger "global %s" string in
      let () = Loggers.print_newline logger in
      ()
    end
  | Loggers.SBML | Loggers.Maple | Loggers.Mathematica -> ()
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix
  | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let affect_symbol logger =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab  | Loggers.Octave | Loggers.Mathematica -> "="
  | Loggers.Maple -> ":="
  | Loggers.Json
  | Loggers.SBML
  | Loggers.Matrix  | Loggers.DOT | Loggers.HTML_Graph | Loggers.HTML
  | Loggers.HTML_Tabular | Loggers.TXT
  | Loggers.TXT_Tabular | Loggers.XLS -> ""


let repeat f last =
  let rec aux f k n =
    if k>n then ()
    else
    if k=1 then
      let () = f false k in
      aux f (k+1) n
    else
      let () = f true k in
      aux f (k+1) n
  in aux f 1 last

let of_t ~side logger s =
  let format = Loggers.get_encoding_format logger in
  let ext =
    match side with
    | LHS -> "_"
    | RHS -> ""
  in
  match format with
  | Loggers.Maple -> Format.sprintf "(%s)" s
  | Loggers.Mathematica -> Format.sprintf "[%s%s]" s ext
  | Loggers.Matlab  | Loggers.Octave
  | Loggers.SBML
  | Loggers.Matrix  | Loggers.DOT | Loggers.HTML_Graph | Loggers.HTML
  | Loggers.HTML_Tabular | Loggers.TXT
  | Loggers.TXT_Tabular | Loggers.XLS
  | Loggers.Json -> ""



let instruction_sep logger =
  let format = Loggers.get_encoding_format logger in
  match format with
  | Loggers.Maple -> ":"
  | Loggers.Mathematica -> ";"
  | Loggers.Matlab  | Loggers.Octave -> ";"
  | Loggers.SBML
  | Loggers.Matrix  | Loggers.DOT | Loggers.HTML_Graph | Loggers.HTML
  | Loggers.HTML_Tabular | Loggers.TXT
  | Loggers.TXT_Tabular | Loggers.XLS | Loggers.Json -> ""

let initialize ~nodevar logger variable =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab  | Loggers.Octave ->
    begin
      let () =
        match variable with
        | Ode_loggers_sig.Rate _
        | Ode_loggers_sig.Rated _
        | Ode_loggers_sig.Rateun _
        | Ode_loggers_sig.Rateund _ ->
          Loggers.fprintf logger "%s=zeros(nrules,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Jacobian_rate (_,_)
        | Ode_loggers_sig.Jacobian_rateun (_,_)
        | Ode_loggers_sig.Jacobian_rated (_,_)
        | Ode_loggers_sig.Jacobian_rateund (_,_) ->
          Loggers.fprintf logger "%s=zeros(nrules,nodevar)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Expr _ ->
          Loggers.fprintf logger "%s=zeros(nvar,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Init _ ->
          Loggers.fprintf logger "%s=sparse(nodevar,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Initbis _ ->
          Loggers.fprintf logger "%s=zeros(nodevar,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Concentration _ ->
          Loggers.fprintf logger "%s=zeros(nodevar,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Deriv _ ->
          Loggers.fprintf logger "%s=zeros(nodevar,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Jacobian _ ->
          Loggers.fprintf logger "%s=sparse(nodevar,nodevar)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Jacobian_var _ ->
              Loggers.fprintf logger "%s=sparse(nvar,nodevar)%s"
                (Ode_loggers_sig.string_of_array_name variable)
                (instruction_sep logger)
        | Ode_loggers_sig.Obs _ ->
          Loggers.fprintf logger "%s=zeros(nobs,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
        | Ode_loggers_sig.Tinit
        | Ode_loggers_sig.Tend
        | Ode_loggers_sig.InitialStep
        | Ode_loggers_sig.Period_t_points
        | Ode_loggers_sig.N_ode_var
        | Ode_loggers_sig.N_var
        | Ode_loggers_sig.N_rows
        | Ode_loggers_sig.N_obs
        | Ode_loggers_sig.Current_time
        | Ode_loggers_sig.Time_scale_factor
        | Ode_loggers_sig.N_rules -> ()
        | Ode_loggers_sig.Tmp ->
          Loggers.fprintf logger "%s = zeros(nodevar,1)%s"
            (Ode_loggers_sig.string_of_array_name variable)
            (instruction_sep logger)
      in
      let () =
        match variable with
        | Ode_loggers_sig.Tmp
        | Ode_loggers_sig.Rate _
        | Ode_loggers_sig.Rateun _
        | Ode_loggers_sig.Rated _
        | Ode_loggers_sig.Rateund _
        | Ode_loggers_sig.Expr _
        | Ode_loggers_sig.Init _
        | Ode_loggers_sig.Initbis _
        | Ode_loggers_sig.Concentration _
        | Ode_loggers_sig.Deriv _
        | Ode_loggers_sig.Obs _
        | Ode_loggers_sig.Jacobian _
        | Ode_loggers_sig.Jacobian_var _
        | Ode_loggers_sig.Jacobian_rate _
        | Ode_loggers_sig.Jacobian_rateun _
        | Ode_loggers_sig.Jacobian_rated _
        | Ode_loggers_sig.Jacobian_rateund _
          -> Loggers.print_newline logger
        | Ode_loggers_sig.Tinit
        | Ode_loggers_sig.Tend
        | Ode_loggers_sig.InitialStep
        | Ode_loggers_sig.N_ode_var
        | Ode_loggers_sig.N_rows
        | Ode_loggers_sig.N_var
        | Ode_loggers_sig.N_obs
        | Ode_loggers_sig.N_rules
        | Ode_loggers_sig.Time_scale_factor
        | Ode_loggers_sig.Current_time
        | Ode_loggers_sig.Period_t_points -> ()
      in
      ()
    end
  | Loggers.Json
  | Loggers.Maple | Loggers.Mathematica ->
    begin
      let () =
        match variable with
        | Ode_loggers_sig.Rate _
        | Ode_loggers_sig.Rated _
        | Ode_loggers_sig.Rateun _
        | Ode_loggers_sig.Rateund _
        | Ode_loggers_sig.Jacobian_rate _
        | Ode_loggers_sig.Jacobian_rateun _
        | Ode_loggers_sig.Jacobian_rated _
        | Ode_loggers_sig.Jacobian_rateund _
        | Ode_loggers_sig.Expr _
        | Ode_loggers_sig.Concentration _
        | Ode_loggers_sig.Initbis _ -> ()
        | Ode_loggers_sig.Init _ ->
                repeat
                  (fun _ k ->
                     let () =
                       Loggers.fprintf logger "%s%i%s0%s"
                         (Ode_loggers_sig.string_of_array_name variable)
                         k
                         (affect_symbol logger)
                         (instruction_sep logger)
                     in
                     let () =
                       Loggers.print_newline logger
                     in
                     ())
                  (nodevar-1)
        | Ode_loggers_sig.Deriv _ ->
          repeat
            (fun _  k ->
               let () =
                 Loggers.fprintf logger "%s%i%s%s0%s"
                (Ode_loggers_sig.string_of_array_name variable)
                k
                (of_t ~side:LHS logger "t")
                (affect_symbol logger)
                (instruction_sep logger)
               in
               let () =
                 Loggers.print_newline logger
               in
               ())
            (nodevar-1)
        | Ode_loggers_sig.Jacobian _
        | Ode_loggers_sig.Jacobian_var _
        | Ode_loggers_sig.Obs _
        | Ode_loggers_sig.Tinit
        | Ode_loggers_sig.Tend
        | Ode_loggers_sig.InitialStep
        | Ode_loggers_sig.Period_t_points
        | Ode_loggers_sig.N_ode_var
        | Ode_loggers_sig.N_var
        | Ode_loggers_sig.N_rows
        | Ode_loggers_sig.N_obs
        | Ode_loggers_sig.Current_time
        | Ode_loggers_sig.Time_scale_factor
        | Ode_loggers_sig.Tmp
        | Ode_loggers_sig.N_rules -> ()
      in
      ()
    end
  | Loggers.SBML -> ()
  | Loggers.Matrix  | Loggers.DOT | Loggers.HTML_Graph | Loggers.HTML
  | Loggers.HTML_Tabular | Loggers.TXT
  | Loggers.TXT_Tabular | Loggers.XLS -> ()


let print_newline logger =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab | Loggers.Octave | Loggers.Mathematica | Loggers.Maple
    -> Loggers.print_newline logger
  | Loggers.Json
  | Loggers.SBML -> ()
  | Loggers.DOT | Loggers.HTML_Graph | Loggers.HTML
  | Loggers.Matrix | Loggers.HTML_Tabular | Loggers.TXT
  | Loggers.TXT_Tabular | Loggers.XLS -> ()

type bin_op_pos = PREFIX | INFIX | POSTFIX
let _ = POSTFIX
let bin_op_pos _logger op =
  match op with
  | Operator.MULT | Operator.POW | Operator.MINUS | Operator.SUM | Operator.DIV  -> INFIX
  | Operator.MIN | Operator.MODULO | Operator.MAX -> PREFIX

let string_of_bin_op _logger op =
  match op with
  | Operator.MULT -> "*"
  | Operator.POW -> "**"
  | Operator.MINUS -> "-"
  | Operator.SUM -> "+"
  | Operator.DIV -> "/"
  | Operator.MIN -> "min"
  | Operator.MODULO -> "mod"
  | Operator.MAX -> "max"

let is_fun _logger op =
  match op with
  | Operator.UMINUS -> false
  | Operator.LOG | Operator.SQRT | Operator.EXP
  | Operator.SINUS | Operator.COSINUS | Operator.TAN
  | Operator.INT-> true


type parenthesis_mode =
    Always
  | Never
  | In_sum
  | In_product
  | In_power

let parenthesis_needed ?parenthesis_mode () =
  match parenthesis_mode with
  | Some Never -> false
  | None | Some (Always | In_sum | In_product | In_power) -> true

let parenthesis_needed_in_sum ?parenthesis_mode () =
  match parenthesis_mode with
  | Some (Never | In_sum) -> false
  | None | Some Always | Some In_product | Some In_power-> true

let parenthesis_needed_in_product ?parenthesis_mode () =
  match parenthesis_mode with
  | Some (Never | In_product | In_sum) -> false
  | None | Some (Always | In_power) -> true

let parenthesis_needed_in_power ?parenthesis_mode () =
    match parenthesis_mode with
      | Some (Never | In_product | In_sum | In_power) -> false
      | None | Some Always -> true

let keep_none a b =
  match a with None -> None
             | Some _ -> b
let parenthesis_needed_in_bin_op ?parenthesis_mode bin_op =
  let keep_none a = keep_none parenthesis_mode (Some a) in
  match bin_op with
  | Operator.MULT ->
    parenthesis_needed_in_product ?parenthesis_mode (),
    keep_none In_product,
    keep_none In_product
  | Operator.POW ->
    parenthesis_needed_in_power ?parenthesis_mode (),
    keep_none In_power,
    keep_none In_power
  | Operator.MINUS ->
    parenthesis_needed_in_sum ?parenthesis_mode (),
    keep_none In_sum,
    keep_none Always
  | Operator.SUM ->
    parenthesis_needed_in_sum ?parenthesis_mode (),
    keep_none In_sum,
    keep_none In_sum
  | Operator.DIV ->
    parenthesis_needed_in_product ?parenthesis_mode (),
    keep_none In_product,
    keep_none Always
  | Operator.MIN ->
    parenthesis_needed ?parenthesis_mode (),
    keep_none Never,
    keep_none Never
  | Operator.MODULO ->
    true,
    keep_none Never,
    keep_none Never
  | Operator.MAX ->
    parenthesis_needed ?parenthesis_mode (),
    keep_none Never,
    keep_none Never

let parenthesis_needed_in_un_op ?parenthesis_mode logger op =
  let keep_none a = keep_none parenthesis_mode (Some a) in
  if is_fun logger op then
    false, true, keep_none Never
  else
    true, false, keep_none Always

let parenthesis_needed_in_bool_op ?parenthesis_mode () =
  match parenthesis_mode with
  | None -> true, None
  | Some Never -> false, Some Always
  | Some (In_sum | In_product | In_power | Always) -> true, Some Always

let octave_matlab format =
  match format with
  | Loggers.Matlab  | Loggers.Octave -> true
  | Loggers.Mathematica | Loggers.Maple
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph
  | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> false
let mathematica_maple format =
  match format with
  | Loggers.Mathematica | Loggers.Maple -> true
  | Loggers.Matlab | Loggers.Octave
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph
  | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> false

let rec print_alg_expr ?init_mode ?parenthesis_mode string_of_var_id logger alg_expr network_handler  =
  let var = match init_mode with
    | None -> "y"
    | Some init_mode -> if init_mode then "init" else "y" in
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab  | Loggers.Octave | Loggers.Mathematica | Loggers.Maple ->
    begin
      match fst alg_expr with
      | Alg_expr.CONST (Nbr.I n)  -> Loggers.fprintf logger "%i" n
      | Alg_expr.CONST (Nbr.I64 n) -> Loggers.fprintf logger "%i" (Int64.to_int n)
      | Alg_expr.CONST (Nbr.F f) -> Loggers.fprintf logger "%g" f
      | Alg_expr.ALG_VAR x ->
        if octave_matlab format then
            Loggers.fprintf
              logger "var(%i)"
              (network_handler.Network_handler.int_of_obs x)
        else if mathematica_maple format then
          let ext =
            match
              init_mode
            with
            | Some true -> of_t ~side:RHS logger "0"
            | Some _ | None -> of_t ~side:RHS logger "t"
          in
            Loggers.fprintf
              logger "var%i%s"
              (network_handler.Network_handler.int_of_obs x)
              ext
        else ()
      | Alg_expr.DIFF_TOKEN((Alg_expr.ALG_VAR x,_),id) ->
        if octave_matlab format then
          Loggers.fprintf
            logger "jacvar(%i,%i)"
            (network_handler.Network_handler.int_of_obs x)
            (network_handler.Network_handler.int_of_token_id id)
        else ()
      | Alg_expr.DIFF_KAPPA_INSTANCE((Alg_expr.ALG_VAR x,_),id) ->
        if octave_matlab format then
          Loggers.fprintf
            logger "jacvar(%i,%i)"
            (network_handler.Network_handler.int_of_obs x)
            (network_handler.Network_handler.int_of_kappa_instance id)
      | Alg_expr.DIFF_TOKEN _
      | Alg_expr.DIFF_KAPPA_INSTANCE _ ->
        raise
          (ExceptionDefn.Internal_Error
             ("Differentiation should be pushed to the leaves of the expression!!!",
              snd alg_expr))
      | Alg_expr.KAPPA_INSTANCE x ->
        if octave_matlab format then
          Loggers.fprintf
            logger "%s(%i)" var
            (network_handler.Network_handler.int_of_kappa_instance x)
        else if mathematica_maple format then
          let ext =
            match init_mode with Some true -> ""
                               | None | Some _ ->  of_t ~side:RHS logger "t"
          in
            Loggers.fprintf
            logger "%s%i%s" var
            (network_handler.Network_handler.int_of_kappa_instance x) ext
        else ()
      | Alg_expr.TOKEN_ID x ->
        if octave_matlab format then
          Loggers.fprintf
            logger "%s(%i)" var
            (network_handler.Network_handler.int_of_token_id x)
        else if mathematica_maple format then
          let ext =
            match init_mode with Some true -> ""
                               | None | Some _ ->  of_t ~side:RHS logger "t"
          in
          Loggers.fprintf
            logger "%s%i%s" var
            (network_handler.Network_handler.int_of_kappa_instance x) ext
        else ()
      | Alg_expr.STATE_ALG_OP (Operator.TMAX_VAR) -> Loggers.fprintf logger "tend"
      | Alg_expr.STATE_ALG_OP (Operator.CPUTIME) -> Loggers.fprintf logger "0"
      | Alg_expr.STATE_ALG_OP (Operator.TIME_VAR) -> Loggers.fprintf logger "t"
      | Alg_expr.STATE_ALG_OP (Operator.EVENT_VAR) -> Loggers.fprintf logger "0"
      | Alg_expr.STATE_ALG_OP (Operator.EMAX_VAR) -> Loggers.fprintf logger "event_max"
      | Alg_expr.STATE_ALG_OP (Operator.NULL_EVENT_VAR) -> Loggers.fprintf logger "0"
      | Alg_expr.BIN_ALG_OP (op, a, b) ->
        begin
          let parenthesis_needed, mode1, mode2 =
            parenthesis_needed_in_bin_op
              ?parenthesis_mode
              op
          in
          let string_op = string_of_bin_op logger op in
          match bin_op_pos logger op
          with
          | INFIX ->
            let () =
              if parenthesis_needed
              then
                Loggers.fprintf logger "("
            in
            let () =
              print_alg_expr
                ?parenthesis_mode:mode1
                ?init_mode
                string_of_var_id logger a network_handler
            in
            let () = Loggers.fprintf logger "%s" string_op in
            let () =
              print_alg_expr
                ?parenthesis_mode:mode2
                ?init_mode
                string_of_var_id logger b network_handler
            in
            let () =
              if parenthesis_needed
              then
                Loggers.fprintf logger ")" in
            ()
          | PREFIX ->
            let () = Loggers.fprintf logger "%s" string_op in
            let () = Loggers.fprintf logger "(" in
            let () =
              print_alg_expr
                ?parenthesis_mode:mode1 ?init_mode
                string_of_var_id logger a network_handler
            in
            let () = Loggers.fprintf logger "," in
            let () =
              print_alg_expr
                ?parenthesis_mode:mode2 ?init_mode
                string_of_var_id logger b network_handler
            in
            let () = Loggers.fprintf logger ")" in
            ()
          | POSTFIX ->
            let () = Loggers.fprintf logger "(" in
            let () =
              print_alg_expr
                ?parenthesis_mode:mode1 ?init_mode
                string_of_var_id logger a network_handler
            in
            let () = Loggers.fprintf logger "," in
            let () =
              print_alg_expr
                ?parenthesis_mode:mode2 ?init_mode
                string_of_var_id logger b network_handler
            in
            let () = Loggers.fprintf logger ")" in
            let () = Loggers.fprintf logger "%s" string_op in
            ()
        end

      | Alg_expr.UN_ALG_OP (op, a) ->
        let parenthesis_needed_outside,
            parenthesis_needed_inside,
            mode
          =
          parenthesis_needed_in_un_op
            ?parenthesis_mode logger
            op
        in
        let () =
          if parenthesis_needed_outside
          then
            Loggers.fprintf logger "("
        in
        let string_op = Loggers_string_of_op.string_of_un_op logger op in
        let () = Loggers.fprintf logger "%s" string_op in
        let () =
          if parenthesis_needed_inside
          then Loggers.fprintf logger "("
        in
        let () = print_alg_expr ?parenthesis_mode:mode ?init_mode string_of_var_id logger a network_handler in
        let () =
          if parenthesis_needed_inside
          then Loggers.fprintf logger ")"
        in
        let () =
          if parenthesis_needed_outside
          then
            Loggers.fprintf logger ")"
        in
        ()
      | Alg_expr.IF (cond, yes, no) ->
        let mode = keep_none parenthesis_mode (Some Never) in
        let () = Loggers.fprintf logger "merge(" in
        let () = print_bool_expr ?parenthesis_mode:mode ?init_mode string_of_var_id logger cond network_handler in
        let () = Loggers.fprintf logger "," in
        let () = print_alg_expr ?parenthesis_mode:mode ?init_mode string_of_var_id logger yes network_handler in
        let () = Loggers.fprintf logger "," in
        let () = print_alg_expr ?parenthesis_mode:mode ?init_mode string_of_var_id logger no network_handler in
        let () = Loggers.fprintf logger ")" in
            ()
    end
  | Loggers.SBML ->
    let () = Loggers.fprintf logger "<math xmlns=\"http://www.w3.org/1998/Math/MathML\">" in
    let () =
      Sbml_backend.print_alg_expr_in_sbml string_of_var_id logger alg_expr
        network_handler in
    let () = Loggers.fprintf logger "</math>" in
    ()
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()
and print_bool_expr ?parenthesis_mode ?init_mode string_of_var_id logger expr network_handler =
 match Loggers.get_encoding_format logger with
   | Loggers.Matlab  | Loggers.Octave | Loggers.Mathematica | Loggers.Maple
     ->
    begin
      match fst expr with
      | Alg_expr.TRUE -> Loggers.fprintf logger "true"
      | Alg_expr.FALSE -> Loggers.fprintf logger "false"
      | Alg_expr.COMPARE_OP (op,a,b) ->
        let mode = keep_none parenthesis_mode (Some Never) in
        let () =
          print_alg_expr ?parenthesis_mode:mode ?init_mode string_of_var_id logger a network_handler in
        let () = Loggers.fprintf logger "%s" (Loggers_string_of_op.string_of_compare_op logger op) in
        let () = print_alg_expr ?parenthesis_mode:mode ?init_mode string_of_var_id logger b network_handler in
      let () = Loggers.fprintf logger ")" in
        ()
      | Alg_expr.BOOL_OP (op,a,b) ->
        let do_paren, mode =
          parenthesis_needed_in_bool_op ?parenthesis_mode ()
        in
        let () =
          if do_paren then
            Loggers.fprintf logger "("
        in
        let () =
          print_bool_expr
            ?parenthesis_mode:mode ?init_mode string_of_var_id logger a network_handler
        in
        let () = Loggers.fprintf logger "%s" (Loggers_string_of_op.string_of_bool_op logger op) in
        let () = print_bool_expr ?init_mode string_of_var_id logger b network_handler in
        let () =
          if do_paren then
            Loggers.fprintf logger ")"
        in
        ()
    end
  | Loggers.SBML ->
    let () = Loggers.fprintf logger "<math xmlns=\"http://www.w3.org/1998/Math/MathML\">" in
    let () = Sbml_backend.print_bool_expr_in_sbml string_of_var_id logger expr network_handler in
    let () = Loggers.fprintf logger "</math>" in ()
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let print_alg_expr_few_parenthesis ?init_mode string_of_var_id logger alg_expr network_handler =
  print_alg_expr
    ?init_mode ?parenthesis_mode:(Some Never)
    string_of_var_id logger
    (Alg_expr_extra.simplify alg_expr)
    network_handler

let string_of_variable_sbml string_of_var_id variable =
  match variable with
  | Ode_loggers_sig.Expr i ->
    string_of_var_id i
  | Ode_loggers_sig.Concentration i -> "s"^(string_of_int i)
  | Ode_loggers_sig.Init _
  | Ode_loggers_sig.Initbis _
  | Ode_loggers_sig.Deriv _
  | Ode_loggers_sig.Obs _
  | Ode_loggers_sig.Jacobian _
  | Ode_loggers_sig.Jacobian_var _
  | Ode_loggers_sig.Tinit
  | Ode_loggers_sig.Tend
  | Ode_loggers_sig.InitialStep
  | Ode_loggers_sig.Period_t_points
  | Ode_loggers_sig.N_rules
  | Ode_loggers_sig.N_ode_var
  | Ode_loggers_sig.N_var
  | Ode_loggers_sig.N_obs
  | Ode_loggers_sig.N_rows
  | Ode_loggers_sig.Tmp -> Ode_loggers_sig.string_of_array_name variable
  | Ode_loggers_sig.Time_scale_factor -> "t_correct_dimmension"
  | Ode_loggers_sig.Current_time -> "t"
  | Ode_loggers_sig.Rate int -> Printf.sprintf "k%i" int
  | Ode_loggers_sig.Rated int -> Printf.sprintf "kd%i" int
  | Ode_loggers_sig.Rateun int -> Printf.sprintf "kun%i" int
  | Ode_loggers_sig.Rateund int -> Printf.sprintf "kdun%i" int
  | Ode_loggers_sig.Jacobian_rate (_,_)
  | Ode_loggers_sig.Jacobian_rateun (_,_)
  | Ode_loggers_sig.Jacobian_rated (_,_)
  | Ode_loggers_sig.Jacobian_rateund (_,_) -> ""



  let unit_of_variable_sbml variable =
    match variable with
    | Ode_loggers_sig.Current_time
    | Ode_loggers_sig.Period_t_points
    | Ode_loggers_sig.Tinit
    | Ode_loggers_sig.Tend -> Some "time"
    | Ode_loggers_sig.Time_scale_factor -> Some "time-per-substance"
    | Ode_loggers_sig.Obs _
    | Ode_loggers_sig.Init _
    | Ode_loggers_sig.Concentration _
    | Ode_loggers_sig.Initbis _ -> Some "substance"
    | Ode_loggers_sig.Expr _
    | Ode_loggers_sig.Deriv _
    | Ode_loggers_sig.Jacobian _
    | Ode_loggers_sig.Jacobian_var _
    | Ode_loggers_sig.InitialStep
    | Ode_loggers_sig.Jacobian_rate (_,_)
    | Ode_loggers_sig.Jacobian_rated (_,_)
    | Ode_loggers_sig.Jacobian_rateun (_,_)
    | Ode_loggers_sig.Jacobian_rateund (_,_)
    | Ode_loggers_sig.Rate _
    | Ode_loggers_sig.Rated _
    | Ode_loggers_sig.Rateun _
    | Ode_loggers_sig.Rateund _
    | Ode_loggers_sig.N_rules
    | Ode_loggers_sig.N_ode_var
    | Ode_loggers_sig.N_var
    | Ode_loggers_sig.N_obs
    | Ode_loggers_sig.N_rows
    | Ode_loggers_sig.Tmp -> None

let print_sbml_parameters string_of_var_id logger logger_buffer variable expr =
  let unit_string =
    match
      unit_of_variable_sbml variable
    with
    | None -> ""
    | Some x -> " units=\""^x^"\""
  in
  let id = string_of_variable_sbml string_of_var_id variable in
  let () = Loggers.set_id_of_global_parameter logger variable id  in
  Sbml_backend.single_box
    logger_buffer
    "parameter"
    ~options:(fun () ->
        Format.sprintf
          "metaid=\"%s\" id=\"%s\" value=\"%s\"%s"
          (Sbml_backend.meta_id_of_logger logger)
          id
          (Nbr.to_string expr)
          unit_string)


let print_comment
    ?breakline:(breakline=false)
    logger
    ?filter_in:(filter_in=None) ?filter_out:(filter_out=[])
    string
  =
  if string = ""
  then
    ()
  else
    let format = Loggers.get_encoding_format logger in
    if shall_I_do_it format filter_in filter_out
    then
      match
        format
      with
      | Loggers.Matlab
      | Loggers.Octave ->
        let () = Loggers.fprintf logger "%% %s" string in
        if breakline then Loggers.print_newline logger
      | Loggers.Maple ->
      let () = Loggers.fprintf logger "# %s" string in
      if breakline then Loggers.print_newline logger
      | Loggers.Mathematica ->
        let () = Loggers.fprintf logger "(* %s *)" string in
        if breakline then Loggers.print_newline logger
      | Loggers.SBML ->
        let () = Loggers.fprintf logger "<!-- %s -->" (Sbml_backend.string_in_comment string) in
        if breakline then
          Loggers.print_newline logger
        else Loggers.print_breakable_hint logger
      | Loggers.Json
      | Loggers.DOT
      | Loggers.Matrix | Loggers.HTML_Graph
      | Loggers.HTML
      | Loggers.HTML_Tabular
      | Loggers.TXT
      | Loggers.TXT_Tabular
      | Loggers.XLS -> ()

let associate ?init_mode:(init_mode=false) ?comment:(comment="")
    string_of_var_id logger logger_buffer variable alg_expr network_handler =
  let () = Loggers.set_expr logger variable alg_expr in
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab  | Loggers.Octave ->
    begin
      let () =
        Loggers.fprintf logger "%s="
          (string_of_variable ~side:LHS logger variable)
      in
      let () = print_alg_expr_few_parenthesis ~init_mode string_of_var_id logger alg_expr network_handler in
      let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
      let () = if comment = "" then () else Loggers.fprintf logger " " in
      let () = print_comment logger comment in
      let () = Loggers.print_newline logger in
      ()
    end
  | Loggers.Maple   ->
    begin
      match variable with
      | Ode_loggers_sig.Expr int
      | Ode_loggers_sig.Concentration int
      | Ode_loggers_sig.Obs int
      | Ode_loggers_sig.Deriv int
      | Ode_loggers_sig.Rate int
      | Ode_loggers_sig.Rated int
      | Ode_loggers_sig.Rateun int
      | Ode_loggers_sig.Rateund int
          ->
        begin
          let () =
            Loggers.fprintf logger "%s%i:=(t -> "
              (Ode_loggers_sig.string_of_array_name variable) int
          in
          let () =
            print_alg_expr_few_parenthesis ~init_mode string_of_var_id logger
              alg_expr network_handler
          in
          let () = Loggers.fprintf logger ")%s" (instruction_sep logger) in
          let () = if comment = "" then () else Loggers.fprintf logger " " in
          let () = print_comment logger comment in
          let () = Loggers.print_newline logger in
          ()
        end
      | Ode_loggers_sig.Init int
      | Ode_loggers_sig.Initbis int ->
        let () =
          Loggers.fprintf logger "%s%i:="
            (Ode_loggers_sig.string_of_array_name variable) int
        in
        let () =
          print_alg_expr_few_parenthesis ~init_mode string_of_var_id logger alg_expr network_handler
        in
        let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
        let () = if comment = "" then () else Loggers.fprintf logger " " in
        let () = print_comment logger comment in
        let () = Loggers.print_newline logger in
        ()
      | Ode_loggers_sig.Tinit
      | Ode_loggers_sig.Tend
      | Ode_loggers_sig.InitialStep
      | Ode_loggers_sig.Period_t_points
      | Ode_loggers_sig.N_rules
      | Ode_loggers_sig.N_ode_var
      | Ode_loggers_sig.N_var
      | Ode_loggers_sig.N_obs
      | Ode_loggers_sig.N_rows
      | Ode_loggers_sig.Tmp
      | Ode_loggers_sig.Current_time
      | Ode_loggers_sig.Time_scale_factor ->
      let () =
        Loggers.fprintf logger "%s:="
          (Ode_loggers_sig.string_of_array_name variable)
      in
      let () =
        print_alg_expr_few_parenthesis ~init_mode string_of_var_id logger alg_expr network_handler
      in
      let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
      let () = if comment = "" then () else Loggers.fprintf logger " " in
      let () = print_comment logger comment in
      let () = Loggers.print_newline logger in
      ()
      | Ode_loggers_sig.Jacobian _
      | Ode_loggers_sig.Jacobian_var _
      | Ode_loggers_sig.Jacobian_rate _
      | Ode_loggers_sig.Jacobian_rated _
      | Ode_loggers_sig.Jacobian_rateun _
      | Ode_loggers_sig.Jacobian_rateund _ ->
          ()
    end
  | Loggers.Mathematica  ->
    begin
      let () =
        Loggers.fprintf logger "%s="
          (string_of_variable ~side:LHS logger variable)
      in
      let () = print_alg_expr_few_parenthesis ~init_mode string_of_var_id logger alg_expr network_handler in
      let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
      let () = if comment = "" then () else Loggers.fprintf logger " " in
      let () = print_comment logger comment in
      let () = Loggers.print_newline logger in
      ()
    end
  | Loggers.SBML ->
    begin
      match variable, init_mode with
      | Ode_loggers_sig.Expr _ , true ->
        begin
          match
            Ode_loggers_sig.is_expr_alias alg_expr,
            Ode_loggers_sig.is_expr_const alg_expr
          with
          | None, true  ->
            print_sbml_parameters
              string_of_var_id
              logger
              logger_buffer
              variable
              (Sbml_backend.eval_init_alg_expr
                 logger
                 network_handler
                 alg_expr)
          | Some _, _ | _, false -> ()
        end
        | (Ode_loggers_sig.Tinit |
         Ode_loggers_sig.Tend |
         Ode_loggers_sig.Period_t_points
        ) ,_ ->
        print_sbml_parameters
          string_of_var_id
          logger
          logger_buffer
          variable
          (Sbml_backend.eval_init_alg_expr logger network_handler alg_expr)
        | Ode_loggers_sig.Rate _,_
        | Ode_loggers_sig.Rated _,_
        | Ode_loggers_sig.Rateun _,_
        | Ode_loggers_sig.Rateund _,_ ->
          if Ode_loggers_sig.is_expr_const alg_expr then
            print_sbml_parameters
              string_of_var_id
              logger
              logger_buffer
              variable
              (Sbml_backend.eval_init_alg_expr logger network_handler alg_expr)
        | Ode_loggers_sig.Jacobian_rate (_,_),_
        | Ode_loggers_sig.Jacobian_rateun (_,_),_
        | Ode_loggers_sig.Jacobian_rated (_,_),_
        | Ode_loggers_sig.Jacobian_rateund (_,_),_
        | Ode_loggers_sig.Expr _ , _
        | Ode_loggers_sig.Init _, _
        | Ode_loggers_sig.Initbis _, _
        | Ode_loggers_sig.Concentration _,_
        | Ode_loggers_sig.Deriv _,_
        | Ode_loggers_sig.Obs _,_
        | Ode_loggers_sig.Jacobian _,_
        | Ode_loggers_sig.Jacobian_var _,_
        | Ode_loggers_sig.InitialStep,_
        | Ode_loggers_sig.N_rules,_
        | Ode_loggers_sig.N_ode_var,_
        | Ode_loggers_sig.N_var,_
        | Ode_loggers_sig.N_obs,_
        | Ode_loggers_sig.N_rows,_
        | Ode_loggers_sig.Tmp,_
        | Ode_loggers_sig.Time_scale_factor,_
        | Ode_loggers_sig.Current_time,_ -> ()
    end
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let associate_nrows logger =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab | Loggers.Octave ->
    let () =
      Loggers.fprintf
        logger
        "nrows = length(soln.x)%s"
        (instruction_sep logger)
    in
    Loggers.print_newline logger
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph
  | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let associate_t logger n =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab | Loggers.Octave ->
    let () = Loggers.fprintf logger "t = y(%i)%s" n (instruction_sep logger) in
    Loggers.print_newline logger
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph
  | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let init_time logger n =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab | Loggers.Octave ->
    let () = Loggers.fprintf logger "y(%i) = t%s" n (instruction_sep logger) in
    Loggers.print_newline logger
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph
  | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let inc_symbol logger string varrhs =
  match Loggers.get_encoding_format logger
  with
  | Loggers.Matlab  | Loggers.Octave
  | Loggers.Maple   | Loggers.Mathematica ->
    Printf.sprintf "%s%s%s" (affect_symbol logger) varrhs string
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ""

let increment ?init_mode:(init_mode=false) ?comment:(comment="") string_of_var_id logger variable alg_expr network =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab  | Loggers.Octave
  | Loggers.Maple | Loggers.Mathematica ->
    begin
      let varlhs = string_of_variable ~side:LHS logger variable in
      let varrhs = string_of_variable ~side:RHS logger variable in
      let () =
        Loggers.fprintf logger "%s%s" varlhs (inc_symbol logger "+" varrhs)
      in
      let () = print_alg_expr ~parenthesis_mode:In_sum ~init_mode string_of_var_id logger alg_expr network in
      let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
      let () = if comment = "" then () else Loggers.fprintf logger " " in
      let () = print_comment logger comment in
      let () = Loggers.print_newline logger in
      ()
    end
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let apply_correct string_of_var correct var  =
  let var_string = string_of_var var in
  match
    correct
  with
  | Nil | Div 1 | Mul 1 -> var_string
  | Div i -> var_string^"/"^(string_of_int i)
  | Mul i -> (string_of_int i)^"*"^var_string

let apply_empty correct =
  match
    correct
  with
  | Nil | Div 1 | Mul 1 -> ""
  | Div i -> "/"^(string_of_int i)
  | Mul i -> "*"^(string_of_int i)

let gen string logger var_species ~nauto_in_species ~nauto_in_lhs var_rate var_list =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab | Loggers.Octave
  | Loggers.Maple | Loggers.Mathematica ->
    begin
      let varlhs = string_of_variable ~side:LHS logger var_species in
      let varrhs = string_of_variable ~side:RHS logger var_species in
      let () =
        Loggers.fprintf logger "%s%s" varlhs (inc_symbol logger string varrhs) in
      let bool =
        if nauto_in_species = 1
        then false
        else
          let () = Loggers.fprintf logger "%i" nauto_in_species in
          true
      in
      let bool =
        if nauto_in_lhs =1
        then
          bool
        else
          let () =
            if bool
            then
              Loggers.fprintf logger "/%i" nauto_in_lhs
            else
              Loggers.fprintf logger "1/%i" nauto_in_lhs
          in
          true
      in
      let () =
        if bool
        then
          Loggers.fprintf logger "*"
      in
      let () =
        Loggers.fprintf
          logger "%s" (string_of_variable ~side:RHS logger var_rate)
      in
      let () =
        List.iter
          (fun (var,correct) ->
             Loggers.fprintf logger "*%s"
               (apply_correct (string_of_variable ~side:RHS logger) correct var))
          var_list
      in
      let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
      let () = Loggers.print_newline logger in
      ()
    end
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()


let consume = gen "-"
let produce = gen "+"

let gen_deriv
    string logger var_species ~nauto_in_species ~nauto_in_lhs var_rate var_list dep =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab  | Loggers.Octave ->
    begin
      let () =
        Mods.IntSet.iter
          (fun dt ->
             let var_dt_lhs =
               string_of_variable
                 ~side:LHS
                 logger
                 (variable_of_derived_variable
                    var_species dt)
             in
             let var_dt_rhs =
               string_of_variable
                 ~side:RHS
                 logger
                 (variable_of_derived_variable
                    var_species dt)
             in
             let () =
               Loggers.fprintf
                 logger "%s%s%s%s" var_dt_lhs (affect_symbol logger) var_dt_rhs string
             in
             let bool =
               if nauto_in_species = 1
               then false
               else
                 let () = Loggers.fprintf logger "%i" nauto_in_species in
                 true
             in
             let bool =
               if nauto_in_lhs =1
               then
                 bool
               else
                 let () =
                   if bool
                   then
                     Loggers.fprintf logger "/%i" nauto_in_lhs
                   else
                     Loggers.fprintf logger "1/%i" nauto_in_lhs
                 in
                 true
             in
             let () =
               if bool
               then
                 Loggers.fprintf logger "*"
             in
             let () =
               Loggers.fprintf logger "%s"
                 (string_of_variable ~side:RHS logger
                    (variable_of_derived_variable var_rate dt ))
             in
             let () =
               List.iter
                 (fun (var,correct) ->
                    Loggers.fprintf logger "*%s"
                      (apply_correct
                         (string_of_variable ~side:RHS logger)
                         correct
                         (Ode_loggers_sig.Concentration var)))
                 var_list
             in
             let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
             let () = Loggers.print_newline logger in
             ()
          )
          dep
      in
      let rec aux tail suffix =
        match tail with
        | [] -> ()
        | (h,correct)::t ->
          begin
            let var_dt_lhs =
              string_of_variable
                ~side:LHS
                logger
                (variable_of_derived_variable var_species h)
            in
            let var_dt_rhs =
              string_of_variable
                ~side:RHS
                logger
                (variable_of_derived_variable var_species h)
            in
            let () = Loggers.fprintf logger "%s=%s%s" var_dt_lhs var_dt_rhs string in
            let bool =
              if nauto_in_species = 1
              then false
              else
                let () = Loggers.fprintf logger "%i" nauto_in_species in
                true
            in
            let bool =
              if nauto_in_lhs =1
              then
                bool
              else
                let () =
                  if bool
                  then
                    Loggers.fprintf logger "/%i" nauto_in_lhs
                  else
                    Loggers.fprintf logger "1/%i" nauto_in_lhs
                in
                true
            in
            let () =
              if bool
              then
                Loggers.fprintf logger "*"
            in
            let () =
              Loggers.fprintf logger "%s"
                (string_of_variable ~side:RHS logger var_rate)
            in
            let () =
              List.iter
                (fun (var,correct) ->
                   Loggers.fprintf logger "*%s"
                     (apply_correct
                        (string_of_variable ~side:RHS logger)
                        correct
                        (Ode_loggers_sig.Concentration var)))
                (List.rev suffix)
            in
            let () =
              Loggers.fprintf logger "%s" (apply_empty correct)
            in
            let () =
              List.iter
                (fun (var,correct) ->
                   Loggers.fprintf logger "*%s"
                     (apply_correct
                        (string_of_variable ~side:RHS logger)
                        correct (Ode_loggers_sig.Concentration var)))
                (List.rev t)
            in
            let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
            let () = Loggers.print_newline logger in
            aux t ((h,correct)::suffix)
          end
      in aux var_list []
    end
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular
  | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()


let consume_jac = gen_deriv "-"
let produce_jac = gen_deriv "+"
let update_token string_of_var_id logger var_token ~nauto_in_lhs var_rate expr var_list handler =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab  | Loggers.Octave ->
    begin
      let var_lhs = string_of_variable ~side:LHS logger var_token in
      let var_rhs = string_of_variable ~side:RHS logger var_token in
      let () =
        Loggers.fprintf logger "%s%s%s+" var_lhs (affect_symbol logger) var_rhs
      in
      let bool =
        if nauto_in_lhs =1
        then
          false
        else
          let () =
            Loggers.fprintf logger "1/%i" nauto_in_lhs
          in
          true
      in
      let () =
        if bool
        then
          Loggers.fprintf logger "*"
      in
      let () =
        Loggers.fprintf logger "%s" (string_of_variable ~side:RHS logger var_rate) in
      let () =
        List.iter
          (fun (var,correct) ->
             Loggers.fprintf logger "*%s"
               (apply_correct (string_of_variable ~side:RHS logger) correct var))
          var_list
      in
      let () = Loggers.fprintf logger "*" in
      let () =
        print_alg_expr
          ~parenthesis_mode:In_product
          string_of_var_id logger expr handler
      in
      let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
      let () = Loggers.print_newline logger in
      ()
    end
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()

let update_token_jac ?time_var string_of_var_id logger var_token ~nauto_in_lhs var_rate expr var_list handler dep_rate ~dep_mixture ~dep_token =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab  | Loggers.Octave ->
    begin
      (* We differentiate according to the rule rate *)
      let () =
        Mods.IntSet.iter
        (fun dt ->
           let var_dt_lhs =
             string_of_variable ~side:LHS
               logger
               (variable_of_derived_variable var_token dt)
           in
           let var_dt_rhs =
             string_of_variable ~side:LHS
               logger
               (variable_of_derived_variable var_token dt)
           in
           let () =
             Loggers.fprintf
               logger "%s%s%s+"
               var_dt_lhs (affect_symbol logger) var_dt_rhs
           in
           let bool =
             if nauto_in_lhs =1
             then
               false
             else
               let () =
                 Loggers.fprintf logger "1/%i" nauto_in_lhs
               in
               true
           in
           let () =
             if bool
             then
               Loggers.fprintf logger "*"
           in
           let () =
             Loggers.fprintf logger "%s"
               (string_of_variable ~side:RHS logger
                  (variable_of_derived_variable var_rate dt))
           in
           let () =
             List.iter
               (fun (var,correct) ->
                  Loggers.fprintf logger "*%s"
                    (apply_correct
                       (string_of_variable ~side:RHS logger)
                       correct
                       (Ode_loggers_sig.Concentration var)))
               var_list
           in
           let () = Loggers.fprintf logger "*" in
           let () =
             print_alg_expr
               ~parenthesis_mode:In_product
               string_of_var_id logger expr handler
           in
           let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
           let () = Loggers.print_newline logger in
           ())
        dep_rate
      in
      let () =
        let aux_deriv deriv dt =
          let dt_id = dt in
          let var_dt_lhs =
            string_of_variable
              ~side:LHS
              logger
              (variable_of_derived_variable var_token dt_id)
          in
          let var_dt_rhs =
            string_of_variable
              ~side:RHS
              logger
              (variable_of_derived_variable var_token dt_id)
          in
          let () =
            Loggers.fprintf
              logger "%s%s%s+" var_dt_lhs
              (affect_symbol logger)
              var_dt_rhs
          in
          let bool =
            if nauto_in_lhs =1
            then
              false
            else
              let () =
                Loggers.fprintf logger "1/%i" nauto_in_lhs
              in
              true
          in
          let () =
            if bool
            then
              Loggers.fprintf logger "*"
          in
          let () =
            Loggers.fprintf logger "%s"
              (string_of_variable ~side:RHS logger var_rate)
          in
          let () =
            List.iter
              (fun (var,correct) ->
                 Loggers.fprintf logger "*%s"
                   (apply_correct
                      (string_of_variable ~side:RHS logger)
                      correct
                      (Ode_loggers_sig.Concentration var)))
              var_list
          in
          let () = Loggers.fprintf logger "*" in
          let () =
            print_alg_expr
              ~parenthesis_mode:In_product
              string_of_var_id logger
              (Alg_expr_extra.simplify
                 (deriv expr dt))
              handler
          in
          let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
          let () = Loggers.print_newline logger in
          ()
        in
        (* we differentiate according to the token coefficient *)
        let () =
          Mods.IntSet.iter
            (aux_deriv (Alg_expr_extra.diff_mixture ?time_var))
            dep_mixture
        in
        let () =
          Mods.IntSet.iter
            (aux_deriv Alg_expr_extra.diff_token)
            dep_token
        in ()
      in
      let () =  (* we differentiate according to the species *)
        let rec aux tail suffix =
          match tail with
          | [] -> ()
          | (h,correct)::t ->
            begin
              let var_dt_lhs =
                string_of_variable
                  ~side:LHS
                  logger
                  (variable_of_derived_variable var_token h)
              in
              let var_dt_rhs =
                string_of_variable
                  ~side:RHS
                  logger
                  (variable_of_derived_variable var_token h)
              in
              let () = Loggers.fprintf logger "%s=%s+" var_dt_lhs var_dt_rhs in
              let bool =
                if nauto_in_lhs =1
                then
                  false
                else
                  let () =
                    Loggers.fprintf logger "1/%i" nauto_in_lhs
                  in
                  true
              in
              let () =
                if bool
                then
                  Loggers.fprintf logger "*"
              in
              let () =
                Loggers.fprintf logger "%s"
                  (string_of_variable ~side:RHS logger var_rate)
              in
              let () =
                List.iter
                  (fun (var,correct) ->
                     Loggers.fprintf logger "*%s"
                       (apply_correct
                          (string_of_variable ~side:RHS logger)
                          correct
                          (Ode_loggers_sig.Concentration var)))
                  (List.rev suffix)
              in
              let () =
                List.iter
                  (fun (var,correct) ->
                     Loggers.fprintf logger "*%s"
                       (apply_correct
                          (string_of_variable ~side:RHS logger)
                          correct
                          (Ode_loggers_sig.Concentration var)))
                  (List.rev tail)
              in
              let () = Loggers.fprintf logger "*" in
              let () =
                print_alg_expr
                  ~parenthesis_mode:In_product
                  string_of_var_id logger
                  (Alg_expr_extra.simplify
                     expr)
                  handler
              in
              let () = Loggers.fprintf logger "%s" (instruction_sep logger) in
              let () = Loggers.print_newline logger in
              aux t ((h,correct)::suffix)
            end
        in aux var_list []
      in
      ()
    end
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph | Loggers.HTML | Loggers.HTML_Tabular | Loggers.TXT | Loggers.TXT_Tabular | Loggers.XLS -> ()


let print_options ~compute_jacobian logger =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () =
      print_list logger
        (if compute_jacobian then
           [
             "options = odeset('RelTol', 1e-3, ...";
             "                 'AbsTol', 1e-3, ...";
             "                 'InitialStep', initialstep, ...";
             "                 'MaxStep', tend, ...";
             ("                 'Jacobian', @ode_jacobian)"^(instruction_sep logger))
           ]
         else
           [
             "options = odeset('RelTol', 1e-3, ...";
             "                 'AbsTol', 1e-3, ...";
             "                 'InitialStep', initialstep, ...";
             ("                 'MaxStep', tend)"^(instruction_sep logger))
           ])
    in
    let () = Loggers.print_newline logger in
    ()
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()

let start_time logger float =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () = Loggers.fprintf logger "t = %f%s" float (instruction_sep logger) in
    Loggers.print_newline logger
  | Loggers.SBML
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()

let declare_init ?comment:(comment="") logger i =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () =
      Loggers.fprintf logger
        "Init(%i) = init(%i); " i i
    in
    let () = print_comment logger comment in
    Loggers.print_newline logger
  | Loggers.SBML
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()

let print_license_check logger =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () = print_list logger
        [
          "uiIsOctave = false"^(instruction_sep logger);
          "uiIsMatlab = false"^(instruction_sep logger);
          "LIC = license('inuse')"^(instruction_sep logger);
          "for elem = 1:numel(LIC)";
          "    envStr = LIC(elem).feature";
          "    if strcmpi(envStr,'octave')";
          "       LICname=envStr"^(instruction_sep logger);
          "       uiIsOctave = true"^(instruction_sep logger);
          "       break";
          "    end";
          "    if strcmpi(envStr,'matlab')";
          "       LICname=envStr";
          "       uiIsMatlab = true"^(instruction_sep logger);
          "       break";
          "    end";
          "end";
        ]
    in Loggers.print_newline logger
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()

let print_integrate ~nobs ~nodevar logger =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () =
      print_list logger
        [
          "if uiIsMatlab";
          "   soln =  ode15s(@ode_aux,[tinit tend],ode_init(),options)"^(instruction_sep logger);
          "   soln.y=soln.y'"^(instruction_sep logger);
          "elseif uiIsOctave";
          "   soln = ode2r(@ode_aux,[tinit tend],ode_init(),options)"^(instruction_sep logger);
          "end";]
    in
    let () = Loggers.print_newline logger in
    ()
  | Loggers.Maple ->
    let () =
      Loggers.fprintf logger
        "sol :="
    in
    let () =
      Loggers.print_newline logger
    in
    let () =
      Loggers.fprintf logger "   dsolve("
    in
    let () =
      Loggers.print_newline logger
    in
    let () =
      Loggers.fprintf logger "      {"
    in
    let () = Loggers.print_newline logger in
    let () =
      repeat
        (fun second_time k ->
          let sep = if second_time then ", " else "" in
          let () =
            Loggers.fprintf logger
              "%s" sep
          in
          let () =
            Loggers.print_newline logger
          in
          let () =
            Loggers.fprintf logger
              "         diff(y%i(t),t) = dydt%i(t)," k k
          in
          let () =
            Loggers.print_newline logger
          in
          let () =
            Loggers.fprintf logger
              "         y%i(0) = init%i"
              k k
          in
          ())
        (nodevar-1)
    in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      }," in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      {" in
    let () =
      repeat
        (fun second_time k ->
          let sep = if second_time then ", " else "" in
          let () = Loggers.fprintf logger "%s" sep in
          let () = Loggers.print_newline logger in
          let () = Loggers.fprintf logger "         y%i(t)" k in
          ())
        (nodevar-1)
    in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      }," in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      numeric, range=tinit..tend):" in
    ()
  | Loggers.Mathematica ->
    let () =
      Loggers.fprintf logger
        "sol ="
    in
    let () =
      Loggers.print_newline logger
    in
    let () =
      Loggers.fprintf logger "   NDSolve["
    in
    let () =
      Loggers.print_newline logger
    in
    let () =
      Loggers.fprintf logger "      {"
    in
    let () = Loggers.print_newline logger in
    let () =
      repeat
        (fun second_time k ->
           let sep = if second_time then ", " else "" in
           let () =
             Loggers.fprintf logger
               "%s" sep
           in
           let () =
             Loggers.print_newline logger
           in
           let () =
             Loggers.fprintf logger
               "         y%i'[t] == dydt%i[t]," k k
           in
           let () =
             Loggers.print_newline logger
           in
           let () =
             Loggers.fprintf logger
               "         y%i[0] == init%i"
               k k
           in
           ())
        (nodevar-1)
    in
    let () =
      repeat
        (fun second_time k ->
           let sep = if nodevar>1 || second_time then ", " else "" in
           let () =
             Loggers.fprintf logger
               "%s" sep
           in
           let () =
             Loggers.print_newline logger
           in
           let () =
             Loggers.fprintf logger
               "         o%i[t] == obs%i[t]" k k
           in
           ())
        nobs
    in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      }," in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      {" in
    let () =
      repeat
        (fun second_time k ->
           let sep = if second_time then ", " else "" in
           let () = Loggers.fprintf logger "%s" sep in
           let () = Loggers.print_newline logger in
           let () = Loggers.fprintf logger "         y%i" k in
           ())
        (nodevar-1)
    in
    let () =
      repeat
        (fun second_time k ->
           let sep = if nodevar>1 || second_time then ", " else "" in
           let () =
             Loggers.fprintf logger
               "%s" sep
           in
           let () =
             Loggers.print_newline logger
           in
           let () =
             Loggers.fprintf logger
               "         o%i" k
           in
           ())
        nobs
    in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      }," in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "      {t,tinit,tend}];" in
    let () = Loggers.print_newline logger in
    ()
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()

let print_interpolate logger =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () =
      print_list logger
        [
          "n_points = floor ((tend-tinit)/"^(Ode_loggers_sig.string_of_array_name Ode_loggers_sig.Period_t_points)^"+1"^(instruction_sep logger);
          "t = linspace(tinit, tend, n_points)"^(instruction_sep logger);
          "obs = zeros(nrows,nobs)"^(instruction_sep logger);
          "";
          "for j=1:nrows";
          "    for i=1:nodevar";
          "        z(i)=soln.y(j,i)"^(instruction_sep logger);
          "    end";
          "    h=ode_obs(z)"^(instruction_sep logger);
          "    for i=1:nobs";
          "        obs(j,i)=h(i)"^(instruction_sep logger);
          "    end";
          "end";
          "if nobs==1";
          "   y = interp1(soln.x, obs, t, 'pchip')'"^(instruction_sep logger);
          "else";
          "   y = interp1(soln.x, obs, t, 'pchip')"^(instruction_sep logger);
          "end"
        ]
    in Loggers.print_newline logger
    | Loggers.Maple | Loggers.Mathematica ->
      ()
    | Loggers.SBML
    | Loggers.Json
    | Loggers.DOT
    | Loggers.HTML_Graph
    | Loggers.Matrix | Loggers.HTML
    | Loggers.HTML_Tabular
    | Loggers.TXT
    | Loggers.TXT_Tabular
    | Loggers.XLS -> ()

let print_dump_plots ~nobs ~data_file ~command_line ~titles logger  =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () =
      print_list logger
        [
          "filename = '"^data_file^"'"^(instruction_sep logger);
          "fid = fopen (filename,'w')"^(instruction_sep logger);
          "fprintf(fid,'# "^command_line^"\\n')";
          "fprintf(fid,'# ')"]
    in
    let () =
      print_list logger
        (List.rev_map
           (fun x -> "fprintf(fid,'"^x^",')")
           (List.rev titles))
    in
    let () =
      print_list logger
        [
          "fprintf(fid,'\\n')";
          "for j=1:n_points";
          "    for i=1:nobs";
          "        fprintf(fid,'%f,',y(j,i))"^(instruction_sep logger);
          "    end";
          "    fprintf(fid,'\\n')"^(instruction_sep logger);
          "end";
          "fclose(fid)"^(instruction_sep logger)]
    in Loggers.print_newline logger
  | Loggers.Maple ->
    let () =
      print_list logger
        [
          "fid := fopen (\""^data_file^"\",WRITE)"^(instruction_sep logger);
          "fprintf(fid,\"# "^command_line^"\\n\")"^(instruction_sep logger);
          "fprintf(fid,\"# \")"^(instruction_sep logger)]
    in
    let () =
      print_list logger
        (List.rev_map
           (fun x -> "fprintf(fid,\""^x^",\")"^(instruction_sep logger))
           (List.rev titles))
    in
    let () =
      print_list logger
        [
          "fprintf(fid,\"\\n\")"^(instruction_sep logger);
          ("for j from tinit to tend by "^(Ode_loggers_sig.string_of_array_name
                                            Ode_loggers_sig.Period_t_points)^"  do");]
    in
    let () =
      repeat
        (fun _ k ->
           let () =
             Loggers.fprintf
               logger
               "        fprintf(fid,\"%%f,\",eval(obs%i(t),sol(j)))%s" k
               (instruction_sep logger) in
           Loggers.print_newline logger)
        nobs
    in
    let () =
      print_list logger
        [
          "    fprintf(fid,\"\\n\")"^(instruction_sep logger);
          "end"^(instruction_sep logger);
          "fclose(fid)"^(instruction_sep logger)]
    in
    Loggers.print_newline logger
  | Loggers.Mathematica  ->
  let () =
    print_list logger
      [
        "fid = OpenWrite[NotebookDirectory[]<>\""^data_file^"\"]"^(instruction_sep logger);
        "Write[fid,\"# "^command_line^"\\n\"]"^(instruction_sep logger);
        "Write[fid,\"# \"]"^(instruction_sep logger)]
  in
  let () =
    print_list logger
      (List.rev_map
         (fun x -> "Write[fid,\""^x^",\"]"^(instruction_sep logger))
         (List.rev titles))
  in
  let () =
    print_list logger
      [
        "Write[fid,\"\\n\"]"^(instruction_sep logger)
      ]
  in
  let () =
    Loggers.fprintf logger
      "For[j=tinit,j<tend,j=j+period,("
  in
  let () =
    repeat
      (fun _ k ->
         let () =
           Loggers.fprintf
             logger
             "Write[fid,(o%i /. First[sol])[j]]%s" k
             (instruction_sep  logger)
         in
         ())
    nobs
  in
  let () =
    Loggers.fprintf
      logger
      "    Write[fid,\"\\n\"]%s" (instruction_sep logger)
  in
  let () =
    Loggers.fprintf logger
      ")];"
  in
  let () =
    Loggers.print_newline logger
  in
  let () =
    print_list logger
      ["Close[fid]"^(instruction_sep logger)]
  in
  Loggers.print_newline logger
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()


let open_procedure logger name name' arg =
  let format = Loggers.get_encoding_format logger in
  match
    format
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () = Loggers.fprintf logger "function %s=%s(" name name' in
    let _ =
      List.fold_left
        (fun bool s ->
           let () =
             Loggers.fprintf logger "%s%s" (if bool then "," else "") s
           in true)
        false
        arg
    in
    let () = Loggers.fprintf logger ")" in
    Loggers.print_newline logger
  | Loggers.Maple | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()

let return _ _  = ()
let close_procedure logger =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Matlab
  | Loggers.Octave ->
    let () = Loggers.fprintf logger "end" in
    Loggers.print_newline logger
  | Loggers.Maple
  | Loggers.Mathematica
  | Loggers.SBML
  | Loggers.Json
  | Loggers.DOT
  | Loggers.HTML_Graph
  | Loggers.Matrix | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()

let launch_main logger =
  match
    Loggers.get_encoding_format logger
  with
  | Loggers.Octave ->
    let () = Loggers.fprintf logger "main()%s" (instruction_sep logger) in
    Loggers.print_newline logger
  | Loggers.SBML ->
    let () = Loggers.fprintf logger "</model>" in
    let () = Loggers.print_newline logger in
    let () = Loggers.fprintf logger "</sbml>" in
    let () = Loggers.print_newline logger in
    ()
  | Loggers.Matlab
  | Loggers.Mathematica
  | Loggers.Maple
  | Loggers.Json
  | Loggers.DOT
  | Loggers.Matrix | Loggers.HTML_Graph
  | Loggers.HTML
  | Loggers.HTML_Tabular
  | Loggers.TXT
  | Loggers.TXT_Tabular
  | Loggers.XLS -> ()
