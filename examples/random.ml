open Base

let env_name = "Pong-v0"
let total_episodes = 100
let render = true

let () =
  Stdio.printf "Creating environment %s.\n%!" env_name;
  let env = Gym.Atari.create env_name in
  for episode_index = 1 to total_episodes do
    let rec loop _prev_obs acc_reward acc =
      if render
      then Gym.Atari.render env;
      let action = Random.int 2 + 2 in
      let { Gym.Step.is_done; obs; reward } = Gym.Atari.step env ~action in
      if is_done
      then acc_reward, acc
      else loop obs (acc_reward +. reward) (acc + 1)
    in
    let total_reward, number_of_steps = loop (Gym.Atari.reset env) 0. 0 in
    Stdio.printf "Episode %d: %.1f reward, %d steps.\n%!" episode_index total_reward number_of_steps;
    (* Trigger a GC to check that there are no memory leaks. *)
    Caml.Gc.full_major ()
  done
