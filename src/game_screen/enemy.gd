class_name Enemy
extends Node2D

onready var _waypoints = $Waypoints
onready var _body = $Body


func _ready() -> void:
	_body.desired_position =  _waypoints.current_point


func _on_Body_waypoint_reached() -> void:
	_waypoints.advance()
	_body.desired_position =  _waypoints.current_point
