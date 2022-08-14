extends Control

func _ready():
	SoundManager.play_song(0)

func _on_Start_pressed():
	get_tree().change_scene("res://Game.tscn")
	pass # Replace with function body.


func _on_Options_pressed():
	get_tree().change_scene("res://MainMenu/AudioSettings/AudioSettings.tscn")
	pass # Replace with function body.


func _on_Credits_pressed():
	get_tree().change_scene("res://MainMenu/CreditsScreen.tscn")
	pass # Replace with function body.
