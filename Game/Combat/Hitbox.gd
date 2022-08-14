extends Area2D
class_name Hitbox

signal got_hit(damage)
signal died

var current_health : int = INF setget set_current_health

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		emit_signal("got_hit", (area as Hurtbox).damage)
		if (area as Hurtbox).destroy_on_collision:
			 (area as Hurtbox).destroy()
	
	
func set_current_health(value: int) -> void:
	current_health = value
	if current_health <= 0:
		emit_signal("died")
