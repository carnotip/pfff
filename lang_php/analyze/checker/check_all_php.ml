(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

open Common

open Ast_php

module E = Error_php

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(*****************************************************************************)
(* Main entry points *)
(*****************************************************************************)

let check_file ?(find_entity=None) file =

  let ast = Parse_php.parse_program file in

  Check_variables_php.check_and_annotate_program ~find_entity ast;
  Check_cfg_php.check_program ~find_entity ast;
  (* not ready yet
  Check_dfg_php.check_program ?find_entity ast;
  *)

  (* work only when find_entity is not None; requires global analysis *)
  if find_entity <> None then begin
    let ast = Unsugar_php.unsugar_self_parent_program ast in
    Check_functions_php.check_program ~find_entity ast;
    Check_classes_php.check_program ~find_entity ast;
  end;

  (* TODO:
     Checking_php.check_program ast;
     Check_scope_use_php.check_program ast;
  *)
  ()
