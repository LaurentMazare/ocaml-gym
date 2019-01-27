open Base
open Py

type t =
  { env : pyobject
  ; np : pyobject
  }

type action = int
type obs = (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Genarray.t

let create str =
  let gym = PyModule.import "gym" in
  let env = gym $. String "make" $ [ String str ] in
  let np = PyModule.import "numpy" in
  { env; np }

let to_bigarray t np_array =
  let np_array = t.np $. String "ascontiguousarray" $ [ Ptr np_array ] in
  let np_array = np_array $. String "astype" $ [ Ptr (t.np $. String "float32") ] in
  Numpy.to_bigarray np_array Float32

let reset t =
  t.env $. String "reset" $ []
  |> to_bigarray t

let render t =
  ignore (t.env $. String "render" $ [] : pyobject)

let step t ~action =
  let v = t.env $. String "step" $ [ Int action ] in
  let obs, reward, is_done =
    match Object.to_list Fn.id v with
    | obs :: reward :: is_done :: _ -> obs, reward, is_done
    | [] | [ _ ] | [ _; _ ] -> assert false
  in
  { Step.obs = to_bigarray t obs
  ; reward = Object.to_float reward
  ; is_done = Object.to_bool is_done
  }

let actions t =
  let actions = t.env $. String "unwrapped" $. String "get_action_meanings" $ [] in
  Object.to_list Object.to_string actions
