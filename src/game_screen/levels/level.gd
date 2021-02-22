class_name Level
extends Node2D

signal level_completed

onready var _player_start = $PlayerStart
onready var _tilemap = $TileMap

onready var player_start_position: Vector2 = _player_start.position
onready var bounds: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO) setget , get_bounds

func get_bounds():
	var rect = _tilemap.get_used_rect()
	var size = _tilemap.cell_size.x
	return Rect2(rect.position * size + Vector2(size / 2, -size * 2),
		rect.end * size - Vector2(size / 2, size / 2))


func _on_Goal_goal_reached() -> void:
	emit_signal("level_completed")
