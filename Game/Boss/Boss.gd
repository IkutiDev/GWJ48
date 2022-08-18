extends Node2D

func _input(event):
	if event.is_action_pressed("ui_accept"):
		global_position = get_global_mouse_position()
