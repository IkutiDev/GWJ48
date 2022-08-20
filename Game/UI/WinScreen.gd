extends CanvasLayer

func _enter_tree():
	get_tree().paused = true
	$Glory.text = "You obtained " + String(100) + " glory in this run!" 

func _on_Button_pressed():
	var value = get_tree().change_scene("res://Game.tscn")
	assert(value == OK)
	pass # Replace with function body.


func _on_Button2_pressed():
	var value = get_tree().change_scene("res://MainMenu/MainMenu.tscn")
	assert(value == OK)
	pass # Replace with function body.


func _exit_tree():
	get_tree().paused = false
