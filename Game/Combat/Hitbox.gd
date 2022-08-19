extends Area2D
class_name Hitbox

signal got_hit(damage)
signal died

var current_health : float = INF setget set_current_health

func take_damage(damage: float) -> void:
	emit_signal("got_hit", damage)
	

func set_current_health(value: float) -> void:
	current_health = value
	if current_health <= 0:
		emit_signal("died")
