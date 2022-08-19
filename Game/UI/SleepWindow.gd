class_name SleepWindow
extends Control
onready var wake_up_button: Button = $VBoxContainer/HBoxContainer/WakeUpButton
onready var spend_exp_button: Button = $VBoxContainer/HBoxContainer/SpendExpButton
onready var skill_tree_window: Control = $SkillTreeWindow

var player : Player

signal SleepWindowShowed()
signal SleepWindowClosed()

func _ready() -> void:
	player = get_node("/root/Game/Player")

func _on_Fader_animation_finished(anim_name: String) -> void:
	if anim_name == "FadeIn":
		emit_signal("SleepWindowShowed")
	if anim_name == "FadeOut":
		emit_signal("SleepWindowClosed")
		queue_free()


func _on_SleepWindow_tree_entered() -> void:
	$Fader.play("FadeIn")


func _on_WakeUpButton_button_down() -> void:
	wake_up_button.disabled = true
	spend_exp_button.disabled = true
	player.state_machine.transition_to("Spawn")
	$Fader.play("FadeOut")


func _on_SpendExpButton_button_down() -> void:
	skill_tree_window.visible = true


func _on_Button_button_down() -> void:
	skill_tree_window.visible = false
