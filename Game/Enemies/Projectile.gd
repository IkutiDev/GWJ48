class_name Projectile
extends RigidBody2D
onready var hurtbox: Area2D = $Hurtbox

var dead = false

var damage := 0

func _ready():
	hurtbox.damage = damage

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
	hurtbox.is_active = false
	call_deferred("enable_kinematic_mode")
	linear_velocity = Vector2(0,0)
	queue_free()

func enable_kinematic_mode():
	mode = RigidBody2D.MODE_KINEMATIC
