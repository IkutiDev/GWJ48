extends State

var play_hold_animation := false

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("block"):
		_state_machine.transition_to("Idle")


func _on_Skin_animation_finished() -> void:
	play_hold_animation = true
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")

func physics_process(delta: float) -> void:
	return
		
func process(delta: float) -> void:
	if play_hold_animation:
		owner.player.skin.play_animated_sprite("block", 1)

func enter(msg: Dictionary = {}) -> void:
	owner.player.skin.play_animated_sprite("startBlock", 1)
	owner.player.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	
	
func exit() -> void:
	play_hold_animation = false
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
