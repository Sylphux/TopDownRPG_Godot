extends Node2D


# Called when the node enters the scene tree for the first time.
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
	pass
