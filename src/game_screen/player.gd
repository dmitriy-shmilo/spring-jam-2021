class_name Player
extends KinematicBody2D

signal health_changed(new_value)
signal died

export(float) var max_health := 100.0
export(float) var health := max_health setget set_health
export(float) var gravity  := 700.0
export(float) var knockback_strength := 400
export(Vector2) var speed := Vector2(150, 256+32)

var velocity := Vector2.ZERO
var knockback := Vector2.ZERO

onready var camera: Camera2D = $PlayerCamera
onready var _movement_tween: Tween = $MovementTween
onready var _squash_tween: Tween = $MovementTween
onready var _sprite: Sprite = $Sprite
onready var _hurtbox: Hurtbox = $Hurtbox
onready var _invincible_timer = $InvincibleTimer
onready var _animation_player = $AnimationPlayer

var _prev_velocity = Vector2.ZERO
var _hit_ground = false
var _is_invincible = false

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
	
	velocity.x =  direction.x * speed.x + knockback.x
	velocity.y += gravity * delta

	if knockback != Vector2.ZERO:
		velocity.y = knockback.y
	elif is_on_floor() and direction.y < 0.0:
		velocity.y = -speed.y

	_prev_velocity = velocity

	knockback = knockback.move_toward(Vector2.ZERO, 50)
	velocity = move_and_slide(velocity, Vector2.UP)
	

	if not is_on_floor():
		_movement_tween.stop_all()
		_hit_ground = false
		_sprite.scale.y = range_lerp(abs(velocity.y), 0, abs(speed.y), 0.8, 1.3)
		_sprite.scale.x = range_lerp(abs(velocity.y), 0, abs(speed.y), 1.1, 0.7)
	
	if is_on_floor():
		if not _hit_ground:
			_hit_ground = true
			_sprite.scale.x = range_lerp(abs(_prev_velocity.y), 0, abs(1024), 1.2, 1.8)
			_sprite.scale.y = range_lerp(abs(_prev_velocity.y), 0, abs(1024), 0.8, 0.65)
		if direction.x != 0.0:
			_movement_tween.resume_all()
		else:
			_movement_tween.stop_all()

		
	_sprite.scale.x = lerp(_sprite.scale.x, 1, 1 - pow(0.01, delta))
	_sprite.scale.y = lerp(_sprite.scale.y, 1, 1 - pow(0.01, delta))


func set_health(value):
	health = clamp(value, 0.0, max_health)
	emit_signal("health_changed", health)
	
	if health <= 0:
		emit_signal("died")


func damage(damage: float, from: Vector2) -> void:
	if _is_invincible:
		return
	become_invincible()
	knockback = (global_position - from).normalized() * knockback_strength
	self.health -= damage


func become_invincible(duration: float = -1) -> void:
	if _is_invincible:
		return

	_is_invincible = true
	_hurtbox.set_deferred("monitoring", false)
	_animation_player.play("invincible")
	_invincible_timer.start(duration)


func _on_InvincibleTimer_timeout() -> void:
	_is_invincible = false
	_hurtbox.set_deferred("monitoring", true)
	_animation_player.play("idle")
