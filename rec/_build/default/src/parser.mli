
(* The type of tokens. *)

type token = 
  | UNTUPLE
  | UNPAIR
  | TL
  | TIMES
  | THEN
  | SND
  | SETREF
  | SET
  | SEMICOLON
  | RPAREN
  | RBRACE
  | RANGLE
  | PROC
  | PLUS
  | PAIR
  | NOT
  | NEWREF
  | MINUS
  | MAX
  | LPAREN
  | LETREC
  | LET
  | LBRACE
  | LANGLE
  | ISZERO
  | ISEMPTY
  | INT of (int)
  | IN
  | IF
  | ID of (string)
  | HD
  | FST
  | EQUALS
  | EOF
  | END
  | EMPTYLIST
  | ELSE
  | DOT
  | DIVIDED
  | DEREF
  | DEBUG
  | CONS
  | COMMA
  | BEGIN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
