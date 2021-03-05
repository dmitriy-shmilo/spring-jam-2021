class_name Waypoints
extends Line2D
tool

var current_point: Vector2 = Vector2.ZERO setget ,get_current_point
export (bool) var cyclic = true
export (int) var current_point_idx = 0

var _advance_direction = 1

func _ready() -> void:
	visible = false

func _draw():
	draw_circle(points[current_point_idx], 4, Color.red)


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
