(*Pranav Yalamala
//I pledge my honor that I have abided by the Stevens's Honor System.*)

type dTree =
|Leaf of int
|Node of (char * dTree * dTree)

let tLeft = Node('w', Node('x', Leaf(2), Leaf(5)), Leaf(8))

let tRight = Node('w', Node('x', Leaf(2), Leaf(5)), Node('y', Leaf(7), Leaf(5)))

let rec dTree_height tree =
match tree with
|Leaf(x) -> 1
|Node(x, y, z) -> 
if (dTree_height y)>(dTree_height z)
then (dTree_height y) + 1
else (dTree_height z) + 1

let rec dTree_size tree =
match tree with
|Leaf(x) -> 1
|Node(x,y,z) -> (dTree_size y) + (dTree_size z) + 1

let paths_helper1 t =
0::t

let paths_helper2 t = 
1::t

let rec dTree_paths tree =
match tree with
|Leaf(x) -> [[]]
|Node(x,y,z) ->  List.map paths_helper1 (dTree_paths y) @ List.map paths_helper2 (dTree_paths z)

let rec dTree_is_perfect tree =
match tree with
|Leaf(x) -> true
|Node(x,y,z) ->
if (dTree_height y)!=(dTree_height z)
then false
else dTree_is_perfect y && dTree_is_perfect z

let rec dTree_map f g t=
match t with
|Leaf(x)-> Leaf(g x)
|Node(x,y,z) -> Node(f x, dTree_map f g y, dTree_map f g z)

let rec list_to_tree l =
match l with
|[] -> Leaf(0)
|h::t-> Node(h, list_to_tree t, list_to_tree t)

let rec replace_leaf_helper t l v =
match l with
|[] -> Leaf(v)
|h::tail->
    match t with
    |Node(x,y,z) ->
    if h=0
    then Node(x, replace_leaf_helper y tail v, z)
    else Node(x, y, replace_leaf_helper z tail v)


let rec replace_leaf_at t f =
match f with
|[]-> t
|h::tail ->
    match h with
    |(x,y) -> replace_leaf_at (replace_leaf_helper t x y) tail

let bf_to_dTree b =
match b with
|(x,y) -> replace_leaf_at (list_to_tree x) y
