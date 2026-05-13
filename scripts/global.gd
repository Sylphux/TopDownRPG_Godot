extends Node

var player_currently_atttacking = false
var current_scene = "World"
var in_transition_scene = false
var player_exit_cliffside_pos = Vector2.ZERO
var player_start_pos = Vector2.ZERO
var player_first_load = true
var game_first_load = true

func _ready() -> void:
	player_exit_cliffside_pos.x = 260.0
	player_exit_cliffside_pos.y = 20.0

func finish_changing_scene():
	if in_transition_scene:
		in_transition_scene = false
		if current_scene == "World":
			current_scene = "CliffSide"
		else:
			current_scene = "World"
