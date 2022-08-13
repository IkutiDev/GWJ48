extends Node2D

signal animation_finished(name)
signal animated_sprite_finished()

onready var player_sprite: AnimatedSprite = $PlayerSprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
var animation : String = "None"

func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	player_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)

func _on_AnimatedSprite_animation_finished() -> void:
	emit_signal("animated_sprite_finished")
	
func play_animation_player(anim_name: String) -> void:
	assert(anim_name in animation_player.get_animation_list())
	animation_player.play(anim_name)

func play_animated_sprite(anim_name: String) -> void:
	assert(anim_name in player_sprite.frames.get_animation_names())
	player_sprite.play(anim_name)
	animation = player_sprite.animation
