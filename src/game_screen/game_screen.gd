extends Node2D

var current_level_idx = 0

onready var _player: Player = $Player
onready var _temperature_timer: Timer = $TemperatureTimer
onready var _melting_timer: Timer = $MeltingTimer
onready var _pause_container: ColorRect = $Gui/CanvasLayer/PauseContainer
onready var _health_bar: ProgressBar = $Gui/CanvasLayer/HealthBar
onready var _temperature_bar: ProgressBar = $Gui/CanvasLayer/TemperatureBar

var _levels = [
	preload("res://game_screen/levels/level0.tscn"),
	preload("res://game_screen/levels/level1.tscn"),
]
var _current_level: Level = null

func _ready():
	_load_level(current_level_idx)


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true
		


func _load_level(level_idx: int) -> void:
	if _current_level != null:
		_temperature_timer.stop()
		_melting_timer.stop()
		_current_level.queue_free()
		remove_child(_current_level)
		_player.set_collision_layer_bit(0, false)
	
	_current_level = _levels[level_idx].instance() as Level
	add_child(_current_level)
	_current_level.connect("level_completed", self, "_on_level_completed")
	_current_level.connect("temperature_changed", self, "_on_temperature_changed")
	_player.health = _player.max_health
	_player.position = _current_level.get_node("PlayerStart").position
	_player.camera.limit_left = _current_level.bounds.position.x
	_player.camera.limit_top = _current_level.bounds.position.y
	_player.camera.limit_right = _current_level.bounds.end.x - _player.camera.limit_left
	_player.camera.limit_bottom = _current_level.bounds.end.y - _player.camera.limit_top
	_on_temperature_changed()

	yield(get_tree(), "idle_frame")

	_player.set_collision_layer_bit(0, true)
	_temperature_timer.start()
	_melting_timer.start()


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false


func _on_level_completed():
	current_level_idx += 1
	if current_level_idx >= _levels.size():
		get_tree().change_scene("res://game_over_screen/game_over_screen.tscn")
	else:
		_load_level(current_level_idx)


func _on_temperature_changed():
	_temperature_bar.value = range_lerp(_current_level.current_temperature,
		_current_level.min_temperature, _current_level.max_temperature,
		_temperature_bar.min_value, _temperature_bar.max_value)


func _on_TemperatureTimer_timeout() -> void:
	_current_level.current_temperature += _current_level.temperature_increment


func _on_MeltingTimer_timeout() -> void:
	_player.health -= _current_level.current_temperature


func _on_Player_health_changed(new_value) -> void:
	if new_value <= 0.0:
		get_tree().change_scene("res://game_over_screen/game_over_screen.tscn")

	_health_bar.value = range_lerp(new_value, 0.0,
		_player.max_health, _health_bar.min_value, _health_bar.max_value)
