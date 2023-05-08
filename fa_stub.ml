
(* ******************************************** *)
(** Basic functions on finite automata *)
(* ******************************************** *)
(**
   Code stub for assignment 1

   Pranav Yalamala
   I pledge my honor that I have abided by the Steven's Honor System.
*)

type symbol = char
type input = char list

type state = string

(* transition function *)
type tf = (state * symbol * state) list

(* initial state * transition function * end state *)
type fa = { states: state list; start:state; tf: tf; final: state list}


(* ******************************************** *)
(* Examples of automata *)
(* ******************************************** *)

let a = {states = ["q0";"q1";"q2"];
         start = "q0";
         tf = [("q0",'a',"q1"); ("q1",'b',"q1"); ("q1",'c',"q2")];
         final = ["q2"]}

let a2 = {states = ["q0";"q1";"q2";"q3";"q4"];
          start = "q0";
          tf = [("q0",'a',"q1"); ("q1",'b',"q1")
               ; ("q1",'c',"q2");  ("q3",'a',"q4")];
          final= ["q2"]
         }
let tf_of_a = [("q0",'a',"q1"); ("q1",'b',"q1"); ("q1",'c',"q2")]



(* ******************************************** *)
(* Helper functions *)
(* ******************************************** *)

let input_of_string s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []


(* ******************************************** *)
(* Simulating automata *)
(* ******************************************** *)

let rec apply_transition_function : tf -> state -> symbol -> state option = 
  fun f st sym ->
  match f with
  | [] -> None
  | (x,y,z) :: t ->
  if x=st && y=sym
  then Some z
  else apply_transition_function t st sym

let rec accept_helper ft s st= 
  match s with 
  | [] -> Some st
  | h::t ->
  match apply_transition_function ft st h with
  | None -> None
  | Some x -> accept_helper ft t x


let accept : fa -> input -> bool =
  fun f s ->
  match s with
  | [] -> true
  | h::t -> 
  match accept_helper f.tf s f.start with
  |None -> false
  |Some x when List.mem x f.final -> true
  |Some x -> false

let rec next : tf -> state -> symbol -> state list =
  fun f st sym ->
  match f with
  | [] -> []
  | (x,y,z) :: t ->
  if x=st && y=sym
  then z:: next t z sym
  else next t st sym

let rec deterministic_helper ft =
match ft with
| [] -> true
| (x,y,z)::t ->
if List.length(next ft x y)=1 && deterministic_helper t
then true
else false


let deterministic : fa-> bool = 
  fun f ->
  deterministic_helper f.tf

let rec check_states lst st = 
match lst with
| [] -> false
| h::t ->
if h=st
then true
else
check_states t st

let rec check_states_l lst list =
match list with
| [] -> true
| h::t -> check_states lst h && check_states_l lst t

let valid : fa-> bool =
  fun f ->
  if (deterministic f)=false || (check_states f.states f.start)=false || (check_states_l f.states f.final)=false
  then false
  else true

let rec map f lst = 
match lst with
| [] -> []
| h::t -> f h:: map f t

let rec next_a : tf -> state -> state list =
  fun f st ->
  match f with
  | [] -> []
  | (x,y,z) :: t ->
  if x=st && x<>z
  then z:: next_a t z
  else next_a t st

let rec reachable_helper f current lst =
match current with
| [] -> lst
| h::t -> if List.mem h lst
then reachable_helper f t lst
else reachable_helper f (t @ (next_a f.tf h)) (lst @ [h])

let reachable : fa -> state list=
  fun f ->
  reachable_helper f [f.start] []

let rec check_states_r lst list =
match list with
| [] -> []
| h::t -> 
if check_states lst h
then h::check_states_r lst t 
else check_states_r lst t 

let rec check_tf lst ft=
match ft with
| [] -> []
| (x,y,z)::t ->
if (check_states lst x) && (check_states lst z)
then (x,y,z)::check_tf lst t
else check_tf lst t

let remove_dead_states : fa -> fa=
  fun f->
  

  {states = reachable f;
         start = f.start;
         tf = check_tf (reachable f) f.tf ;
         final = check_states_r (reachable f) f.final}