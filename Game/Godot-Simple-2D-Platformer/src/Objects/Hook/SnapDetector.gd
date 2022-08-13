extends Area2D

onready var hooking_hint: Position2D = $HookingHint
onready var ray_cast_2d: RayCast2D = $RayCast2D

var target : HookTarget setget set_target

func _ready() -> void:
	ray_cast_2d.set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	self.target = find_best_target()

func find_best_target() -> HookTarget:
	var closest_target: HookTarget = null
	
	var targets: = get_overlapping_areas()
	
	for t in targets:
		if not t.is_active:
			continue
		
		ray_cast_2d.global_position = global_position
		ray_cast_2d.cast_to = t.global_position - ray_cast_2d.global_position
		if ray_cast_2d.is_colliding():
			continue
		closest_target = t
		break
	
	return closest_target


func has_target() -> bool:
	return target != null

func set_target(value: HookTarget) -> void:
	target = value
	hooking_hint.visible = has_target()
	hooking_hint.global_position = target.global_position if target else hooking_hint.global_position
