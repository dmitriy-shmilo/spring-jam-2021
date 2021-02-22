extends Node2D

var current_level_idx = 0

onready var _pause_container: ColorRect = $Gui/PauseContainer
onready var _player: Player = $Player

var _levels = [preload("res://game_screen/levels/level0.tscn")]
var _current_level = null

func _ready():
	_current_level = _levels[current_level_idx].instance() as Level
	add_child(_current_level)
	_current_level.connect("level_completed", self, "_on_level_completed")
	_player.position = _current_level.get_node("PlayerStart").position
	_player.camera.limit_left = _current_level.bounds.position.x
	_player.camera.limit_top = _current_level.bounds.position.y
	_player.camera.limit_right = _current_level.bounds.end.x - _player.camera.limit_left
	_player.camera.limit_bottom = _current_level.bounds.end.y - _player.camera.limit_top


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true
		


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false


func _on_level_completed():
	get_tree().change_scene("res://game_over_screen/game_over_screen.tscn")
