extends CanvasLayer

var pauseMenuScene = preload("res://UI/PauseMenu.tscn")
var buffIcon = preload("res://Buff/BuffIcon.tscn")
onready var score_dynamic_value: Label = $ScoreDynamicValue
onready var experience_dynamic_value: Label = $ExperienceDynamicValue
onready var shield_icons: HBoxContainer = $ShieldIcons

onready var insomnia: BuffIcon = $BuffsIcons/Insomnia
onready var dmgup: Panel = $BuffsIcons/DMGUp
onready var hpup: Panel = $BuffsIcons/HPUp
onready var shield_up: Panel = $BuffsIcons/ShieldUp
onready var triple_jump: Panel = $BuffsIcons/TripleJump
onready var speed_up: Panel = $BuffsIcons/SpeedUp
onready var jump_up: Panel = $BuffsIcons/JumpUp


onready var buff_manager: BuffManager = $"../BuffManager"
onready var player = $"%Player"

var current_score = 0

func _on_HealthUpdated(current_health: float):

	if ((current_health)/ player.get_max_health())*100 < $HP.value:
		$DamageScreenFlash/AnimationPlayer.play("New Anim") # flash red on screen
	$HP.value = ((current_health)/ player.get_max_health())*100

	
func _on_ShieldRegained(shield_index: int):
	var animation_player : AnimationPlayer = shield_icons.get_child(shield_index).get_node("AnimationPlayer")
	animation_player.play("regain")

func _on_ShieldIncreased(shield_charges: int):
	for i in shield_charges:
		(shield_icons.get_child(i) as Control).visible = true

func _on_ShieldLost(shield_index: int):
	var animation_player : AnimationPlayer = shield_icons.get_child(shield_index).get_node("AnimationPlayer")
	animation_player.play("break")

func _on_ScoreUpdated(score_to_add: int):
	current_score += score_to_add * (buff_manager.insomnia_stacks + 1)
	score_dynamic_value.text = str(current_score)
	Events.score = current_score

func _on_ExperienceUpdated(total_experience: int):
	experience_dynamic_value.text = str(total_experience)

func _on_InsomniaUpdated(total_insomnia_stacks: int):
	insomnia.set_buff_stack(total_insomnia_stacks)
	
func _on_DamageBuffUpdated(total_stacks: int):
	dmgup.set_buff_stack(total_stacks)
	
func _on_HealthBuffUpdated(total_stacks: int):
	hpup.set_buff_stack(total_stacks)

func _on_ShieldBuffUpdated(total_stacks: int):
	shield_up.set_buff_stack(total_stacks)
	
func _on_TripleJumpAdded(total_stacks: int):
	triple_jump.set_buff_stack(total_stacks)
	
func _on_JumpUpAdded(total_stacks: int):
	jump_up.set_buff_stack(total_stacks)
	
func _on_SpeedUpAdded(total_stacks: int):
	speed_up.set_buff_stack(total_stacks)

func _ready() -> void:
	yield(player, "ready")
	player.player_combat.connect("health_changed", self, "_on_HealthUpdated")
	player.player_combat.connect("shield_lost", self, "_on_ShieldLost")
	player.player_combat.connect("shield_regained", self, "_on_ShieldRegained")
	player.player_combat.connect("shield_increased",self, "_on_ShieldIncreased")
	var value = Events.connect("score_gained", self, "_on_ScoreUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_experience", self, "_on_ExperienceUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_insomnia", self, "_on_InsomniaUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_dmg_up", self, "_on_DamageBuffUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_hp_up", self, "_on_HealthBuffUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_shield_up", self, "_on_ShieldBuffUpdated")
	assert(value == OK)
	value = buff_manager.connect("update_triple_jump", self, "_on_TripleJumpAdded")
	assert(value == OK)
	value = buff_manager.connect("update_jump_up", self, "_on_JumpUpAdded")
	assert(value == OK)
	value = buff_manager.connect("update_speed_up", self, "_on_SpeedUpAdded")
	assert(value == OK)
	_on_HealthUpdated(player.get_current_health())
	score_dynamic_value.text = str(current_score)
	experience_dynamic_value.text = str(buff_manager.total_experience)



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		add_child(pauseMenuScene.instance())
		pass
