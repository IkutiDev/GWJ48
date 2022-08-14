extends CanvasLayer

func _enter_tree():
	get_tree().paused = true

func _on_Button_pressed():
	get_tree().change_scene("res://Game.tscn")
	pass # Replace with function body.


func _on_Button2_pressed():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
	pass # Replace with function body.


func _exit_tree():
	get_tree().paused = false
