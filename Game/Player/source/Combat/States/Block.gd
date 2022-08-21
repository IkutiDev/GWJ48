extends State

var play_hold_animation := false
onready var regain_shield_timer: Timer = $RegainShieldTimer

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("block"):
		_state_machine.transition_to("Idle")


func _on_Skin_animation_finished(_anim_name: String) -> void:
	play_hold_animation = true

func physics_process(_delta: float) -> void:
	if owner.current_shield_charges == 0:
		_state_machine.transition_to("Idle")
		
func process(_delta: float) -> void:
	if play_hold_animation:
		owner.player.skin.play_animated_sprite("block", 1)

func enter(_msg: Dictionary = {}) -> void:
	owner.player.audio_player.play_shield_unsheath_SFX()
	owner.block_active = true
	owner.stop_movement = true
	regain_shield_timer.stop()
	owner.player.skin.play_animated_sprite("startBlock", 1)
	owner.player.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	
	
func exit() -> void:
	owner.player.audio_player.play_shield_sheath_SFX()
	owner.block_active = false
	owner.stop_movement = false
	play_hold_animation = false
	regain_shield_timer.start()
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
