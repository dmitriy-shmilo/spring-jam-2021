class_name goal
extends Node2D

signal goal_reached


func _on_GoalArea_body_entered(body: Node) -> void:
	if body is Player:
		emit_signal("goal_reached")
