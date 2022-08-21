extends State
onready var attack_cooldown: Timer = $"../../AttackEnemy/AttackCooldown"

func physics_process(_delta: float) -> void:
	var move = get_parent()
	if owner.is_on_floor():
		if move.get_move_direction(owner.desiredLoc, owner.global_position, move.distance_to_player).x != 0.0:
			_state_machine.transition_to("MoveEnemy/RunEnemy")
		elif owner.global_position.distance_to(owner.desiredLoc) <= owner.distance_to_attack and attack_cooldown.time_left == 0:
			_state_machine.transition_to("AttackEnemy")
		elif owner.can_teleport:
			_state_machine.transition_to("MoveEnemy/TeleportEnemy")
	else:
		_state_machine.transition_to("MoveEnemy/AirEnemy")
		
func process(delta: float) -> void:
	var move = get_parent()
	move.process(delta)

func enter(msg: Dictionary = {}) -> void:
	var move = get_parent()
	move.enter(msg)
	
	move.max_speed_local = move.max_speed_default
	move.velocity = Vector2.ZERO
	
	owner.skin.play_animated_sprite("idle")
	
func exit() -> void:
	get_parent().exit()
