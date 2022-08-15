extends State

func physics_process(delta: float) -> void:
	var move := get_parent()
	if owner.is_on_floor():
		if move.get_move_direction(owner.desiredLoc, owner.global_position).x == 0.0:
			_state_machine.transition_to("MoveEnemy/IdleEnemy")
	else:
		_state_machine.transition_to("MoveEnemy/AirEnemy")
	move.physics_process(delta)

func process(delta: float) -> void:
	var move = get_parent()
	move.process(delta)

func enter(msg: Dictionary = {}) -> void:
	var move := get_parent()
	move.enter(msg)
	owner.skin.play_animated_sprite("run")
	
func exit() -> void:
	get_parent().exit()
