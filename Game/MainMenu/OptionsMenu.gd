extends VBoxContainer



func _on_Button_pressed():
	var value = get_tree().change_scene("res://MainMenu/MainMenu.tscn")
	assert(value == OK)
	pass # Replace with function body.
