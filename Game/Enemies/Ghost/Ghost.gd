extends KinematicBody2D

var bulletScene = preload("res://Enemies/Ghost/GhostBullet.tscn")
onready var hitbox: Hitbox = $Hitbox
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

export var wobble = 0.0

export var speedModifier = 1.0

export var health = 20

var velocity = Vector2(0,0)

var baseSpeed = 50.0

var desiredLoc = Vector2()

var target : Node2D

var attackMode = false


var cooldown = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_nodes_in_group("Player").size()>0:
		target = get_tree().get_nodes_in_group("Player")[0]
	
	hitbox.current_health = health
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
func _physics_process(delta):
	if target == null :
		desiredLoc = get_global_mouse_position()
	else:
		desiredLoc = target.global_position
		
	velocity = Steering.follow(velocity,global_position,desiredLoc,baseSpeed*speedModifier,1)
	move_and_collide((velocity + Vector2(0,wobble) )* delta)
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


func _on_Hitbox_got_hit(damage) -> void:
	# (#Ikuti) Add stagger/push code here, maybe
	hitbox.current_health -= damage

func _on_AnimatedSprite_finished() -> void:
	get_tree().get_nodes_in_group("Spawner")[0].record_death(self)
	animated_sprite.disconnect("animation_finished", self, "_on_AnimatedSprite_finished")
	queue_free()

func _on_Hitbox_died() -> void:
	# (#Ikuti) Add gain score here
	# (#Ikuti) Add drop exp/stuff here
	animated_sprite.play("death")
	animated_sprite.connect("animation_finished", self, "_on_AnimatedSprite_finished")
