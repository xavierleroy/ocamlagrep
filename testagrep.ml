(* Test harness *)

open Printf

let _ =
  let numerrs = ref 0
  and wholeword = ref false
  and verbatim = ref false
  and pattern = ref None in
  Arg.parse
    ["-1", Arg.Unit(fun () -> numerrs := 1), "  one error";
     "-2", Arg.Unit(fun () -> numerrs := 2), "  two error";
     "-3", Arg.Unit(fun () -> numerrs := 3), "  three error";
     "-e", Arg.Int(fun n -> numerrs := n), "<n>  n errors";
     "-w", Arg.Set wholeword, "  match entire words";
     "-v", Arg.Set verbatim,  "  match string verbatim (no special chars)"]
    (fun s ->
      match !pattern with
        None ->
          pattern := Some(if !verbatim then Agrep.pattern_string s
                                       else Agrep.pattern s)
      | Some p ->
          let n = Agrep.errors_substring_match p
                    ~numerrs:!numerrs ~wholeword:!wholeword
                    s ~pos:0 ~len:(String.length s) in
          if n = max_int
          then printf "No match"
          else printf "Match (%d error(s))" n;
          print_newline())
    ""
