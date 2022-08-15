extends KinematicBody2D
class_name Player

#warning-ignore:unused_signal
signal body_exited

onready var state_machine : StateMachine = $StateMachine
onready var skin: Node2D = $Skin

onready var collider: CollisionShape2D = $CollisionShape2D
onready var player_combat: Node2D = $PlayerCombat

#onready var hook: Hook = $Hook
onready var pass_through_controller: Area2D = $PassThroughController
onready var audio_player: Node2D = $AudioPlayer

const FLOOR_NORMAL: = Vector2.UP

var is_active: = true setget set_is_active

func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
#	hook.is_active = value

func flip_direction(move_direction : float) -> void:
	if move_direction > 0:
		skin.animated_sprite.flip_h = false
		player_combat.scale.x = 1
	elif move_direction < 0:
		skin.animated_sprite.flip_h = true
		player_combat.scale.x = -1

func get_current_health() -> int:
	return player_combat.current_health
