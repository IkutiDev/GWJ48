extends Area2D
class_name Hurtbox

signal dealt_damage(damage)

export var damage: int = 10
export var attack_each_frame_active := true

var targets_attacked : Array

var is_active: = true setget set_is_active

func _physics_process(_delta: float) -> void:
	if not monitoring:
		return 
	var areas = get_overlapping_areas()
	
	var targets_attacked_count_last_frame = targets_attacked.size()
	
	for a in areas:
		if not (a is Hitbox):
			continue
		
		if not attack_each_frame_active and targets_attacked.has(a):
			continue
		
		(a as Hitbox).take_damage(damage)
		if not attack_each_frame_active:
			targets_attacked.append(a)
			
	if targets_attacked_count_last_frame < targets_attacked.size():
		emit_signal("dealt_damage", damage)

func set_is_active(value: bool) -> void:
	is_active = value
	visible = value
	monitoring = value
	if not value:
		targets_attacked.clear()
