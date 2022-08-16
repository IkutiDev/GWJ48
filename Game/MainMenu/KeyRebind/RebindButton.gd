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
	else:
		display_current_key()


func _unhandled_input(event:InputEvent):
	if pressed and (event.is_class("InputEventJoypadButton") or event.is_class("InputEventKey")):
		remap_action_to(event)
		pressed = false


func remap_action_to(event:InputEvent):
	# We first change the event in this game instance.
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	# And then save it to the keymaps file
	KeyPersistence.keymaps[action] = event
	KeyPersistence.save_keymap()



func display_current_key():
#	if event.is_class("InputEventJoypadButton"):
#		print("test")
#		text = "%s Key" % "Button" + String(event.button_index)
	var current_key = InputMap.get_action_list(action)[0].as_text()
	text = "%s Key" % current_key
