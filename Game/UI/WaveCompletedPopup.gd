extends PopupPanel

export var sleep_window : PackedScene

onready var keep_going_label: Label = $HBoxContainer/VBoxContainer/KeepGoingLabel
onready var sleep_label: Label = $HBoxContainer/VBoxContainer/SleepLabel
onready var keep_going_button: Button = $HBoxContainer/VBoxContainer/HBoxContainer/KeepGoingButton
onready var sleep_button: Button = $HBoxContainer/VBoxContainer/HBoxContainer/SleepButton


func _on_KeepGoingButton_mouse_entered() -> void:
	sleep_label.visible = false
	keep_going_label.visible = true

func _on_KeepGoingButton_button_down() -> void:
	var buffManager =  get_node("/root/Game/BuffManager") as BuffManager
	buffManager._on_IncreaseInsomnia()
	_close_popup()

func _close_popup():
	queue_free()

func _on_SleepButton_mouse_entered() -> void:
	sleep_label.visible = true
	keep_going_label.visible = false

func _on_SleepButton_button_down() -> void:
	keep_going_button.disabled = true
	sleep_button.disabled = true
	visible = false
	var instance : SleepWindow = sleep_window.instance()
	instance.connect("SleepWindowClosed", self, "_close_popup")
	get_parent().add_child(instance)
	get_parent().move_child(instance, 0)


func _on_WaveCompletedPopup_tree_exiting() -> void:
	get_tree().paused = false
