extends Node2D

func _ready() -> void:
	var map_size = get_map_size()
	$Player/Camera2D.limit_right = map_size[0]
	$Player/Camera2D.limit_bottom = map_size[1]

func get_map_size():
	var quadrant_s = $TileMap.rendering_quadrant_size
	var x = $TileMap.get_used_rect().size.x * quadrant_s
	var y = $TileMap.get_used_rect().size.y * quadrant_s
	return [x, y]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scenes()

func _on_world_door_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.in_transition_scene = true

#func _on_world_door_body_exited(body: Node2D) -> void:
	#if body.has_method("player"):
		#Global.in_transition_scene = false
		
func change_scenes():
	if Global.in_transition_scene:
		if Global.current_scene == "CliffSide":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			Global.finish_changing_scene()
