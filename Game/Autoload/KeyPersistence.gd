# This is an autoload (singleton) which will save
# the key maps (AND audio layout) in a simple way through a dictionary.
extends Node

const keymaps_path = "user://keymaps.dat"
const audio_path = "user://audio.dat"
var keymaps: Dictionary

var audioLayout = {
	"Master" : 0,
	"Music" : 0,
	"Ambience" : 0,
	"Effects" : 0
	}

func _ready() -> void:
	# First we create the keymap dictionary on startup with all
	# the keymap actions we have.
	for action in InputMap.get_actions():
		keymaps[action] = InputMap.get_action_list(action)[0]
	load_keymap()
	load_audio_layout()

func load_keymap() -> void:
	var file := File.new()
	if not file.file_exists(keymaps_path):
		save_keymap() # There is no save file yet, so let's create one.
		return
	#warning-ignore:return_value_discarded
	file.open(keymaps_path, File.READ)
	var temp_keymap: Dictionary = file.get_var(true)
	file.close()
	# We don't just replace the keymaps dictionary, because if you
	# updated your game and removed/added keymaps, the data of this
	# save file may have invalid actions. So we check one by one to
	# make sure that the keymap dictionary really has all current actions.
	for action in keymaps.keys():
		if temp_keymap.has(action):
			keymaps[action] = temp_keymap[action]
			# Whilst setting the keymap dictionary, we also set the
			# correct InputMap event
			action_erase_without_mouse_input(action)
			InputMap.action_add_event(action, keymaps[action])


func save_audio_layout():
	
	
	for A in audioLayout.keys():
		audioLayout[A] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(A))
	
	var file := File.new()
	file.open(audio_path, File.WRITE)
	file.store_var(audioLayout, true)
	file.close()
	
	
	pass

func load_audio_layout():

	var file := File.new()
	if not file.file_exists(audio_path):
		save_audio_layout()
		return
	#warning-ignore:return_value_discarded
	file.open(audio_path, File.READ)
	audioLayout = file.get_var(true)
	file.close()
	for A in audioLayout.keys():
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(A),audioLayout[A])
	pass

func save_keymap() -> void:
	# For saving the keymap, we just save the entire dictionary as a var.
	var file := File.new()
	#warning-ignore:return_value_discarded
	file.open(keymaps_path, File.WRITE)
	file.store_var(keymaps, true)
	file.close()

static func action_erase_without_mouse_input(action : String) -> void:
	var inputEvents = InputMap.get_action_list(action)
	
	for i in inputEvents:
		if not i is InputEventMouse:
			InputMap.action_erase_event(action, i)
