extends Area2D
class_name Hurtbox

export var damage: int = 10
export var destroy_on_collision := false


func destroy() -> void:
	queue_free()
