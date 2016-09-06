let file = ref ""
let dotCflows = ref true
let none_compression = ref false
let weak_compression = ref false
let strong_compression = ref false

let options = [
  ("--version",
   Arg.Unit (fun () -> Format.print_string Version.version_msg;
              Format.print_newline () ; exit 0),
   "display KaStor version");
  ("-o", Arg.String Kappa_files.set_ccFile,
   "file name skeleton for outputs") ;
  ("-d",
   Arg.String Kappa_files.set_dir,
   "Specifies directory name where output file(s) should be stored");
  ("--none", Arg.Set none_compression, "Outputs uncompressed stories");
  ("--weak", Arg.Set weak_compression, "Outputs weakly compressed stories");
  ("--strong",
   Arg.Set strong_compression,
   "Outputs strongly compressed stories");
  ("--html", Arg.Clear dotCflows, "Print stories in html format");
  ("--time-independent",
   Arg.Set Parameter.time_independent,
   "Disable the use of time is story heuritics (for test suite)")
]

let server_mode () =
  Stream.iter (function
      | `Json (`Assoc ["command", `String "Quit"]) -> ()
      | `Json json ->
        begin
          try
            let env = Environment.of_json (Yojson.Basic.Util.member "env" json) in
            let steps = Trace.of_json (Yojson.Basic.Util.member "trace" json) in
            let none = match Yojson.Basic.Util.to_bool_option
                               (Yojson.Basic.Util.member "none" json)
              with None -> false | Some b -> b in
            let weak = match Yojson.Basic.Util.to_bool_option
                               (Yojson.Basic.Util.member "weak" json)
              with None -> false | Some b -> b in
            let strong = match Yojson.Basic.Util.to_bool_option
                                 (Yojson.Basic.Util.member "strong" json)
              with None -> false | Some b -> b in
            Compression_main.compress_and_print
              ~called_from:Remanent_parameters_sig.Server ~dotFormat:Ast.Html
              ~none ~weak ~strong env (Compression_main.init_secret_log_info ())
              steps
          with Yojson.Basic.Util.Type_error (e,x) ->
            Format.eprintf "%s:@ %s@." e (Yojson.Basic.pretty_to_string x)
        end
      | `Exn (Yojson.Json_error e) -> Format.eprintf "%s@." e
      | `Exn e -> Format.eprintf "%s@." (Printexc.to_string e))
    (Yojson.Basic.linestream_from_channel stdin)

let main () =
  let () =
    Arg.parse
      options
      (fun f -> if !file = "" then file := f else
          let () = Format.eprintf "Deals only with 1 file" in exit 2)
      (Sys.argv.(0) ^
       " trace\n computes stories from 'trace' file generated by KaSim") in
  if!file = "" then
    server_mode ()
  else
    let desc = open_in_bin (!file) in
    let json = Yojson.Basic.from_channel desc in
    let () = close_in desc in
    let env = Environment.of_json (Yojson.Basic.Util.member "env" json) in
    let steps = Trace.of_json (Yojson.Basic.Util.member "trace" json) in
    let (none,weak,strong) =
      if !none_compression || !weak_compression || !strong_compression
      then (!none_compression, !weak_compression, !strong_compression)
      else
        ((match Yojson.Basic.Util.to_bool_option
                  (Yojson.Basic.Util.member "none" json)
          with None -> false | Some b -> b),
         (match Yojson.Basic.Util.to_bool_option
                  (Yojson.Basic.Util.member "weak" json)
          with None -> false | Some b -> b),
         (match Yojson.Basic.Util.to_bool_option
                  (Yojson.Basic.Util.member "strong" json)
          with None -> false | Some b -> b))
    in
    let dot_html = if (!dotCflows) then Ast.Dot else Ast.Html in
    Compression_main.compress_and_print
      ~called_from:Remanent_parameters_sig.KaSim ~dotFormat:dot_html
      ~none ~weak ~strong env (Compression_main.init_secret_log_info ()) steps

let () = main ()
