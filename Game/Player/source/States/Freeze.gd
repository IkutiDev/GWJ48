extends State

func unhandled_input(_event: InputEvent) -> void:
	return

func physics_process(_delta: float) -> void:
	return

func process(_delta: float) -> void:
	return

func enter(_msg: Dictionary = {}) -> void:
	owner.skin.play_animated_sprite("freeze", 99)
	
func exit() -> void:
	return
