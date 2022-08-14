extends KinematicBody2D

var bulletScene = preload("res://Enemies/Ghost/GhostBullet.tscn")
onready var hitbox: Hitbox = $Hitbox
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

export var wobble = 0.0

export var speedModifier = 1.0

export var bulletSpeed = 150

export var health = 20

var velocity = Vector2(0,0)

var baseSpeed = 50.0

var desiredLoc = Vector2()

var target : Node2D

var attackMode = false


var cooldown = 0.0

var spawning = true
var dead = false


func _on_AnimatedSpriteDeath_finished() -> void:
	get_tree().get_nodes_in_group("Spawner")[0].record_death(self)
	animated_sprite.disconnect("animation_finished", self, "_on_AnimatedSpriteDeath_finished")
	queue_free()

func _on_AnimatedSpriteHit_finished() -> void:
	animated_sprite.disconnect("animation_finished", self, "_on_AnimatedSpriteHit_finished")
	animated_sprite.play("float")
	
func _on_AnimatedSpriteSpawn_finished() -> void:
	animated_sprite.disconnect("animation_finished", self, "_on_AnimatedSpriteSpawn_finished")
	animated_sprite.play("float")
	spawning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawning = true
	if get_tree().get_nodes_in_group("Player").size()>0:
		target = get_tree().get_nodes_in_group("Player")[0]
	
	animated_sprite.play("spawn")
	var value = animated_sprite.connect("animation_finished", self, "_on_AnimatedSpriteSpawn_finished")
	assert(value == OK)
	hitbox.current_health = health
	pass # Replace with function body.

func fire_bullet():
	if spawning or dead:
		return
	var newBullet = bulletScene.instance()
	newBullet.global_position = global_position
	var attackDir = target.global_position - global_position
	attackDir = attackDir.normalized()
	newBullet.apply_central_impulse(attackDir * bulletSpeed) 
	get_parent().add_child(newBullet)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if spawning or dead:
		return
	if target == null :
		desiredLoc = get_global_mouse_position()
	else:
		desiredLoc = target.global_position
		
	velocity = Steering.follow(velocity,global_position,desiredLoc,baseSpeed*speedModifier,30)
	var _collision = move_and_collide((velocity + Vector2(0,wobble) )* delta)
	cooldown -= delta
	if cooldown < 0.0 and attackMode:
		cooldown += 7.0
		fire_bullet()



func _on_AttackRange_body_entered(_body):
	attackMode = true
	pass # Replace with function body.


func _on_AttackRange_body_exited(_body):
	attackMode = false
	pass # Replace with function body.


func _on_Hitbox_got_hit(damage) -> void:
	if spawning or dead:
		return
	if hitbox.current_health <= 0:
		return
	hitbox.current_health -= damage
	if hitbox.current_health > 0:
		animated_sprite.play("hit")
		if not animated_sprite.is_connected("animation_finished", self, "_on_AnimatedSpriteHit_finished"):
			var value = animated_sprite.connect("animation_finished", self, "_on_AnimatedSpriteHit_finished")
			assert(value == OK)


func _on_Hitbox_died() -> void:
	
	# (#Ikuti) Add gain score here
	# (#Ikuti) Add drop exp/stuff here
	dead = true
	animated_sprite.play("death")
	var value = animated_sprite.connect("animation_finished", self, "_on_AnimatedSpriteDeath_finished")
	assert(value == OK)
