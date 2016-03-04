open Lwt
open XmlHttpRequest
module WebMessage = WebMessage_j
module ApiTypes = ApiTypes_j

exception BadResponseCode of int
exception TimeOut

let hydrate (type a)
            (frame:((Js.js_string Js.t) XmlHttpRequest.generic_http_frame))
            (success:(string -> a))
            (fail:(string -> ApiTypes.error))
    : a ApiTypes_j.result Lwt.t =
     if frame.code = 200 then
       Lwt.return (`Right (success (Js.to_string frame.content)))
     else if frame.code = 400 then
       Lwt.return (`Left (fail (Js.to_string frame.content)))
     else
       Lwt.fail (BadResponseCode frame.code)

let post (timeout : float)
         (data : string)
         (url : string) : string  Lwt.t =
    let var : string option Lwt_mvar.t = Lwt_mvar.create_empty () in
    let () = Lwt.async (fun () -> Lwt_js.sleep timeout >>= (fun _ -> Lwt_mvar.put var None)) in
    let request : XmlHttpRequest.xmlHttpRequest Js.t = XmlHttpRequest.create() in
    let () = request##_open(Js.string "POST",Js.string url, Js._true) in
    let () = request##setRequestHeader (Js.string "Content-type"
                                       ,Js.string "application/x-www-form-urlencoded") in
    let () = request##onload <- Dom.handler
                                (fun e -> let () = Lwt.async (fun () -> Lwt_mvar.put var (Some (Js.to_string request##responseText))) in
                                          Js._true)
    in
    let () = request##send(Js.some (Js.string data)) in
    (Lwt_mvar.take var)
    >>=
    (fun response -> match response with
                       None -> Lwt.fail TimeOut
                     | Some response -> Lwt.return response)

class runtime ?(timeout:float = 10.0) (url:string) =
object(self)

  method parse (code : ApiTypes.code) : ApiTypes_j.parse ApiTypes_j.result Lwt.t =
    let url : string = Format.sprintf "%s/v1/parse" url  in
    (XmlHttpRequest.perform_raw
       ~get_args:[("code",code)]
       ~override_method:`GET
       ~response_type:Text
       url)
    >>=
      (fun frame -> hydrate frame
                            ApiTypes.parse_of_string
                            ApiTypes.error_of_string)

  method start (parameter : ApiTypes.parameter) : ApiTypes.token ApiTypes.result Lwt.t =
    let url : string = Format.sprintf "%s/v1/process" url in
    (post timeout (ApiTypes.string_of_parameter parameter) url)
    >>=
      (fun response -> Lwt.return (ApiTypes.result_of_string ApiTypes.read_token response))

  method status (token : ApiTypes.token) : ApiTypes.state ApiTypes.result Lwt.t =
    let url : string = Format.sprintf "%s/v1/process/%d" url token  in
    (XmlHttpRequest.perform_raw
       ~get_args:[]
       ~override_method:`GET
       ~response_type:Text
       url)
    >>=
      (fun frame -> hydrate frame
                            ApiTypes.state_of_string
                            ApiTypes.error_of_string)

  method list () : ApiTypes.catalog ApiTypes.result Lwt.t =
    let url : string = Format.sprintf "%s/v1/process" url in
    (XmlHttpRequest.perform_raw
       ~get_args:[]
       ~override_method:`GET
       ~response_type:Text
       url)
    >>=
      (fun frame -> hydrate
                      frame
                      ApiTypes.catalog_of_string
                      ApiTypes.error_of_string)

  method stop (token : ApiTypes.token) : unit ApiTypes.result Lwt.t =
    let url : string = Format.sprintf "%s/v1/process/%d" url token in
    (XmlHttpRequest.perform_raw
       ~get_args:[]
       ~override_method:`DELETE
       ~response_type:Text
       url)
    >>=
      (fun frame -> hydrate
                      frame
                      ApiTypes.alias_unit_of_string
                      ApiTypes.error_of_string)
end;;
