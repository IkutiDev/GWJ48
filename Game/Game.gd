extends Node

onready var player: Player = $Player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart"):
		var value = get_tree().reload_current_scene()
		assert(value == OK)
	if event.is_action_pressed("debug_die"):
		player.state_machine.transition_to("Die")
