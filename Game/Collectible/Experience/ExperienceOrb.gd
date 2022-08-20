extends RigidBody2D

onready var area_2d: Area2D = $Area2D
onready var timer: Timer = $Timer

var experience : int

func activate_exp_orb(experience_to_earn : int):
	experience = experience_to_earn
	timer.connect("timeout", self, "_finish_activation")
	timer.start()
	
func _finish_activation():
	gravity_scale = 3
	area_2d.monitoring = true

func _physics_process(_delta: float) -> void:
	if not area_2d.monitoring:
		return 
	
	var bodies = area_2d.get_overlapping_bodies()
	
	if bodies.size() > 0:
		Events.emit_signal("increase_experience", experience)
		queue_free()
