extends Node2D

onready var player: Player = $".."
onready var hitbox: Hitbox = $Hitbox

onready var invincibility_timer: Timer = $InvincibilityTimer

export var health: int = 100

var current_health = health 

var invincible := false

func _on_InvincibilityTimer_time_out()-> void:
	invincible = false

func _ready() -> void:
	hitbox.current_health = health
	invincibility_timer.connect("timeout", self, "_on_InvincibilityTimer_time_out")

func _on_Hitbox_got_hit(damage) -> void:
	if invincible:
		return
	
	invincibility_timer.start()
	invincible = true
	player.skin.play_animation_player("hurt")
	print(invincibility_timer.time_left)
	hitbox.current_health -= damage
	if hitbox.current_health > 0:
		player.audio_player.play_pain_SFX()
	current_health = hitbox.current_health


func _on_Hitbox_died() -> void:
	player.state_machine.transition_to("Die")
