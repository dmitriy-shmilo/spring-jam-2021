class_name Level
extends Node2D

signal level_completed
signal temperature_changed

export(float) var min_temperature = 1.0
export(float) var max_temperature = 10.0
export(float) var current_temperature = min_temperature setget set_current_temperature
export(float) var temperature_increment = 1

onready var _player_start = $PlayerStart
onready var _tilemap = $TileMap

onready var player_start_position: Vector2 = _player_start.position
onready var bounds: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO) setget , get_bounds

func get_bounds():
	var rect = _tilemap.get_used_rect()
	var size = _tilemap.cell_size.x
	return Rect2(rect.position * size + Vector2(size / 2, -size * 2),
		rect.end * size - Vector2(size / 2, size / 2))


func set_current_temperature(value):
	current_temperature = clamp(value, min_temperature, max_temperature)
	emit_signal("temperature_changed")


func _on_Goal_goal_reached() -> void:
	emit_signal("level_completed")
