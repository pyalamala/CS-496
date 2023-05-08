(* 
     Quiz 2 - 18 Feb 2022

     Name1: 

     Name2:

 *)

type 'a bt = Empty |  Node of 'a*'a bt*'a bt

(* Helper function that builds a leaf *)
let leaf n = Node(n,Empty,Empty)

(* Two sample binary trees.
   The first one is a BST, but not the second one *)
let ex1 = Node(12,
              Node(7,Empty,leaf 10),
               Node(24,
                    leaf 14,
                    Empty))

let ex2 = Node(12,
              leaf 7,
               Node(24,
                    leaf 30,
                    Empty))

(** returns smallest element in non-empty tree [t].
    Fails if [t] is empty, it should fail. 
    Note: the tree [t] is not assumed to be a bst *)
let rec mint t =
  match t with
  |Empty -> failwith "Empty Tree"
  |Leaf(x)-> x
  |Node(x,y,Empty)-> min x (mint y)
  |Node(x,Empty,z) -> min x (mint z)
  |Node(x,y,z) -> min (min (mint y) (mint z)) x 
(** returns largest element in non-empty tree [t].
    Fails if [t] is empty, it should fail. 
    Note: the tree [t] is not assumed to be a bst *)
let rec maxt t =
   match t with
  |Empty -> failwith "Empty Tree"
  |Leaf(x)-> x
  |Node(x,y,Empty)-> max x (maxt y)
  |Node(x,Empty,z) -> max x (maxt z)
  |Node(x,y,z) -> max (max (maxt y) (maxt z)) x 

(* Determines whether a binary is a binary search tree *)
let rec is_bst t =
  match t with
  |Empty -> true
  |Leaf(x) -> true
  |Node(x,y,Empty) -> x > maxt y && is_bst y
  |Node(x, Emtpy, z) -> x < mint z && is_bst z
  |Node(x,y,z) -> x > maxt y && is_bst y && x < mint z && is_bst z

(** adds v to the bst t. 
    Should fail with failwith if v is already in the tree.
    Otherwise, returns updated tree *)
let rec add v t =
  match t with
  |Empty -> Leaf(v)
  |Node(x,y,z) -> when x = v -> failwith "add: duplicate key"
  |Node(x,y,z) ->
    if v<x
    then Node(x, add v y, z)
    else Node(x, y, add v z)
           
(* Remove a value from a BST (Extra-credit)
   Should fail (with failwith) if the value is not in tree *)
let rec rem v t =
   match t with
   |Empty -> failwith "Empty Tree"
   |Leaf(x) -> if x=v
   then Empty
   else failwith "Not in in tree"
   |Node(x,y,z) -> 
   if v<x
   then Node(x, rem v y, z)
   else
 





