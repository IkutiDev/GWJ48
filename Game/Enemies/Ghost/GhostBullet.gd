extends RigidBody2D


var damage = 1.0

func _ready():
	$Explosion.rotation = randf()*2*PI

func _on_GhostBullet_body_entered(body : PhysicsBody2D):
	if body.has_method("damage"):
		body.damage(damage)
	$PopAnimator.play("Pop")
	pass # Replace with function body.


func _on_OrphanTimer_timeout():
	queue_free()
	pass # Replace with function body.
