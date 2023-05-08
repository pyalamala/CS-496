

(* Fruit basket processors *)

type fruit = A | O | K
type fbasket = fruit list
let fb1 = [A;A;O;O;O;A;A;K;K;O]
let fb2 = []

type 'a result = Ok of 'a | Error of string

(* An expression whose type is an instance of

    fbasket -> 'a result

   is called a fruit basket processor (fbp) *)

(* Exercise 1. Define a fbp that counts the number of apples.
   Note that this particular fbp does not return an error *)

let rec no_of_apples : fbasket -> int result =
  fun fb ->
  Ok (List.length (List.filter (fun f -> f=A) fb))

  let rec no_of_oranges : fbasket -> int result =
  fun fb ->
  Ok (List.length (List.filter (fun f -> f=O) fb))

  let rec no_of_kiwis : fbasket -> int result =
  fun fb ->
  Ok (List.length (List.filter (fun f -> f=K) fb))

   (*Excercise2. Define a fbp that checks if there are oranges
   Note that this particular fbp does not return an error*)
  
  let has_oranges : fbasket -> bool result =
  fun fb ->
  if (no_of_oranges fb)=Ok (0)
  then Ok false
  else Ok true

  let orange_apple_ratio =
  fun fb-> 
  let noa = List.length (List.filter (fun f -> f=A) fb) and
  noo = List.length (List.filter (fun f -> f=O) fb)
  in
  if noa=0
  then Error "no apples"
  else Ok (noo / noa)

  
   (*Excercise 3. Define a fbp that removes an orange
   It should return an error if there are none*)

  let rec remove_orange_helper =
  fun fb-> 
  match fb with
  |[] -> []
  |h::t ->
  if h=O
  then t
  else h::(remove_orange_helper t)
  
  let remove_orange: fbasket -> fbasket result =
  fun fb->
  if List.mem O fb
  then Ok (remove_orange_helper fb)
  else Error "no oranges"

  (*Excercise.
    *)

    let sum_fbp : (fbasket -> int result) -> (fbasket -> int result) -> (fbasket -> int result)=
    fun fbp1 fbp2 -> 
    fun fb ->
    match fbp1 fb with
    |Error s -> Error s
    |Ok n -> 
    match fbp2 fb with
    |Error s -> Error s
    |Ok b-> Ok (n + b)


    let pair_fbp : (fbasket -> 'a result) -> (fbasket -> 'b result) -> (fbasket -> ('a*'b) result) =
    fun fbp1 fbp2->
    fun fb -> 
    match fbp1 fb with
    |Error s -> Error s
    |Ok n ->
    match fbp2 fb with
    |Error s -> Error s
    |Ok m -> Ok (n,m)

    let list_fbp: (fbasket -> 'a result) -> (fbasket -> 'b result) -> (fbasket ->  ('a list) result) =
    fun fbp1 fbp2->
    fun fb -> 
    match fbp1 fb with
    |Error s -> Error s
    |Ok n ->
    match fbp2 fb with
    |Error s -> Error s
    |Ok m -> Ok [n;m]


    let (>>=): 'a fbp -> ('a -> 'b fbp) -> 'b fbp= 
      fun c f->
      fun fb->
      match c en with
      |Error s -> Error s
      |Ok v -> f v fb

   let list_fbp' : 'a fbp -> 'a fbp -> ('a list) fbp = 
      fun fbp1 fbp2 ->
      fbp1 >>= fun n->
      fbp2 >>= fun m-> 
      const [n;m]

    let sum_fbp' : int fbp -> int fbp -> int fbp = 
      fun fbp1 fbp2 ->
      fbp1 >>= fun n->
      fbp2 >>= fun m-> 
      const (n+m)


