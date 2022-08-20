class_name BuffManager
extends Node

signal update_experience(total_experience)
signal update_insomnia(total_stacks)

var insomnia_stacks = 0
var total_experience = 0

func _ready() -> void:
	Events.connect("increase_experience", self, "_on_IncreaseExperience")

func _on_IncreaseExperience(gained_experience : int):
	total_experience += gained_experience * (insomnia_stacks+1)
	emit_signal("update_experience", total_experience)

func _on_IncreaseInsomnia():
	insomnia_stacks += 1
	emit_signal("update_insomnia", insomnia_stacks)
	
func _on_ClearInsomnia():
	insomnia_stacks = 0
	emit_signal("update_insomnia", insomnia_stacks)
