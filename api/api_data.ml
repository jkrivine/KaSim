(* There are slight differences between the api datatyep as
   and the simulator datatypes.  This class serves to map
   the two implementations.
*)
let plot_pg_store
    ~plot
    ~file
    ~title
    ~descr
  : Pp_svg.store
  = { Pp_svg.file = file;
      Pp_svg.title = title;
      Pp_svg.descr = descr;
      Pp_svg.legend = Array.of_list plot.ApiTypes_j.legend;
      Pp_svg.points =
        List.map
          (fun (observable : ApiTypes_j.observable) ->
             (observable.ApiTypes_j.observation_time ,
              Tools.array_map_of_list
		(fun x -> Nbr.F x) observable.ApiTypes_j.observation_values))
          plot.ApiTypes_j.time_series
    }

let plot_values
    ?(separator : string = ",")
    (plot : ApiTypes_j.plot) : string =
  String.concat "\n"
    ((String.concat
        separator
        ("time"::plot.ApiTypes_j.legend))::
     (List.map
        (fun (observable : ApiTypes_j.observable) ->
           String.concat separator
             (List.map
                (Format.sprintf "%e")
                (observable.ApiTypes_j.observation_time
                 ::observable.ApiTypes_j.observation_values)
             )
        )
        plot.ApiTypes_j.time_series)
    )


let api_file_line (file_line : Data.file_line) : ApiTypes_j.file_line =
  { ApiTypes_j.file_name = file_line.Data.file_name
  ; ApiTypes_j.line = file_line.Data.line
  }

let api_flux_map (flux_map : Data.flux_map) : ApiTypes_j.flux_map =
  { ApiTypes_j.flux_begin_time = flux_map.Data.flux_data.Data.flux_start;
    ApiTypes_j.flux_end_time = flux_map.Data.flux_end ;
    ApiTypes_j.flux_rules = Array.to_list flux_map.Data.flux_rules;
    ApiTypes_j.flux_hits = Array.to_list flux_map.Data.flux_data.Data.flux_hits;
    ApiTypes_j.flux_fluxs =
      List.map
        Array.to_list (Array.to_list flux_map.Data.flux_data.Data.flux_fluxs);
    ApiTypes_j.flux_name = flux_map.Data.flux_data.Data.flux_name
  }

let links_of_mix mix =
  snd @@ snd @@
  List.fold_left
    (fun (i,acc) a ->
       succ i,
       Tools.array_fold_lefti
         (fun j (one,two as acc) ->
            function
            | Raw_mixture.FREE -> acc
            | Raw_mixture.VAL k ->
              match Mods.IntMap.find_option k one with
              | None -> Mods.IntMap.add k (i,j) one,two
              | Some dst ->
                one,Mods.Int2Map.add dst (i,j)
                  (Mods.Int2Map.add (i,j) dst two))
         acc a.Raw_mixture.a_ports)
    (0,(Mods.IntMap.empty,Mods.Int2Map.empty)) mix

let api_mixture sigs mix =
  let links = links_of_mix mix in
  Array.mapi
    (fun i a ->
       { ApiTypes_j.node_quantity = None;
	 ApiTypes_j.node_name =
           Format.asprintf "%a" (Signature.print_agent sigs) a.Raw_mixture.a_type;
	 ApiTypes_j.node_sites =
           Array.mapi
             (fun j s ->
		{ ApiTypes_j.site_name =
                    Format.asprintf
                      "%a" (Signature.print_site sigs a.Raw_mixture.a_type) j;
		  ApiTypes_j.site_links =
                    (match Mods.Int2Map.find_option (i,j) links with
                     | None -> []
                     | Some dst -> [dst]);
		  ApiTypes_j.site_states =
                    (match s with
                     | None -> []
                     | Some k ->
                       [Format.asprintf
			  "%a" (Signature.print_internal_state
				  sigs a.Raw_mixture.a_type j) k;]);
		})
             a.Raw_mixture.a_ints;
       }
    ) (Array.of_list mix)

let api_snapshot sigs (snapshot : Data.snapshot) : ApiTypes_j.snapshot =
  { ApiTypes_j.snap_file = snapshot.Data.snap_file
  ; ApiTypes_j.snap_event = snapshot.Data.snap_event
  ; ApiTypes_j.agents =
      snd
        (List.fold_left
           (fun (old_offset,old_agents) (agent,mixture) ->
              let quantity = Some (float_of_int agent) in
              let mixture = Array.to_list (api_mixture sigs mixture) in
              let new_offset = old_offset + (List.length mixture) in
              let update_links (agent_id,site_id : int * int) =
		(agent_id+old_offset,site_id)
              in
              let update_sites site = { site with
					ApiTypes_j.site_links =
					  List.map
					    update_links
					    site.ApiTypes_j.site_links
				      } in
              let new_agents =
		List.map
                  (fun (node : ApiTypes_j.site_node)->
                     { node with
                       ApiTypes_j.node_quantity = quantity ;
                       ApiTypes_j.node_sites =
			 Array.map
                           update_sites
                           node.ApiTypes_j.node_sites
                     }
                  )
                  mixture
              in
              (new_offset,old_agents@new_agents)
           )
           (0,[])
           snapshot.Data.agents
        )
  ; ApiTypes_j.tokens =
      List.map (fun (token,value) ->
          { ApiTypes_j.node_name = token ;
            ApiTypes_j.node_quantity = Some (Nbr.to_float value);
            ApiTypes_j.node_sites = Array.of_list [] })
        (Array.to_list snapshot.Data.tokens)
  }


let find_link cm (a,s) =
  let rec auxs i j = function
    | [] -> raise Not_found
    | (s',_) :: t ->
      if s = s' then
        (i,j)
      else
        auxs i (succ j) t
  in
  let rec auxa i = function
    | [] -> raise Not_found
    | (a',l) :: t ->
      if a = a' then
        auxs i 0 l
      else auxa (succ i) t
  in
  auxa 0 cm

let api_contact_map sigs cm =
  Array.mapi
    (fun ag sites ->
       { ApiTypes_j.node_quantity = None;
	 ApiTypes_j.node_name =
           Format.asprintf "%a" (Signature.print_agent sigs) ag;
	 ApiTypes_j.node_sites =
           Array.mapi
             (fun site (states,links) ->
		{ ApiTypes_j.site_name =
                    Format.asprintf "%a" (Signature.print_site sigs ag) site;
		  ApiTypes_j.site_links = links;
		  ApiTypes_j.site_states =
                    List.map
                      (Format.asprintf
                         "%a"
                         (Signature.print_internal_state sigs ag site))
                      states;
		}) sites;
       }) cm

let api_contactmap_site_graph
    (contactmap : ApiTypes_j.parse) : ApiTypes_j.site_graph =
  contactmap.ApiTypes_j.contact_map

let offset_site_graph
    (offset : int)
    (site_nodes : ApiTypes_j.site_node list) :
  ApiTypes_j.site_node list =
  List.map
    (fun site_node ->
       { site_node with
         ApiTypes_j.node_sites =
           Array.map
             (fun site ->
		{ site with
                  ApiTypes_j.site_links =
                    List.map (fun (i,j) -> (i+offset,j+offset))
                      site.ApiTypes_j.site_links })
             site_node.ApiTypes_j.node_sites
       }
    )
    site_nodes

let api_snapshot_site_graph
    (snapshot : ApiTypes_j.snapshot) : ApiTypes_j.site_graph =
  Array.of_list
    (List.concat
       [snapshot.ApiTypes_j.agents;
        let offset = List.length snapshot.ApiTypes_j.agents in
        offset_site_graph offset snapshot.ApiTypes_j.tokens])

(* map out *)
let normalize_edge
    ((l,r) : (int * int) * (int * int)) : (int * int) * (int * int) =
  if (l < r) then (l,r) else (r,l)

module EdgeMap =
  Map.Make(struct type t = (int * int) * (int * int)
    let compare = compare
  end)
module EdgeSet =
  Set.Make(struct type t = (int * int) * (int * int)
    let compare =
      fun l r ->
        compare
          (normalize_edge l)
          (normalize_edge r)
  end)
let hash_color (l : string) : string =
  Format.sprintf "#%0x" ((Hashtbl.hash l) mod 0xffffff)

type site_node_component = { index : int ;
                             site_node : ApiTypes_t.site_node ;
                             mutable component_id : int }

let api_snapshot_dot (snapshot : ApiTypes_j.snapshot) =
  let site_nodes : ApiTypes_t.site_node list =
    Array.to_list
      (api_snapshot_site_graph snapshot)
  in
  let components_index : site_node_component list =
    List.mapi
      (fun index site_node ->
         { index = index ;
           site_node = site_node;
           component_id = index })
      site_nodes
  in
  let update_site
      (new_component_id : int)
      (location : int) : unit =
    let old_component_id : int =
      (List.nth components_index location).component_id
    in
    List.iter
      (fun site_node_component ->
         if site_node_component.component_id = old_component_id then
           site_node_component.component_id <- new_component_id
         else
           ()
      )
      components_index
  in
  (* list of id's of connected components *)
  let components_ids : int list =
    Mods.IntSet.elements
      (List.fold_left
         (fun set elem -> Mods.IntSet.add elem set)
         Mods.IntSet.empty
         (List.map (fun c -> c.component_id) components_index))
  in
  (* get site node by component it is in *)
  let agent_components id : ApiTypes_j.site_node list =
    let components =
      List.filter
        (fun s -> s.component_id = id)
        components_index
    in
    (* Figure out mapping from global id's to
       id's that are local to the compoents.
    *)
    let local_index : (int * int) list =
      List.mapi (fun i c -> (c.index,i)) components
    in
    (* Remaps the agent id's to that they are
       relative to the connected component.
    *)
    List.map
      (fun c ->
         { c.site_node  with
           ApiTypes_j.node_sites =
             Array.map
               (fun site ->
                  { site with
                    ApiTypes_j.site_links =
                      List.map
                        (fun (agent,site) ->
                           (List.assoc agent local_index,site))
                        site.ApiTypes_j.site_links })
               c.site_node.ApiTypes_j.node_sites })
      components
  in
  let () =
    List.iteri
      (fun index site_node ->
         Array.iter
           (fun (site : ApiTypes_j.site) ->
              List.iter
		(update_site index)
		(List.map fst site.ApiTypes_j.site_links)
           )
           site_node.ApiTypes_j.node_sites
      )
      site_nodes
  in
  let b = Buffer.create 1024 in
  let f = Format.formatter_of_buffer b in
  let format_sites
      ppf
      ((component_id,components) : int * ApiTypes_j.site_node list) =
    let site_label agent site : string =
      (Array.get
         (List.nth components agent).ApiTypes_j.node_sites
         site).ApiTypes_j.site_name
    in
    let links : ((int * int)* (int * int)) list =
      List.flatten
        (List.mapi
           (fun source_agent_id site_node ->
              (List.flatten
                 (List.mapi
                    (fun source_site_id site ->
                       List.map
                         (fun (target_agent_id,target_site_id) ->
                            ((source_agent_id,source_site_id),
                             (target_agent_id,target_site_id))
                         ) site.ApiTypes_j.site_links)
                    (Array.to_list site_node.ApiTypes_j.node_sites))))
           components)
    in
    let deduplicated_links : ((int * int)* (int * int)) list =
      EdgeSet.elements
        (List.fold_left
           (fun set edge -> EdgeSet.add edge set)
           EdgeSet.empty
           links)
    in
    (Pp.listi
       Pp.cut
       (fun index f site_node ->
          let site_label : string =
            String.concat
              ","
              (List.map (fun site -> site.ApiTypes_j.site_name
                                     ^
                                     (String.concat
                                        ""
                                        (List.map
                                           (fun label -> "~"^label)
                                           site.ApiTypes_j.site_states)
                                     )
                        )
                 (Array.to_list site_node.ApiTypes_j.node_sites))
          in
            Format.fprintf
              f
              "node%d_%d [label = \"@[<h>%s@]\", color = \"%s\", style=filled];"
              component_id
              index
              (site_node.ApiTypes_j.node_name^"("^site_label^")")
              (hash_color site_node.ApiTypes_j.node_name)
       )
    )
    ppf
    components;
    (Format.fprintf f "@,");
    (Pp.list
       Pp.cut
       (fun f ((source_agent,source_site),(target_agent,target_site)) ->
            Format.fprintf
              f
              "node%d_%d -> node%d_%d [taillabel=\"%s\", headlabel=\"%s\", dir=none];"
              component_id
              source_agent

              component_id
              target_agent

              (site_label source_agent source_site)
              (site_label target_agent target_site)
       )
    )
    ppf
    deduplicated_links;
    (Format.fprintf f (match deduplicated_links with [] -> "" | _ -> "@,"));
  in
  let format_components
      ppf
      (component_ids : int list) =
    (Pp.list
       Pp.cut
       (fun f component_id ->
          let components : ApiTypes_j.site_node list =
            agent_components component_id
          in
          match components with
          | { ApiTypes_j.node_quantity = Some node_quantity
            ; _ }::_ ->
            Format.fprintf
              f
              "@[<v 2>subgraph cluster%d{@,"
              component_id;
            Format.fprintf
              f
              "counter%d [label = \"%.0f instance(s)\", shape=none];@,%a}@]"
              component_id
              node_quantity
              format_sites
              (component_id,components)
          | _ -> Format.fprintf f ""))
    ppf
    component_ids
  in
  let format_tokens ppf (tokens : ApiTypes_t.site_node list) =
    (Pp.listi Pp.cut (fun i f (site_node : ApiTypes_t.site_node) ->
         Format.fprintf
           f
           "token_%d [label = \"%s %s \" , shape=none]"
           i
           site_node.ApiTypes_t.node_name
           (match site_node.ApiTypes_t.node_quantity with
            | Some f -> Format.sprintf "(%.0f)" f
            | None -> "")
       ))
      ppf
      tokens
  in
  let () = Format.fprintf
      f "@[<v>digraph G{@,%a@,%a}@]"
      format_components (List.sort (fun a b -> a - b) components_ids)
      format_tokens snapshot.ApiTypes_j.tokens
  in
  let () = Format.pp_print_flush f () in
  Buffer.contents b



let api_snapshot_kappa (snapshot : ApiTypes_j.snapshot) =
  (*let () = print_string (ApiTypes_j.string_of_snapshot snapshot) in *)
(*
  let format_edge
      (label : string)
      (((a,b),(c,d)) : (int * int) * (int * int)) : string =
    Format.sprintf
      "\n%s ((%d,%d),(%d,%d))\n"
      label a b c d
  in

  let debug_edge
      (label : string)
      (edge : (int * int) * (int * int)) : unit =
    print_string
      (format_edge label edge)
  in
*)

  let site_nodes : ApiTypes_t.site_node list =
    Array.to_list (api_snapshot_site_graph snapshot)
  in
  let components_index : (int * ApiTypes_t.site_node) array =
    Array.of_list
      (List.mapi (fun index site_node -> (index,site_node)) site_nodes)
  in
  let edge_index : int EdgeMap.t =
    List.fold_left
      (fun
        (index : int EdgeMap.t)
        ((agent_id,site_node) : int * ApiTypes_t.site_node) ->
        let offset : int = EdgeMap.cardinal index in
        let index_edges : (int * ((int * int) * (int * int))) list =
          List.mapi
            (fun i edge -> (i + offset,edge))
            (List.flatten
               (List.mapi
                  (fun
                    (site_id : int)
                    (site : ApiTypes_t.site) ->
                    List.map
                      (fun link -> ((agent_id,site_id),link))
                      site.ApiTypes_t.site_links
                  )
                  (Array.to_list site_node.ApiTypes_t.node_sites)
               )
            )
        in
        List.fold_left
          (fun
            (local_index : int EdgeMap.t)
            ((key,edge) : (int * ((int * int) * (int * int))))
            ->
              let edge = normalize_edge edge in
              if EdgeMap.mem edge local_index then
                local_index
              else
                (*
                let () =
                  print_string
                    (format_edge ((string_of_int key)^"!>") edge)
                in
                *)
                EdgeMap.add
                  edge
                  key
                  local_index
          )
          index
          index_edges
      )
      EdgeMap.empty
      (Array.to_list components_index)
  in
  (*
  let () =
    EdgeMap.iter
      (fun key value ->
        print_string
          (format_edge ((string_of_int value)^"->") key))
      edge_index
  in
  *)
  (* let () = print_string "(EdgeMap.cardinal edge_index)" in *)
  (* let () = print_int (EdgeMap.cardinal edge_index) in *)
  (* index the connected components *)
  let update_site
      (new_component_id : int)
      (location : int) : unit =
    let old_component_id : int =
      fst (Array.get components_index location)
    in
    Array.iteri
      (fun i (current_component_id,current_site_node) ->
         if current_component_id = old_component_id then
           Array.set
             components_index
             i
             (new_component_id,current_site_node)
         else
           ()
      )
      components_index
  in
  (* list of id's of connected components *)
  let components_ids : int list =
    Mods.IntSet.elements
      (List.fold_left
         (fun set elem -> Mods.IntSet.add (fst elem) set)
         Mods.IntSet.empty
         (Array.to_list components_index))
  in
  (* get components *)
  let agent_components id : (int * ApiTypes_t.site_node) list =
    List.map
      snd
      (List.filter
         fst
         (List.mapi
            (fun index (component_id,site_node) ->
               (component_id = id,(index,site_node))
            )
            (Array.to_list components_index)
          : (bool * (int * ApiTypes_t.site_node)) list)
       : (bool * (int * ApiTypes_t.site_node)) list)
  in
  let render_agent (_,(site_node : ApiTypes_t.site_node)) : string =
    let agent_label  = site_node.ApiTypes_t.node_name in
    let site_label =
      String.concat
        ","
        (List.map
           (fun site_node -> site_node.ApiTypes_t.site_name)
           (Array.to_list site_node.ApiTypes_t.node_sites))
    in
    Format.sprintf "%s(%s)" agent_label site_label in
  let render_component
      (connected_component : (int * ApiTypes_t.site_node) list) : string =
    String.concat
      ","
      (List.map
         (fun (agent_id,site_node) ->
            let agent_label = site_node.ApiTypes_t.node_name in
            let site_label =
              String.concat
		","
		(List.mapi
                   (fun site_id site_node ->
                      site_node.ApiTypes_t.site_name
                      ^
                      (String.concat
                         ""
                         (List.map
                            (fun link ->
                               let edge_id : (int * int) * (int * int) =
                                 normalize_edge
                                   ((agent_id,site_id),link)
                               in
                               (* let () = debug_edge "lookup" edge_id in *)
                               let link_id : int =
                                 EdgeMap.find
                                   edge_id
                                   edge_index
                               in
(*
                              let () =
                                debug_edge
                                  (string_of_int link_id)
                                  edge_id
                              in
*)
                               "!"^(string_of_int link_id)
                            )
                            site_node.ApiTypes_t.site_links))
                   )
                   (Array.to_list site_node.ApiTypes_t.node_sites))
            in
            Format.sprintf "%s(%s)" agent_label site_label
         )
         connected_component
      )
  in
  let () =
    List.iteri
      (fun index site_node ->
         Array.iter
           (fun (site : ApiTypes_j.site) ->
              List.iter
		(update_site index)
		(List.map fst site.ApiTypes_j.site_links)
           )
           site_node.ApiTypes_j.node_sites
      )
      site_nodes
  in
  String.concat
    "\n"
    (List.fold_left
       (fun
         (kappa_fragments : string list)
         (component : (int * ApiTypes_t.site_node) list) ->
         match component with
         | (_,{ ApiTypes_j.node_quantity = Some node_quantity
              ; _ })::tail ->
           (Format.sprintf "%%init: %f %s"
              node_quantity
              (match tail with
               | [] -> render_agent (List.hd component)
               | _ -> render_component component))::kappa_fragments
         | _ -> kappa_fragments

       )
       []
       (List.map
          agent_components
          components_ids))

let api_parse_is_empty (parse : ApiTypes_j.parse) =
  0 = Array.length parse.ApiTypes_j.contact_map

let api_message_errors
    ?(severity:ApiTypes_j.severity = `Error)
    (message : string) : ApiTypes_j.errors =
  [{ ApiTypes_j.severity = severity;
     ApiTypes_j.message = message ;
     ApiTypes_j.range = None }]

let api_location_errors
    ?(severity:ApiTypes_j.severity = `Error)
    ((message,location) : string Location.annot) =
  [{ ApiTypes_j.severity = severity;
     ApiTypes_j.message = message ;
     ApiTypes_j.range = Some (Location.to_range location) }]

let api_exception_errors (e : exn) =
  api_message_errors (Printexc.to_string e)

let lwt_msg (msg : string) =
  Lwt.return
    (`Left (api_message_errors msg))
let lwt_bind
    (f : 'a -> 'b ApiTypes_j.result Lwt.t)
    (result : 'a ApiTypes_j.result)
  : 'b ApiTypes_j.result Lwt.t =
  match result with
    `Left l -> Lwt.return (`Left l)
  | `Right r -> (f r)
let lwt_ignore (result : 'a ApiTypes_j.result) =
  match result with
    `Left _l -> Lwt.return_unit
  | `Right _r -> Lwt.return_unit

let eq_position l r =
  l.ApiTypes_j.chr = r.ApiTypes_j.chr
  &&
  l.ApiTypes_j.line = r.ApiTypes_j.line
let eq_range l r =
  match(l,r) with
  | (None,None) -> true
  | (Some l,Some r) ->
    eq_position l.ApiTypes_j.from_position r.ApiTypes_j.from_position
    && eq_position l.ApiTypes_j.to_position r.ApiTypes_j.to_position
  | _ -> false
let rec eq_errors  l r =
  match (l,r) with
  | ([],[]) -> true
  | (l::l_tail,r::r_tail) ->
    l.ApiTypes_j.message = r.ApiTypes_j.message
    && eq_range l.ApiTypes_j.range r.ApiTypes_j.range
    && eq_errors l_tail r_tail
  | _ -> false
