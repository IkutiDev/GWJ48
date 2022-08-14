extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hitbox: Area2D = $Hitbox

var spawning = true

var target : Node2D
var velocity = Vector2.ZERO
var desiredLoc : Vector2 = Vector2.ZERO
var base_speed : float = 50.0
export var speed_modifier: float = 1.0
export var health := 10


func _on_AnimatedSpriteDeath_finished(name: String) -> void:
	get_tree().get_nodes_in_group("Spawner")[0].record_death(self)
	animation_player.disconnect("animation_finished", self, "_on_AnimatedSpriteDeath_finished")
	queue_free()
	
func _on_AnimatedSpriteSpawn_finished(name: String) -> void:
	animation_player.disconnect("animation_finished", self, "_on_AnimatedSpriteSpawn_finished")
	spawning = false

func _ready() -> void:
	spawning = true
	if get_tree().get_nodes_in_group("Player").size()>0:
		target = get_tree().get_nodes_in_group("Player")[0]
	animation_player.play("spawn")
	animation_player.connect("animation_finished", self, "_on_AnimatedSpriteSpawn_finished")
	hitbox.current_health = health


func _physics_process(delta):
	if spawning:
		return
	if target == null :
		desiredLoc = get_global_mouse_position()
	else:
		desiredLoc = target.global_position
		
	velocity = Steering.follow(velocity,global_position,desiredLoc,base_speed*speed_modifier,1)
	move_and_collide(velocity* delta)


func _on_Hurtbox_dealt_damage(damage) -> void:
	pass # Replace with function body.


func _on_Hitbox_got_hit(damage) -> void:
	hitbox.current_health -= damage



func _on_Hitbox_died() -> void:
	animation_player.play("death")
	animation_player.connect("animation_finished", self, "_on_AnimatedSpriteDeath_finished")
