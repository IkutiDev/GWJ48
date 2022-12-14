extends State

export var start_frame: int = 0

onready var normal_attack_hurtbox: Area2D = $"../../NormalAttackHurtbox"


func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Idle")

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("block") and owner.current_shield_charges > 0:
		_state_machine.transition_to("Block")

func physics_process(_delta: float) -> void:
	return
		
func process(_delta: float) -> void:
	if owner.player.skin.get_current_frame() >= start_frame:
		normal_attack_hurtbox.is_active = true

func enter(_msg: Dictionary = {}) -> void:
	owner.player.skin.play_animated_sprite("normalAttack", 1)
	owner.player.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	owner.player.audio_player.play_sword_swing_SFX()
	
func exit() -> void:
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	normal_attack_hurtbox.is_active = false
