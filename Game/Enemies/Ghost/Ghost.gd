extends KinematicBody2D

var bulletScene = preload("res://Enemies/Ghost/GhostBullet.tscn")

export var wobble = 0.0

export var speedModifier = 1.0

var baseSpeed = 50.0

var desiredLoc = Vector2()

var target : Node2D

var attackMode = false


var cooldown = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_nodes_in_group("Player").size()>0:
		target = get_tree().get_nodes_in_group("Player")[0]

	pass # Replace with function body.

func fire_bullet():
	var newBullet = bulletScene.instance()
	newBullet.global_position = global_position
	var attackDir = target.global_position - global_position
	attackDir = attackDir.normalized()
	newBullet.apply_central_impulse(attackDir * 59.8) 
	get_parent().add_child(newBullet)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null :
		desiredLoc = get_global_mouse_position()
	else:
		desiredLoc = target.global_position
	desiredLoc.y += wobble
	var direction =  desiredLoc - global_position
	var distance = direction.length()
	direction = direction.normalized()
	var distanceSpeedBonus = Vector2(4.0 - min(4.0,(distance + 200.0) / distance),1.0)
	move_and_collide(direction * baseSpeed * speedModifier * distanceSpeedBonus * delta )
	cooldown -= delta
	if cooldown < 0.0 and attackMode:
		cooldown += 7.0
		fire_bullet()



func _on_AttackRange_body_entered(body):
	attackMode = true
	pass # Replace with function body.


func _on_AttackRange_body_exited(body):
	attackMode = false
	pass # Replace with function body.
