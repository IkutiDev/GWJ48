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
	queue_free()

func _on_SleepButton_mouse_entered() -> void:
	sleep_label.visible = true
	keep_going_label.visible = false

func _on_SleepButton_button_down() -> void:
	keep_going_button.disabled = true
	sleep_button.disabled = true
	visible = false
	var instance : SleepWindow = sleep_window.instance()
	instance.connect("SleepWindowClosed", self, "_on_KeepGoingButton_button_down")
	get_parent().add_child(instance)
	get_parent().move_child(instance, 0)


func _on_WaveCompletedPopup_tree_exiting() -> void:
	get_tree().paused = false


func _on_WaveCompletedPopup_about_to_show() -> void:
	get_tree().paused = true
