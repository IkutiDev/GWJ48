extends RigidBody2D

func _ready():
	$Explosion.rotation = randf()*2*PI

func _on_GhostBullet_body_entered(_body : PhysicsBody2D):
	$PopAnimator.play("Pop")
	linear_velocity = Vector2(0,0)
	pass # Replace with function body.


func _on_OrphanTimer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_Hurtbox_dealt_damage(_damage) -> void:
	queue_free()
