extends Level

onready var _move_tutorial: PopupSign = $MoveTutorial
onready var _jump_tutorial: PopupSign = $JumpTutorial

func _ready() -> void:
	var left = InputMap.get_action_list("left")[0]
	var right = InputMap.get_action_list("right")[0]
	var up = InputMap.get_action_list("up")[0]
	_move_tutorial.text = "[%s] and [%s] to move left and right" \
		% [left.as_text(), right.as_text()]
	_jump_tutorial.text = "[%s] to jump" % [up.as_text()]
