extends State
onready var attack_cooldown: Timer = $"../../AttackEnemy/AttackCooldown"

func physics_process(delta: float) -> void:
	var move := get_parent()
	if owner.is_on_floor():
		if move.get_move_direction(owner.desiredLoc, owner.global_position).x == 0.0:
			_state_machine.transition_to("MoveEnemy/IdleEnemy")
		elif owner.global_position.distance_to(owner.desiredLoc) <= owner.distance_to_attack and attack_cooldown.time_left == 0:
			_state_machine.transition_to("AttackEnemy")
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
