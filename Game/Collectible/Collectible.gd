class_name Collectible
extends RigidBody2D

onready var area_2d: Area2D = $Area2D
onready var timer: Timer = $Timer

var value : int

func activate(value_to_earn : int):
	value = value_to_earn
	timer.connect("timeout", self, "_finish_activation")
	timer.start()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x_value : float = rng.randf_range(-50.0, 50.0)
	apply_central_impulse(Vector2(x_value, -100))
	
func _finish_activation():
	gravity_scale = 3
	area_2d.monitoring = true

func _physics_process(_delta: float) -> void:
	if not area_2d.monitoring:
		return 
	
	var bodies = area_2d.get_overlapping_bodies()
	
	if bodies.size() > 0:
		_on_Pickup()
		queue_free()

func _on_Pickup():
	pass
