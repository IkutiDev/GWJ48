extends RigidBody2D
class_name GhostBullet
onready var hurtbox: Area2D = $Hurtbox

var dead = false

var damage := 0

func _ready():
	$HitSound.pitch_scale = 1.0 + randf() * 0.6
	hurtbox.damage = damage
	$Explosion.rotation = randf()*2*PI

func _on_GhostBullet_body_entered(body : PhysicsBody2D):
	if body is Player:
		return
	pop()
	pass # Replace with function body.


func _on_OrphanTimer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_Hurtbox_dealt_damage(_damage) -> void:
	pop()


func pop():
	$PopAnimator.play("Pop")
	$HitSound.play()
	hurtbox.is_active = false
	call_deferred("enable_kinematic_mode")
	linear_velocity = Vector2(0,0)

func enable_kinematic_mode():
	mode = RigidBody2D.MODE_KINEMATIC

func _on_PopAnimator_animation_finished(anim_name: String) -> void:
	if anim_name == "Pop":
		queue_free()
