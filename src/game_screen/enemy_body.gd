class_name EnemyBody
extends KinematicBody2D

const WAYPOINT_DISTANCE_THRESHOLD = 9.0

signal waypoint_reached

export (float) var speed = 50.0

onready var desired_position = position
onready var _sprite = $Sprite

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var direction = desired_position - position
	var velocity = direction.normalized() * speed
	
	_sprite.flip_h = velocity.x > 1.0
		
	move_and_slide(velocity)
	
	if direction.length_squared() < WAYPOINT_DISTANCE_THRESHOLD:
		emit_signal("waypoint_reached")
