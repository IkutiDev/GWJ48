class_name BuffManager
extends Node

signal update_experience(total_experience)
signal update_insomnia(total_stacks)
signal update_dmg_up(total_stacks)
signal update_hp_up(total_stacks)
signal update_shield_up(total_stacks)
signal update_triple_jump(total_stacks)
signal update_jump_up(total_stacks)
signal update_speed_up(total_stacks)

var insomnia_stacks = 0
var dmg_up_stacks = 0
var hp_up_stacks = 0
var shield_up_stacks = 0
var triple_jump_stack = 0
var jump_up_stacks = 0
var speed_up_stacks = 0
var total_experience = 0

func _ready() -> void:
	Events.connect("increase_experience", self, "_on_IncreaseExperience")

func _on_IncreaseExperience(gained_experience : int):
	total_experience += gained_experience * (insomnia_stacks+1)
	emit_signal("update_experience", total_experience)

func _on_DecreaseExperience(decreased_experience : int):
	total_experience -= decreased_experience
	emit_signal("update_experience", total_experience)

func _on_IncreaseDamage():
	dmg_up_stacks += 1
	emit_signal("update_dmg_up", dmg_up_stacks)
	
func _on_IncreaseHP():
	hp_up_stacks += 1
	emit_signal("update_hp_up", hp_up_stacks)
	
func _on_IncreaseShield():
	shield_up_stacks += 1
	emit_signal("update_shield_up", shield_up_stacks)
	
func _on_AddTripleJump():
	triple_jump_stack = 1
	emit_signal("update_triple_jump", triple_jump_stack)
	
func _on_IncreaseJumpPower():
	jump_up_stacks += 1
	emit_signal("update_jump_up", jump_up_stacks)
	
func _on_IncreaseSpeed():
	speed_up_stacks += 1
	emit_signal("update_speed_up", speed_up_stacks)

func _on_IncreaseInsomnia():
	insomnia_stacks += 1
	emit_signal("update_insomnia", insomnia_stacks)
	
func _on_ClearInsomnia():
	insomnia_stacks = 0
	emit_signal("update_insomnia", insomnia_stacks)
