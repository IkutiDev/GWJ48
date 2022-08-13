extends Position2D
class_name Hook, "res://Editor/icons/icon_hook.svg"
"""
Base hook class
"""

signal hooked_onto_target(target_global_position)

onready var ray_cast_2d: RayCast2D = $RayCast2D
onready var arrow: Node2D = $Arrow
onready var snap_detector: Area2D = $SnapDetector
onready var cooldown: Timer = $Cooldown

var is_active: = true

func can_hook() -> bool:
	return is_active and snap_detector.has_target() and cooldown.is_stopped()
	
func get_aim_direction() -> Vector2:
	var direction: = Vector2.ZERO
	
	direction = get_local_mouse_position().normalized()
	
	return direction
