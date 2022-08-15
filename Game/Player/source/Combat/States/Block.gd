extends State

var play_hold_animation := false

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("block"):
		_state_machine.transition_to("Idle")


func _on_Skin_animation_finished(_anim_name: String) -> void:
	play_hold_animation = true

func physics_process(_delta: float) -> void:
	return
		
func process(_delta: float) -> void:
	if play_hold_animation:
		owner.player.skin.play_animated_sprite("block", 1)

func enter(_msg: Dictionary = {}) -> void:
	owner.block_active = true
	owner.player.skin.play_animated_sprite("startBlock", 1)
	owner.player.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	
	
func exit() -> void:
	owner.block_active = false
	play_hold_animation = false
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
