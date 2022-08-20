extends VBoxContainer

func _exit_tree():
	KeyPersistence.save_audio_layout()
