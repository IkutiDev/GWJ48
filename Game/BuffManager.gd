class_name BuffManager
extends Node
onready var player: Player = $"%Player"

signal update_experience(total_experience)

var total_experience = 0

func _ready() -> void:
	Events.connect("increase_experience", self, "_on_IncreaseExperience")

func _on_IncreaseExperience(gained_experience : int):
	total_experience += gained_experience
	emit_signal("update_experience", total_experience)
