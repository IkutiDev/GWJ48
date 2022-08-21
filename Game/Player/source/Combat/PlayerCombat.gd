extends Node2D

signal health_changed(current_health)
signal shield_lost(shield_index)
signal shield_regained(shield_index)
signal shield_increased(shield_charges)

onready var player: Player = $".."
onready var hitbox: Hitbox = $Hitbox
onready var hurtbox: Hurtbox = $Hurtbox

onready var invincibility_timer: Timer = $InvincibilityTimer
onready var regain_shield_timer: Timer = $StateMachine/Block/RegainShieldTimer

export var health: float = 100.0
export var shield_charges: int = 3
export var normal_attack_damage: float = 10.0

var base_health = health
var current_health = health 
var current_shield_charges = shield_charges
var invincible := false

var block_active := false

var blocked_this_frame := false

func update_max_health(stacks : int)-> void:
	health = base_health + (25 * stacks)
func update_damage(stacks: int) -> void:
	hurtbox.damage = (normal_attack_damage + (10 * stacks))
func update_max_shield_charges(stacks : int)-> void:
	shield_charges = shield_charges + stacks
	emit_signal("shield_increased", shield_charges)
func _on_InvincibilityTimer_time_out()-> void:
	invincible = false
	blocked_this_frame = false

func gain_health(gain):
	current_health = min(current_health+gain,health)
	hitbox.current_health = current_health
	emit_signal("health_changed", current_health)
	pass

func _on_RegainShieldTimer_time_out() -> void:
	if current_shield_charges < shield_charges:
		emit_signal("shield_regained", current_shield_charges)
		current_shield_charges += 1

func regain_all_shield_charges() -> void:
	current_shield_charges = shield_charges
	emit_signal("shield_regained", current_shield_charges)

func _ready() -> void:
	yield(player, "ready")
	hitbox.current_health = health
	hurtbox.damage = normal_attack_damage
	var value = invincibility_timer.connect("timeout", self, "_on_InvincibilityTimer_time_out")
	assert(value == OK)
	value = player.buff_manager.connect("update_hp_up", self, "update_max_health")
	assert(value == OK)
	value = player.buff_manager.connect("update_dmg_up", self, "update_damage")
	assert(value == OK)
	value = player.buff_manager.connect("update_shield_up", self, "update_max_shield_charges")
	assert(value == OK)
	value = Events.connect("health_gained",self,"gain_health")
	regain_shield_timer.connect("timeout", self, "_on_RegainShieldTimer_time_out")
	

func _on_Hitbox_got_hit(damage) -> void:
	if invincible:
		return
	invincibility_timer.start()
	invincible = true
	if blocked_this_frame:
		return
	if block_active:
		blocked_this_frame = true
		player.skin.play_animation_player("shield")
		current_shield_charges -= 1
		emit_signal("shield_lost", current_shield_charges)
		return
	player.skin.play_animation_player("hurt")
	hitbox.current_health -= (damage * (player.buff_manager.insomnia_stacks + 1))
	emit_signal("health_changed", hitbox.current_health)
	if hitbox.current_health > 0:
		player.audio_player.play_pain_SFX()
	current_health = hitbox.current_health


func _on_Hitbox_died() -> void:
	player.state_machine.transition_to("Die")
