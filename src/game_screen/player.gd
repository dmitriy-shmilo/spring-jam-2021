class_name Player
extends KinematicBody2D

export(float) var gravity  = 700.0
export(Vector2) var speed = Vector2(150, 256+32)

var velocity = Vector2.ZERO;

onready var camera: Camera2D = $PlayerCamera
onready var _movement_tween = $MovementTween
onready var _sprite = $Sprite

var _was_on_floor = false

func _ready():
	_movement_tween.interpolate_property(_sprite, "scale", \
		null, Vector2(1.15, 0.85), 0.15, \
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	_movement_tween.interpolate_property(_sprite, "scale", \
		null, Vector2(0.85, 1.15), 0.15, \
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.15)


func _physics_process(delta):
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1.0 if Input.is_action_just_pressed("up") and is_on_floor() else 1.0
	)
	
	if Input.is_action_just_pressed("left"):
		_sprite.flip_h = true
	elif Input.is_action_just_pressed("right"):
		_sprite.flip_h = false
	
	velocity.x =  direction.x * speed.x
	velocity.y += min(gravity * delta, speed.y)
	
	if direction.y < 0.0:
		_sprite.scale = Vector2(1.2, 0.8) # TODO: make this work
		velocity.y = -speed.y
	
	if not is_on_floor():
		_sprite.scale = Vector2(0.8, 1.2)

	if velocity.x != 0 and is_on_floor():
		if not _movement_tween.is_active():
			_movement_tween.resume_all()
	else:
		if is_on_floor():
			_sprite.scale = Vector2.ONE
		_movement_tween.stop_all()

	velocity = move_and_slide(velocity, Vector2.UP)
	
	_was_on_floor = is_on_floor()
