extends Node2D

signal health_changed(current_health)
signal shield_lost(shield_index)
signal shield_regained(shield_index)
signal shield_increased(shield_charges)

onready var player: Player = $".."
onready var hitbox: Hitbox = $Hitbox
onready var normal_attack_hurtbox: Hurtbox = $NormalAttackHurtbox
onready var shield_break_hurtbox: Hurtbox = $ShieldBreakHurtbox
onready var shield_break_timer: Timer = $StateMachine/Block/ShieldBreakTimer


onready var invincibility_timer: Timer = $InvincibilityTimer
onready var regain_shield_timer: Timer = $StateMachine/Block/RegainShieldTimer

onready var spell_animation_player: AnimationPlayer = $"../Skin/SpellAnimationPlayer"


export var health: float = 100.0
export var mana: float = 50.0
export var shield_charges: int = 3
export var normal_attack_damage: float = 10.0
export var shield_break_damage: float = 7.5

onready var normal_attack_base_damage: float = normal_attack_damage
onready var shield_break_base_damage: float = shield_break_damage

onready var base_health = health
onready var base_mana = mana
onready var base_shield_charges = shield_charges
var current_health = health 
onready var current_mana = mana
var current_shield_charges = shield_charges
var invincible := false

var mana_regen : float = 2
var spell_cost : float = 25.0

var health_regen : float = 1

var block_active := false
var stop_movement := false
var spell_active := false

var blocked_this_frame := false

func update_max_health(stacks : int)-> void:
	health = base_health + (25 * stacks)
func update_damage(stacks: int) -> void:
	normal_attack_hurtbox.damage = (normal_attack_base_damage + (10 * stacks))
	shield_break_hurtbox.damage = (shield_break_base_damage + (7.5 * stacks))
func update_max_shield_charges(stacks : int)-> void:
	shield_charges = base_shield_charges + stacks
	emit_signal("shield_increased", shield_charges)
func _on_InvincibilityTimer_time_out()-> void:
	invincible = false
	blocked_this_frame = false

func gain_health(gain):

	hitbox.current_health = min(hitbox.current_health+gain,health)
	current_health = hitbox.current_health
	emit_signal("health_changed", current_health)

	pass

func _on_RegainShieldTimer_time_out() -> void:
	if current_shield_charges < shield_charges:
		emit_signal("shield_regained", current_shield_charges)
		current_shield_charges += 1

func regain_all_shield_charges() -> void:
	current_shield_charges = shield_charges
	emit_signal("shield_regained", current_shield_charges - 1)

func _ready() -> void:
	yield(player, "ready")
	hitbox.current_health = health
	normal_attack_hurtbox.damage = normal_attack_damage
	shield_break_hurtbox.damage = shield_break_damage
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
		shield_break_hurtbox.is_active = true
		shield_break_timer.start()
		current_shield_charges -= 1
		emit_signal("shield_lost", current_shield_charges)
		player.audio_player.play_shield_hit_SFX()
		return
	player.skin.play_animation_player("hurt")
	hitbox.current_health -= (damage * (player.buff_manager.insomnia_stacks + 1))
	emit_signal("health_changed", hitbox.current_health)
	if hitbox.current_health > 0:
		player.audio_player.play_pain_SFX()
	current_health = hitbox.current_health


func _on_Hitbox_died() -> void:
	player.state_machine.transition_to("Die")

func _process(delta: float) -> void:
	current_mana += mana_regen * delta
	current_mana = clamp(current_mana, 0, mana)
	
	if spell_active:
		gain_health(health_regen * delta)


func _on_SpellDurationTimer_timeout() -> void:
	spell_active = false
	spell_animation_player.stop()


func _on_ShieldBreakTimer_timeout() -> void:
	shield_break_hurtbox.is_active = false
