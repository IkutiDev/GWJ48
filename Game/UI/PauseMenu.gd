extends CanvasLayer

func _enter_tree():
	get_tree().paused = true
	
func _exit_tree():
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		queue_free()

func _on_Button2_pressed():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
	pass # Replace with function body.


func _on_Button_pressed():
	queue_free()
	pass # Replace with function body.
