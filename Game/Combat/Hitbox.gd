extends Area2D
class_name Hitbox

signal got_hit(damage)
signal died

var current_health : int = INF setget set_current_health

func take_damage(damage: int) -> void:
	emit_signal("got_hit", damage)
	

func set_current_health(value: int) -> void:
	current_health = value
	if current_health <= 0:
		emit_signal("died")
