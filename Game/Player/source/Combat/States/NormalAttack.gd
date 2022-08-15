extends State

export var start_frame: int = 0

onready var hurtbox: Hurtbox = $"../../Hurtbox"

func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Idle")

func unhandled_input(_event: InputEvent) -> void:
	return

func physics_process(_delta: float) -> void:
	return
		
func process(_delta: float) -> void:
	if owner.player.skin.get_current_frame() >= start_frame:
		hurtbox.is_active = true

func enter(_msg: Dictionary = {}) -> void:
	owner.player.skin.play_animated_sprite("normalAttack", 1)
	owner.player.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	owner.player.audio_player.play_sword_swing_SFX()
	
func exit() -> void:
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	hurtbox.is_active = false
