extends Control

func _ready():
	SoundManager.play_song(0)

func _on_Start_pressed():
	Events.testMode = false
	var value = get_tree().change_scene("res://Game.tscn")
	assert(value == OK)
	$VBoxContainer/HBoxContainer/Start.get_node("Click").volume_db = -80
	pass # Replace with function body.


func _on_Options_pressed():
	var instance = preload("res://MainMenu/OptionsMenu.tscn").instance()
	get_parent().add_child(instance)
	pass # Replace with function body.


func _on_Credits_pressed():
	var instance = preload("res://MainMenu/CreditsScreen.tscn").instance()
	get_parent().add_child(instance)
	pass # Replace with function body.


func _on_Boss_pressed():
	SoundManager.play_song(2)
	var value = get_tree().change_scene("res://Boss/TestBossRoom.tscn")
	assert(value == OK)
	pass # Replace with function body.


func _on_Start2_pressed():
	Events.testMode = true
	var value = get_tree().change_scene("res://Game.tscn")
	assert(value == OK)
	pass # Replace with function body.


func _on_Tutorial_pressed():
	$Tutorial.visible = true
	pass # Replace with function body.


func _on_Button_pressed():
	$Tutorial.visible = false
	pass # Replace with function body.
