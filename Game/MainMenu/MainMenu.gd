extends Control

func _ready():
	SoundManager.play_song(0)

func _on_Start_pressed():
	var value = get_tree().change_scene("res://Game.tscn")
	assert(value == OK)
	pass # Replace with function body.


func _on_Options_pressed():
	var value = get_tree().change_scene("res://MainMenu/OptionsMenu.tscn")
	assert(value == OK)
	pass # Replace with function body.


func _on_Credits_pressed():
	var value = get_tree().change_scene("res://MainMenu/CreditsScreen.tscn")
	assert(value == OK)
	pass # Replace with function body.
