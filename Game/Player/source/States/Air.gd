extends State

signal jumped

onready var jump_delay: Timer = $JumpDelay

export var acceleration_x: = 5000.0
export var max_jump_count: = 2
export var jump_impulse: = 1500.0
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
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0.0 else "Move/Run"
		_state_machine.transition_to(target_state)

func process(delta: float) -> void:
	var move = get_parent() as MoveState
	
	if move.get_move_direction().x < 0:
		owner.skin.player_sprite.flip_h = true
	elif move.get_move_direction().x > 0:
		owner.skin.player_sprite.flip_h = false
	
	if sign(move.velocity.y) == -1:
		if owner.skin.animation != "jump":
			owner.skin.play_animated_sprite("jump")
	else:
		owner.skin.play_animated_sprite("fall")

func enter(msg: Dictionary = {}) -> void:
	var move := get_parent() as MoveState
	move.enter(msg)
	move.acceleration.x = acceleration_x
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed_default.x)
		
	if "impulse" in msg:
		jump()
		
	jump_delay.connect("timeout", self, "_on_CheckPlayerFallingAfterDelay_timer_finished")
	jump_delay.start()
			
func exit() -> void:
	var move := get_parent() as MoveState
	move.exit()
	move.acceleration = move.acceleration_default
	move.decceleration = move.decceleration_default
	_jump_count = 0
	jump_delay.disconnect("timeout", self, "_on_CheckPlayerFallingAfterDelay_timer_finished")
	jump_delay.stop()
	
func jump() -> void:
	var move = get_parent() as MoveState
	move.velocity.y = 0
	move.velocity += calculate_jump_velocity(jump_impulse)
	_jump_count += 1

func calculate_jump_velocity(impulse: = 0.0) -> Vector2:
	var move: = get_parent() as MoveState
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		Vector2.ZERO,
		1,
		Vector2.UP,
		move.max_fall_speed
	)