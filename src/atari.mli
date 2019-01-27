(* Specify the types for atari. *)
type t
type action = int
type obs = (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Genarray.t

include Env_intf.S with type t := t and type action := action and type obs := obs

val actions : t -> string list
