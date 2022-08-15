extends State

onready var jump_delay: Timer = $JumpDelay

func unhandled_input(event: InputEvent) -> void:
	var move = get_parent() as MoveState
	move.unhandled_input(event)

func physics_process(_delta: float) -> void:
	var move = get_parent() as MoveState
	if owner.is_on_floor():
		if move.get_move_direction(owner.player_combat.block_active).x != 0.0:
			_state_machine.transition_to("Move/Run")
	else:
		_state_machine.transition_to("Move/Air")
		
func process(delta: float) -> void:
	var move = get_parent() as MoveState
	move.process(delta)

func enter(msg: Dictionary = {}) -> void:
	var move = get_parent() as MoveState
	move.enter(msg)
	
	move.max_speed_local = move.max_speed_default
	move.velocity = Vector2.ZERO
	
	owner.skin.play_animated_sprite("idle")
	
	if not jump_delay.is_stopped():
		_state_machine.transition_to("Move/Air", {impulse = true})
		jump_delay.stop()
		return
	
func exit() -> void:
	get_parent().exit()
