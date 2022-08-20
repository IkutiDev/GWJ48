extends CanvasLayer

var pauseMenuScene = preload("res://UI/PauseMenu.tscn")
var buffIcon = preload("res://Buff/BuffIcon.tscn")
onready var score_dynamic_value: Label = $ScoreDynamicValue
onready var experience_dynamic_value: Label = $ExperienceDynamicValue
onready var shield_icons: HBoxContainer = $ShieldIcons

onready var insomnia: BuffIcon = $BuffsIcons/Insomnia


onready var buff_manager: BuffManager = $"../BuffManager"
onready var player = $"%Player"

var current_score = 0

func _on_HealthUpdated(current_health: float):
	$HP.value = current_health
	
func _on_ShieldRegained(shield_index: int):
	var animation_player : AnimationPlayer = shield_icons.get_child(shield_index).get_node("AnimationPlayer")
	animation_player.play("regain")

func _on_ShieldLost(shield_index: int):
	var animation_player : AnimationPlayer = shield_icons.get_child(shield_index).get_node("AnimationPlayer")
	animation_player.play("break")

func _on_ScoreUpdated(score_to_add: int):
	current_score += score_to_add * (buff_manager.insomnia_stacks + 1)
	score_dynamic_value.text = str(current_score)

func _on_ExperienceUpdated(total_experience: int):
	experience_dynamic_value.text = str(total_experience)

func _on_InsomniaUpdated(total_insomnia_stacks: int):
	insomnia.set_buff_stack(total_insomnia_stacks)

func _ready() -> void:
	yield(player, "ready")
	player.player_combat.connect("health_changed", self, "_on_HealthUpdated")
	player.player_combat.connect("shield_lost", self, "_on_ShieldLost")
	player.player_combat.connect("shield_regained", self, "_on_ShieldRegained")
	var value = Events.connect("score_gained", self, "_on_ScoreUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_experience", self, "_on_ExperienceUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_insomnia", self, "_on_InsomniaUpdated")
	assert(value == OK)
	_on_HealthUpdated(player.get_current_health())
	score_dynamic_value.text = str(current_score)
	experience_dynamic_value.text = str(buff_manager.total_experience)



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		add_child(pauseMenuScene.instance())
		pass
