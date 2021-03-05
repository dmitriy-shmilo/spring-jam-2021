extends Area2D


func _ready() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	get_parent().damage((area as Hitbox).damage, area.global_position)
	
