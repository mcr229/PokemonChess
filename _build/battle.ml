open Pokemon
open Moves
open Ptype
open Random

exception IllegalMove


exception Charging

type t = {
  current_poke: Pokemon.t;
  op_poke: Pokemon.t
}

let get_player battle= battle.current_poke

let get_opponent battle = battle.op_poke

let make_battle player opponent={
  current_poke = player;
  op_poke = opponent
} 

let can_move battle move=
  if Moves.get_pp move = 0 then false else true

(*[hit poke move] determines whether the pokemon [poke] hits or misses with the
move [move]. It is 0 if it misses, and 1 if it hits*)
let hit poke move = 
  if (Random.float 1.) <= (Pokemon.get_accuracy poke) *. (Moves.get_acc move) 
  then 0.
  else 1.

(*[calc_damge move battle] calculates the amount of damage [move] does to the 
opponent pokemon in the [battle]. Take into account whether or not the move misses
Calculation:
      (20* Move Power * (Pokemon Attack/Opponent Defense)/50)*)
let calc_damage move battle =
  let poke = battle.current_poke in
  let poke_attr = Pokemon.get_attr poke in
  (hit poke move)*.((20.*.(Moves.get_power move)*.(List.nth poke_attr 1)/.(List.nth poke_attr 2))/.50.)

(*[calc_effective move poke dam] calculates the effectiveness of move on pokemon
[poke] and applies the necessary mutiliplier to the damage [dam]*)
let calc_effective move poke dam= 
  let move_type = Moves.get_type move in
  match Pokemon.get_type poke with
  | (t1, None) -> (Ptype.getEffective move_type t1)*.dam
  | (t1, Some t2) -> (Ptype.getEffective move_type t1)*.
                    (Ptype.getEffective move_type t2)*.dam

let deal_damage dam poke= 
  Pokemon.change_health poke dam

(* 
let rec parse_side_effects eff_lst opponent_player =
  match eff_lst with
  |[] -> make_battle player opponent *)

(* uses the move on poke*)
let use_move battle move =
  if can_use move then
  let dam = battle |> calc_damage move |> calc_effective move battle.op_poke |> 
  Pervasives.int_of_float in deal_damage dam battle.current_poke
  else raise IllegalMove

  

  