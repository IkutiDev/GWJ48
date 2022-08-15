extends State

signal jumped

onready var jump_delay: Timer = $JumpDelay

export var acceleration_x: = 5000.0
export var max_jump_count: = 2
export var jump_impulse: = 800.0
export var add_to_jump_count_on_fall: = true

var _jump_count: = 0

func _on_CheckPlayerFallingAfterDelay_timer_finished() -> void:
	if _jump_count == 0 and add_to_jump_count_on_fall:
		_jump_count += 1

func unhandled_input(event: InputEvent) -> void:
	var move := get_parent() as MoveState
	
	if event.is_action_pressed("jump"):
		emit_signal("jumped")
		if move.velocity.y >= 0.0 and jump_delay.time_left > 0.0:
			jump()
		elif _jump_count < max_jump_count:
			jump()
	else:
		move.unhandled_input(event)

func physics_process(delta: float) -> void:
	var move := get_parent() as MoveState
	move.physics_process(delta)
	
	
	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if move.get_move_direction(owner.player_combat.block_active).x == 0.0 else "Move/Run"
		_state_machine.transition_to(target_state)
		owner.audio_player.play_fall_SFX()

func process(_delta: float) -> void:
	var move = get_parent() as MoveState
	
	owner.flip_direction(move.get_move_direction(owner.player_combat.block_active).x)
	
	if sign(move.velocity.y) == -1:
		if owner.skin.animation != "jump":
			owner.skin.play_animated_sprite("jump")
	else:
		owner.skin.play_animated_sprite("fall")

func enter(msg: Dictionary = {}) -> void:
	var move := get_parent() as MoveState
	move.enter(msg)
	move.acceleration_local.x = acceleration_x
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed_default.x)
		
	if "impulse" in msg:
		jump()
		
	var value = jump_delay.connect("timeout", self, "_on_CheckPlayerFallingAfterDelay_timer_finished")
	assert(value == OK)
	jump_delay.start()
			
func exit() -> void:
	var move := get_parent() as MoveState
	move.exit()
	move.acceleration_local = move.acceleration_default
	move.decceleration_local = move.decceleration_default
	_jump_count = 0
	jump_delay.disconnect("timeout", self, "_on_CheckPlayerFallingAfterDelay_timer_finished")
	jump_delay.stop()
	
func jump() -> void:
	var move = get_parent() as MoveState
	move.velocity.y = 0
	move.velocity += calculate_jump_velocity(jump_impulse)
	if _jump_count == 0:
		owner.audio_player.play_jump_SFX()
	_jump_count += 1


func calculate_jump_velocity(impulse: = 0.0) -> Vector2:
	var move: = get_parent() as MoveState
	return move.calculate_velocity(
		move.velocity,
		move.max_speed_local,
		Vector2(0.0, impulse),
		Vector2.ZERO,
		1,
		Vector2.UP,
		move.max_fall_speed
	)
