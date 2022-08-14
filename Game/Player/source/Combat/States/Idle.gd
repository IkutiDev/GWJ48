extends State

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		_state_machine.transition_to("NormalAttack")
	elif event.is_action_pressed("block"):
		_state_machine.transition_to("Block")

func physics_process(delta: float) -> void:
	return
		
func process(delta: float) -> void:
	return

func enter(msg: Dictionary = {}) -> void:
	return
	
func exit() -> void:
	return
