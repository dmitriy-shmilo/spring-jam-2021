class_name PopupSign
extends Node2D

export(String, MULTILINE) var text = "" setget set_text

onready var _label: Label = $ZContainer/PanelContainer/Label
onready var _panel: PanelContainer = $ZContainer/PanelContainer
onready var _sprite: Sprite = $Sprite
onready var _sprite_height = _sprite.region_rect.size.y

func _ready() -> void:
	_panel.visible = false
	_update_panel()


func set_text(value: String):
	text = value
	if is_inside_tree():
		_update_panel()


func _update_panel():
	_label.text = text


func _on_Area2D_body_entered(body: Node) -> void:
	
	_panel.visible = true


func _on_Area2D_body_exited(body: Node) -> void:
	_panel.visible = false


func _on_PanelContainer_resized() -> void:
	_panel.rect_position.x = - _panel.rect_size.x / 2
	_panel.rect_position.y = -_sprite_height - _panel.rect_size.y
