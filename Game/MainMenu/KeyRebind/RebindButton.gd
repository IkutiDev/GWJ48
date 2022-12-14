extends Button

export(String) var action = "ui_up"

func _ready():
	assert(InputMap.has_action(action))
	set_process_unhandled_key_input(false)
	display_current_key()


func _toggled(button_pressed):
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		text = "... Key"
		release_focus()
		$Click.play()
	else:
		display_current_key()


func _unhandled_input(event:InputEvent):
	if pressed and (event.is_class("InputEventJoypadButton") or event.is_class("InputEventKey") or event.is_class("InputEventJoypadMotion")):
		remap_action_to(event)
		pressed = false


func remap_action_to(event:InputEvent):
	# We first change the event in this game instance.
	KeyPersistence.action_erase_without_mouse_input(action)
	InputMap.action_add_event(action, event)
	# And then save it to the keymaps file
	KeyPersistence.keymaps[action] = event
	KeyPersistence.save_keymap()

func display_current_key():
	var current_key : String = "None"
	for i in InputMap.get_action_list(action):
		if i is InputEventJoypadButton :
			current_key = "GAMEPAD "+String(i.button_index)
		if i is InputEventKey:
			current_key = i.as_text()
	text = "%s Key" % current_key



func _on_RebindButton_mouse_entered():
	$Hover.play()
	pass # Replace with function body.
