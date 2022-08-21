class_name SleepWindow
extends Control
onready var wake_up_button: Button = $VBoxContainer/HBoxContainer/WakeUpButton
onready var spend_exp_button: Button = $VBoxContainer/HBoxContainer/SpendExpButton
onready var skill_tree_window: Control = $SkillTreeWindow
onready var experience_dynamic_label: Label = $SkillTreeWindow/ExperienceDynamicLabel

onready var dmgup__button: Button = $SkillTreeWindow/BuffsIcons/DMGUp/dmgup_Button
onready var dmgup__cost_label: Label = $SkillTreeWindow/BuffsIcons/DMGUp/dmgup_CostLabel
onready var dmgup__cost_label_dynamic: Label = $SkillTreeWindow/BuffsIcons/DMGUp/dmgup_CostLabelDynamic
onready var dmgup: BuffIcon = $SkillTreeWindow/BuffsIcons/DMGUp

onready var hpup__button: Button = $SkillTreeWindow/BuffsIcons/HPUp/hpup_Button
onready var hpup__cost_label: Label = $SkillTreeWindow/BuffsIcons/HPUp/hpup_CostLabel
onready var hpup__cost_label_dynamic: Label = $SkillTreeWindow/BuffsIcons/HPUp/hpup_CostLabelDynamic
onready var hpup: BuffIcon = $SkillTreeWindow/BuffsIcons/HPUp

onready var shieldup__button: Button = $SkillTreeWindow/BuffsIcons/ShieldUp/shieldup_Button
onready var shieldup__cost_label: Label = $SkillTreeWindow/BuffsIcons/ShieldUp/shieldup_CostLabel
onready var shieldup__cost_label_dynamic: Label = $SkillTreeWindow/BuffsIcons/ShieldUp/shieldup_CostLabelDynamic
onready var shield_up: BuffIcon = $SkillTreeWindow/BuffsIcons/ShieldUp


export(Array, int) var dmg_up_costs : Array
export(Array, int) var hp_up_costs : Array
export(Array, int) var shield_up_costs : Array

var player : Player
var buff_manager : BuffManager

signal SleepWindowShowed()
signal SleepWindowClosed()

func _ready() -> void:

	SoundManager.play_song(4)
	player = get_node("/root/Game/Player")
	buff_manager = get_node("/root/Game/BuffManager")  as BuffManager
	dmgup.set_buff_stack(buff_manager.dmg_up_stacks)
	if not check_if_max_stacks_dmg_up():
		dmgup__cost_label_dynamic.text = str(dmg_up_costs[buff_manager.dmg_up_stacks])
	hpup.set_buff_stack(buff_manager.hp_up_stacks)
	if not check_if_max_stacks_hp_up():
		hpup__cost_label_dynamic.text = str(hp_up_costs[buff_manager.hp_up_stacks])
	shield_up.set_buff_stack(buff_manager.shield_up_stacks)
	if not check_if_max_stacks_shield_up():
		shieldup__cost_label_dynamic.text = str(shield_up_costs[buff_manager.shield_up_stacks])

func check_if_max_stacks_dmg_up() -> bool:
	if buff_manager.dmg_up_stacks == dmg_up_costs.size():
		dmgup__button.disabled = true
		dmgup__cost_label.visible = false
		dmgup__cost_label_dynamic.visible = false
		return true
	return false

func check_if_max_stacks_hp_up() -> bool:
	if buff_manager.hp_up_stacks == hp_up_costs.size():
		hpup__button.disabled = true
		hpup__cost_label.visible = false
		hpup__cost_label_dynamic.visible = false
		return true
	return false
	
func check_if_max_stacks_shield_up() -> bool:
	if buff_manager.shield_up_stacks == shield_up_costs.size():
		shieldup__button.disabled = true
		shieldup__cost_label.visible = false
		shieldup__cost_label_dynamic.visible = false
		return true
	return false

func _exit_tree():
	SoundManager.play_song(1)

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
	player.state_machine.transition_to("Spawn", {"afterSleep":true})
	var buffManager =  get_node("/root/Game/BuffManager") as BuffManager
	buffManager._on_ClearInsomnia()
	$Fader.play("FadeOut")


func _on_SpendExpButton_button_down() -> void:
	skill_tree_window.visible = true
	experience_dynamic_label.text = str(buff_manager.total_experience)

func Spend_experience(experience_spent : int) -> void:
	buff_manager._on_DecreaseExperience(experience_spent)
	experience_dynamic_label.text = str(buff_manager.total_experience)

func _on_Button_button_down() -> void:
	skill_tree_window.visible = false


func _on_dmgup_Button_button_down() -> void:
	if dmg_up_costs[buff_manager.dmg_up_stacks] <=  buff_manager.total_experience:
		Spend_experience(dmg_up_costs[buff_manager.dmg_up_stacks])
		buff_manager._on_IncreaseDamage()
		dmgup.set_buff_stack(buff_manager.dmg_up_stacks)
		if not check_if_max_stacks_dmg_up():
			dmgup__cost_label_dynamic.text = str(dmg_up_costs[buff_manager.dmg_up_stacks])


func _on_hpup_Button_button_down() -> void:
	if hp_up_costs[buff_manager.hp_up_stacks] <=  buff_manager.total_experience:
		Spend_experience(hp_up_costs[buff_manager.hp_up_stacks])
		buff_manager._on_IncreaseHP()
		hpup.set_buff_stack(buff_manager.hp_up_stacks)
		if not check_if_max_stacks_hp_up():
			hpup__cost_label_dynamic.text = str(hp_up_costs[buff_manager.hp_up_stacks])


func _on_shieldup_Button_button_down() -> void:
	if shield_up_costs[buff_manager.shield_up_stacks] <=  buff_manager.total_experience:
		Spend_experience(shield_up_costs[buff_manager.shield_up_stacks])
		buff_manager._on_IncreaseShield()
		shield_up.set_buff_stack(buff_manager.shield_up_stacks)
		if not check_if_max_stacks_shield_up():
			shieldup__cost_label_dynamic.text = str(shield_up_costs[buff_manager.shield_up_stacks])
