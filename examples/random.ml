let env_name = "Pong-v0"
let total_episodes = 100

let () =
  Stdio.printf "Creating environment %s.\n%!" env_name;
  let env = Gym.Atari.create env_name in
  for episode_index = 1 to total_episodes do
    let rec loop _prev_obs acc_reward acc =
      let { Gym.Step.is_done; obs; reward } = Gym.Atari.step env ~action:0 in
      if is_done
      then acc_reward, acc
      else loop obs (acc_reward +. reward) (acc + 1)
    in
    let total_reward, number_of_steps = loop (Gym.Atari.reset env) 0. 0 in
    Stdio.printf "Episode %d: %.1f reward, %d steps.\n%!" episode_index total_reward number_of_steps;
    (* Trigger a GC to check that there are no memory leaks. *)
    Gc.full_major ()
  done
