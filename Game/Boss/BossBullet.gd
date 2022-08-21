extends RigidBody2D


var player : Node2D

func _ready():
	$Hurtbox.damage = 24

func _on_OrphanTimer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_ArmTimer_timeout():
	$Glow.visible = true
	apply_torque_impulse(300)
	applied_force = global_position.direction_to(player.global_position).normalized() * 1580
	pass # Replace with function body.


func _on_WhizDetector_body_entered(body):
	$Whiz.pitch_scale = 1.1 + randf()*0.75
	$Whiz.play()
	pass # Replace with function body.
