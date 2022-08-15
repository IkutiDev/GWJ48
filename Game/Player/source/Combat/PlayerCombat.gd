extends Node2D

signal health_changed(current_health)

onready var player: Player = $".."
onready var hitbox: Hitbox = $Hitbox
onready var hurtbox: Hurtbox = $Hurtbox

onready var invincibility_timer: Timer = $InvincibilityTimer

export var health: int = 100
export var shield_charges: int = 3
export var normal_attack_damage: int = 10

var current_health = health 
var current_shield_charges = shield_charges
var invincible := false

var block_active := false

func _on_InvincibilityTimer_time_out()-> void:
	invincible = false

func _ready() -> void:
	hitbox.current_health = health
	hurtbox.damage = normal_attack_damage
	var value = invincibility_timer.connect("timeout", self, "_on_InvincibilityTimer_time_out")
	assert(value == OK)

func _on_Hitbox_got_hit(damage) -> void:
	if invincible:
		return
	if block_active:
		current_shield_charges -= 1
		return
	invincibility_timer.start()
	invincible = true
	player.skin.play_animation_player("hurt")
	hitbox.current_health -= damage
	emit_signal("health_changed", hitbox.current_health)
	if hitbox.current_health > 0:
		player.audio_player.play_pain_SFX()
	current_health = hitbox.current_health


func _on_Hitbox_died() -> void:
	player.state_machine.transition_to("Die")
