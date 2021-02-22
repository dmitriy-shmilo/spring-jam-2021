class_name Waypoints
extends Node2D
tool

var current_point: Vector2 = Vector2.ZERO setget ,get_current_point
export (PoolVector2Array) var points = PoolVector2Array([Vector2(0, 0)]) setget set_points
export (bool) var cyclic = true
export (int) var current_point_idx = 0

var _advance_direction = 1

func _ready() -> void:
	pass

func _draw():
	for i in range(points.size()):
		draw_circle(points[i], 2, Color.red if i == current_point_idx else Color.green)


func set_points(value: PoolVector2Array):
	points = value
	update()


func advance():
	if cyclic:
		current_point_idx = (current_point_idx + 1) % points.size()
		update()
		return
	
	current_point_idx += _advance_direction
	
	if current_point_idx == points.size() - 1:
		_advance_direction = -1
	elif current_point_idx == 0:
		_advance_direction = 1
	
	update()


func get_current_point() -> Vector2:
	return points[current_point_idx]
