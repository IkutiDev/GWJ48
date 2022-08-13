extends Node

onready var player: KinematicBody2D = $Player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("debug_die"):
		player.state_machine.transition_to("Die")
