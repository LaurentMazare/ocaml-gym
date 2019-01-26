module type S = sig
  type t
  type action
  type obs

  val create : string -> t
  val reset : t -> obs
  val step : t -> action:action -> obs Step.t
end
