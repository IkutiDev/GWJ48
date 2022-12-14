extends KinematicBody2D
class_name Enemy, "res://Editor/icons/monster.svg"
"""
General class for all enemies
"""
const FLOOR_NORMAL: = Vector2.UP

enum enemy_life_state {Spawning = 0, Alive = 1, Dead = 2}

onready var skin: CharacterSkin = $Skin
onready var hitbox: Hitbox = $Hitbox
onready var atkSound: AudioStreamPlayer2D = $AttackSound

export var damage: float = 5.0

export var health: float = 20.0

export var score : int = 20

export var experience : int = 20

export var speed : float = 50.0

export var speed_difference_on_spawn_min : float = 0.0
export var speed_difference_on_spawn_max : float = 0.0

export var distance_to_attack : float = 25.0

var dropLoot = true

export(Array, Resource) var attack_sounds

var current_enemy_life_state : int = enemy_life_state.Spawning

var target : Node2D
var desiredLoc = Vector2()

var is_attacking := false

var can_teleport := false

var experience_orb_scene = preload("res://Collectible/Experience/ExperienceOrb.tscn")

var goldCoinScene = preload("res://Collectible/Gold/GoldCoin.tscn")

func buff_enemy(buff_counter: float) -> void:
	assert(buff_counter > 0)
	health *= buff_counter * 0.8
	damage *= buff_counter * 0.6
	score *= buff_counter * 0.75
	experience *= buff_counter * 0.75

func _ready() -> void:
	#Find the reference to target, as in the Player, from the group. 
	if get_tree().get_nodes_in_group("Player").size()>0:
		#This will break if we have more than 1 entity in player group so we do assert here to have a sanity check
		assert(get_tree().get_nodes_in_group("Player").size(), 1)
		target = get_tree().get_nodes_in_group("Player")[0]
	
	hitbox.current_health = health
	speed = speed + rand_range(speed_difference_on_spawn_min, speed_difference_on_spawn_max)

func _physics_process(delta):
	if target == null :
		desiredLoc = get_global_mouse_position()
	else:
		desiredLoc = target.global_position

func _is_enemy_alive() -> bool:
	return current_enemy_life_state == enemy_life_state.Alive

func _death() -> void:
	Events.emit_signal("spawner_record_death", self)
	current_enemy_life_state = enemy_life_state.Dead
	if !dropLoot:
		return
	while score > 0 :
		var newCoin = goldCoinScene.instance()
		newCoin.global_position = global_position
		get_tree().root.add_child(newCoin)
		newCoin.activate(7)
		score -= 7
	var exp_orb_instance = experience_orb_scene.instance()
	get_tree().root.add_child(exp_orb_instance)
	exp_orb_instance.global_position = global_position
	exp_orb_instance.activate(experience)
	

func _got_hit(damage: float) -> void:
	hitbox.current_health -= damage
