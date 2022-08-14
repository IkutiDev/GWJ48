extends Node2D
class_name PlayerSkin

enum AnimationWeight {Movement = 0, Combat = 1}

signal animation_finished(name)
signal animated_sprite_finished()

onready var player_sprite: AnimatedSprite = $PlayerSprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
var animation : String = "None"
var currentWeight : int = 0

func _ready() -> void:
	var value = animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	assert(value == OK)
	value = player_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	assert(value == OK)
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)

func _on_AnimatedSprite_animation_finished() -> void:
	currentWeight = 0
	emit_signal("animated_sprite_finished")
	
func play_animation_player(anim_name: String) -> void:
	assert(anim_name in animation_player.get_animation_list())
	animation_player.play(anim_name)

func play_animated_sprite(anim_name: String, weigth: int = 0) -> void:
	assert(anim_name in player_sprite.frames.get_animation_names())
	if player_sprite.playing and currentWeight > weigth:
		return
	currentWeight = weigth
	player_sprite.play(anim_name)
	animation = player_sprite.animation

func is_animated_sprite_on_last_frame() -> bool:
	return (player_sprite as AnimatedSprite).frame == (player_sprite as AnimatedSprite).frames.get_frame_count((player_sprite as AnimatedSprite).animation) - 1
	
func get_current_frame() -> int:
	return (player_sprite as AnimatedSprite).frame
