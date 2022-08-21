extends State

#export var max_sprint_speed: = 3000.0
export var default_footstep_sound_speed := 0.5
export var sprint_footstep_sound_speed := 0.2
onready var foot_steps_timer: Timer = $FootStepsTimer

func _on_FootStep_timer_finished() -> void:
	owner.audio_player.play_footstep_SFX()
		
func unhandled_input(event: InputEvent) -> void:
	get_parent().unhandled_input(event)

func physics_process(delta: float) -> void:
	var move := get_parent() as MoveState
	move.max_speed_local.x = (move.max_speed_default.x * 1.5) if Input.is_action_pressed("sprint") else move.max_speed_default.x
	foot_steps_timer.wait_time = sprint_footstep_sound_speed if Input.is_action_pressed("sprint") else default_footstep_sound_speed
	if owner.is_on_floor():
		if move.DECCELERATION_ENABLED and move.velocity.length() < 1.0 and move.get_move_direction(owner.player_combat.block_active).x == 0:
			_state_machine.transition_to("Move/Idle")
		elif not move.DECCELERATION_ENABLED and move.get_move_direction(owner.player_combat.block_active).x == 0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	move.physics_process(delta)

func process(delta: float) -> void:
	var move = get_parent() as MoveState
	move.process(delta)

func enter(msg: Dictionary = {}) -> void:
	var move := get_parent() as MoveState
	move.enter(msg)
	move.movement_animation()
	owner.audio_player.play_footstep_SFX()
	foot_steps_timer.start()
	var value = foot_steps_timer.connect("timeout", self, "_on_FootStep_timer_finished")
	assert(value == OK)
	
func exit() -> void:
	get_parent().exit()
	foot_steps_timer.stop()
	foot_steps_timer.disconnect("timeout", self, "_on_FootStep_timer_finished")
	foot_steps_timer.wait_time = default_footstep_sound_speed
