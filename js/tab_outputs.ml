(******************************************************************************)
(*  _  __ * The Kappa Language                                                *)
(* | |/ / * Copyright 2010-2017 CNRS - Harvard Medical School - INRIA - IRIF  *)
(* | ' /  *********************************************************************)
(* | . \  * This file is distributed under the terms of the                   *)
(* |_|\_\ * GNU Lesser General Public License Version 3                       *)
(******************************************************************************)

module Html = Tyxml_js.Html5
open Lwt.Infix


let select_id = "output-select-id"
let export_id = "output-export"

let current_file, set_current_file =
  React.S.create (None : Api_types_j.file_line_detail option)

let update_outputs (t : Ui_simulation.t) key : unit =
  let file_line_info_id = if key = "/dev/stdout" then None else Some key in
  Ui_simulation.manager_operation
    t
    (fun
      manager
      project_id
      simulation_id ->
      (manager#simulation_detail_file_line
         project_id
         simulation_id
         file_line_info_id
      ) >>=
      (Api_common.result_map
         ~ok:(fun _ (file_line_detail : Api_types_j.file_line_detail) ->
             let () = set_current_file (Some file_line_detail) in
             Lwt.return_unit
           )
         ~error:(fun _ errors  ->
             let () = Ui_state.set_model_error __LOC__ errors in
             Lwt.return_unit)
      )
    )

let file_count = function
  | None -> 0
  | Some state ->
    state.Api_types_t.simulation_info_output.Api_types_t.simulation_output_file_lines
(* Careful this defaults to None which a valid file identifier.
   The idea is to always give a valid file identifier.
 *)
let get_file_line_id
    (file : Api_types_j.file_line_detail) : Api_types_j.file_line_id =
  match file with
  | h::_ -> h.Api_types_j.file_line_name
  | [] -> None

let navli (t : Ui_simulation.t) =
  Ui_common.badge t (fun state -> (file_count state))

let content (t : Ui_simulation.t) =
  let simulation_output = (Ui_simulation.simulation_output t) in
  let select file_line_info =
    let file_ids : Api_types_j.file_line_id list =
      file_line_info.Api_types_j.file_line_ids in
    let file : Api_types_j.file_line_detail option = React.S.value current_file in
    let current_file_id : Api_types_j.file_line_id =
      (match (file_ids,file) with
       | (f::_,None) -> f
       | (_::_,Some file) -> get_file_line_id file
       | _ -> None) in
    let file_options =
      List.map
        (fun key ->
           Html.option
             ~a:([ Html.a_value (Tools.unsome "/dev/stdout" key)]@
                 (if (key = current_file_id) then
                    [Html.a_selected ()]
                  else  []))
             (Html.pcdata (Ui_common.option_label (Tools.unsome "" key))))
        file_ids in
    let () = update_outputs t (Tools.unsome "/dev/stdout" current_file_id) in
    Tyxml_js.Html.select
      ~a:[ Html.a_class ["form-control"] ; Html.a_id select_id ]
      file_options in
  let file_select =
    Tyxml_js.R.Html.div
      ~a:[ Html.a_class ["list-group-item"] ]
      (let list, handle = ReactiveData.RList.create [] in
       let _ = React.S.map
           (fun _ ->
              Ui_simulation.manager_operation
                t
                (fun
                  manager
                  project_id
                  simulation_id ->
                  (manager#simulation_info_file_line
                     project_id
                     simulation_id
                  ) >>=
                  (Api_common.result_map
                     ~ok:(fun _ (file_line_info : Api_types_j.file_line_info) ->
                         let () = ReactiveData.RList.set
                             handle
                             (match file_line_info.Api_types_j.file_line_ids with
                              | [] -> []
                              | key::[] ->
                                let () = update_outputs
                                    t (Tools.unsome "/dev/stdout" key) in
                                [Html.h4
                                   [ Html.pcdata
                                       (Ui_common.option_label
                                          (Tools.unsome "" key)
                                       )]]
                              | _ :: _ :: _ -> [select file_line_info])
                         in
                         Lwt.return_unit
                       )
                     ~error:(fun _ errors  ->
                         let () = Ui_state.set_model_error __LOC__ errors in
                         Lwt.return_unit)
                  )
                )
           )
           simulation_output in
       list
      )
  in
  let file_content =
    [Tyxml_js.R.Html.div
       (ReactiveData.RList.from_signal
          (React.S.map
             (fun (file : Api_types_j.file_line_detail option) ->
                match file with
                | None -> []
                | Some lines ->
                  List.rev_map (fun line ->
                      Html.p [ Html.pcdata line.Api_types_j.file_line_text ]) lines)
             current_file))] in
  [ [%html {|<div class="navcontent-view">
             <div class="row">
             <div class="center-block display-header">
           |}[file_select]{|
                   </div>
                </div>
             |}file_content{|
             </div> |}] ]

let select_outputs (t : Ui_simulation.t) =
  Js.Opt.case
    (Ui_common.document##getElementById (Js.string select_id))
    (fun () -> ())
    (fun dom ->
       let select_dom : Dom_html.inputElement Js.t =
         Js.Unsafe.coerce dom in
       let fileindex = Js.to_string (select_dom##.value) in
       update_outputs t fileindex)

let navcontent (t : Ui_simulation.t) =
  [ Ui_common.toggle_element t (fun t -> file_count t > 0) (content t) ]

let onload (t : Ui_simulation.t) =
  let () =
    Common.jquery_on
      (Format.sprintf "#%s" select_id)
      ("change")
      (fun _ ->
         let () = select_outputs t in Js._true)
  in  ()
  (* TODO
  let select_dom : Dom_html.inputElement Js.t =
    Js.Unsafe.coerce
      ((Js.Opt.get
          (Ui_common.document##getElementById
             (Js.string select_id))
          (fun () -> assert false))
       : Dom_html.element Js.t) in
  let () = select_dom##.onchange := Dom_html.handler
(fun _ ->
   let () = select_outputs t
  in Js._true)
  in
     *)

let onresize (_ : Ui_simulation.t) : unit = ()
