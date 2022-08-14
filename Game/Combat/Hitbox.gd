extends Area2D

signal got_hit
signal died

export var health: int = 100

var currentHealth : int = health setget set_current_health

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		emit_signal("got_hit")
		currentHealth -= (area as Hurtbox).damage 
		if (area as Hurtbox).destroy_on_collision:
			 (area as Hurtbox).destroy()
	
	
func set_current_health(value: int) -> void:
	currentHealth = value
	if currentHealth <= 0:
		emit_signal("died")
