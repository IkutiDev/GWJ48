extends Node2D

onready var player: Player = $".."
onready var hitbox: Hitbox = $Hitbox

onready var invincibility_timer: Timer = $InvincibilityTimer

export var health: int = 100

var current_health = health 

func _ready() -> void:
	hitbox.current_health = health

func _on_Hitbox_got_hit(damage) -> void:
	if not invincibility_timer.is_stopped():
		return
	
	invincibility_timer.start()
	player.audio_player.play_pain_SFX()
	hitbox.current_health -= damage
	current_health = hitbox.current_health


func _on_Hitbox_died() -> void:
	player.state_machine.transition_to("Die")
