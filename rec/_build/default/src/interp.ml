open Ast
open Ds


let rec apply_clos : string*Ast.expr*env -> exp_val -> exp_val ea_result =
  fun (id,e,en) ev ->
  return en >>+
  extend_env id ev >>+
  eval_expr e
and
  eval_expr : expr -> exp_val ea_result = fun e ->
  match e with
  | Int(n) -> return (NumVal n)
  | Var(id) -> apply_env id
  | Add(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    return (NumVal (n1+n2))
  | Sub(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    return (NumVal (n1-n2))
  | Mul(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    return (NumVal (n1*n2))
  | Div(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    if n2==0
    then error "Division by zero"
    else return (NumVal (n1/n2))
  | Let(v,def,body) ->
    eval_expr def >>= 
    extend_env v >>+
    eval_expr body 
  | ITE(e1,e2,e3) ->
    eval_expr e1 >>=
    bool_of_boolVal >>= fun b ->
    if b 
    then eval_expr e2
    else eval_expr e3
  | IsZero(e) ->
    eval_expr e >>=
    int_of_numVal >>= fun n ->
    return (BoolVal (n = 0))
  | Pair(e1,e2) ->
    eval_expr e1 >>= fun ev1 ->
    eval_expr e2 >>= fun ev2 ->
    return (PairVal(ev1,ev2))
  | Fst(e) ->
    eval_expr e >>=
    pair_of_pairVal >>= fun p ->
    return (fst p) 
  | Snd(e) ->
    eval_expr e >>=
    pair_of_pairVal >>= fun p ->
    return (snd p)
  | Proc(id,e)  ->
    lookup_env >>= fun en ->
    return (ProcVal(id,e,en))
  | App(e1,e2)  -> 
    eval_expr e1 >>= 
    clos_of_procVal >>= fun clos ->
    eval_expr e2 >>= 
    apply_clos clos 
  | Letrec(id,par,e1,e2) ->
    extend_env_rec id par e1 >>+
    eval_expr e2
  | EmptyList ->
    return (ListVal [])
  | Cons(e1,e2) ->
    eval_expr e1 >>= fun v ->
    eval_expr e2 >>=
    list_of_listVal >>= fun l ->
    return (ListVal (v::l))
  | Hd(e) ->
    eval_expr e >>=
    list_of_listVal >>= (function
     | [] -> error "hd: empty list"
     | h::_ -> return h)
  | Tl(e) ->
    eval_expr e >>=
    list_of_listVal >>= (function
     | [] -> error "tl: empty list"
     | _::t -> return (ListVal t))
  | IsEmpty(e) ->
    eval_expr e >>=
    list_of_listVal >>= fun l ->
    return (BoolVal (l=[]))
 | Debug(_e) ->
    string_of_env >>= fun str ->
    print_endline str; 
    error "Debug called"
  | _ -> failwith "Not implemented yet!"

(** [parse s] parses string [s] into an ast *)
let parse (s:string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


(** [interp s] parses [s] and then evaluates it *)
let interp (s:string) : exp_val result =
  let c = s |> parse |> eval_expr
  in run c

let read_file (filename:string) : string = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true do
      lines := input_line chan :: !lines
    done;
    "" (* never reaches this line *)
  with End_of_file ->
    close_in chan;
    String.concat "" (List.rev !lines)

(* Parse an expression read from a file with optional extension .sool *)
let parsef (s:string) : expr = 
  let s = String.trim s      (* remove leading and trailing spaces *)
  in let file_name =    (* allow rec to be optional *)
       match String.index_opt s '.' with None -> s^".rec" | _ -> s
  in
  parse @@ read_file file_name


(* Interpret an expression read from a file with optional extension .sool *)
let interpf (s:string) : exp_val result = 
  let s = String.trim s      (* remove leading and trailing spaces *)
  in let file_name =    (* allow rec to be optional *)
       match String.index_opt s '.' with None -> s^".rec" | _ -> s
  in
  interp @@ read_file file_name

