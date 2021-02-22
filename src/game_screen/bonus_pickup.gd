extends Node2D

signal bonus_picked_up

onready var _area = $Area
onready var _tween = $Tween
onready var _sprite = $Sprite

func _on_Area_body_entered(body: Node) -> void:
	if body is Player:
		emit_signal("bonus_picked_up")
		_area.set_deferred("monitoring", false)
		_tween.interpolate_property(_sprite, "scale", null, Vector2(1.5, 0.5),
			0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
		_tween.interpolate_property(_sprite, "scale", null, Vector2(0.8, 1.2),
			0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
		_tween.interpolate_property(_sprite, "position", null, Vector2(0, -64),
			0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
		_tween.start()
		yield(_tween, "tween_all_completed")
		queue_free()
