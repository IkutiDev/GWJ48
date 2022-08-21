extends State

func unhandled_input(event: InputEvent) -> void:
	if owner.player.state_machine._state_name == "Freeze":
		return
	
	if event.is_action_pressed("attack"):
		_state_machine.transition_to("NormalAttack")
	elif event.is_action_pressed("block"):
		if owner.current_shield_charges > 0:
			_state_machine.transition_to("Block")
		else:
			owner.player.audio_player.play_shield_error_SFX()

func physics_process(_delta: float) -> void:
	return
		
func process(_delta: float) -> void:
	return

func enter(_msg: Dictionary = {}) -> void:
	return
	
func exit() -> void:
	return
