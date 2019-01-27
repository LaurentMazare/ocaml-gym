# ocaml-gym
Bindings for [OpenAI Gym](https://github.com/openai/gym) using the Python C API via [ocaml-py](https://github.com/zshipko/ocaml-py).

There are already some Gym bindings for OCaml, e.g. [openai-gym-ocaml](https://github.com/IBM/openai-gym-ocaml) or [openai-gym-ocaml](https://github.com/LaurentMazare/openai-gym-ocaml)
however these bindings work as a client for the [Gym REST API](https://github.com/openai/gym-http-api). This means that
every observation gets converted from and to JSON between the server and the client part.
This works well for environment with very small observations but has performance implications
for environment such as Atari as observations are pixel based and so quite large.

__ocaml-gym__ runs an in-process Python environment so that there is no need for any serialization.
The memory buffer returned by the Gym does not even have to be copied and can be accessed directly
from OCaml.
