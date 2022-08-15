extends State

func physics_process(delta: float) -> void:
	var move := get_parent()
	move.physics_process(delta)
	
	
	# Landing
	if owner.is_on_floor():
		var target_state: = "MoveEnemy/IdleEnemy" if move.get_move_direction(owner.desiredLoc, owner.global_position).x == 0.0 else "MoveEnemy/RunEnemy"
		_state_machine.transition_to(target_state)

func process(_delta: float) -> void:
	var move = get_parent()
	
	owner.flip_direction(move.get_move_direction(owner.desiredLoc, owner.global_position).x)

func enter(msg: Dictionary = {}) -> void:
	var move := get_parent()
	move.enter(msg)
			
func exit() -> void:
	var move := get_parent()
	move.exit()
