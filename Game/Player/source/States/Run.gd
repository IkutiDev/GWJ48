extends State

export var max_sprint_speed: = 1000.0

func unhandled_input(event: InputEvent) -> void:
	get_parent().unhandled_input(event)

func physics_process(delta: float) -> void:
	var move := get_parent() as MoveState
	move.max_speed.x = max_sprint_speed if Input.is_action_pressed("sprint") else move.max_speed_default.x
	
	if owner.is_on_floor():
		if move.DECCELERATION_ENABLED and move.velocity.length() < 1.0 and move.get_move_direction().x == 0:
			_state_machine.transition_to("Move/Idle")
		elif not move.DECCELERATION_ENABLED and move.get_move_direction().x == 0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	move.physics_process(delta)

func process(delta: float) -> void:
	var move = get_parent() as MoveState
	move.process(delta)

func enter(msg: Dictionary = {}) -> void:
	get_parent().enter(msg)
	owner.skin.play_animated_sprite("run")
	
func exit() -> void:
	get_parent().exit()
