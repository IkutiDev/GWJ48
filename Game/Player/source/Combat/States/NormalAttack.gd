extends State

onready var hurtbox: Area2D = $"../../Hurtbox"

func _on_Skin_animation_finished() -> void:
	_state_machine.transition_to("Idle")

func unhandled_input(event: InputEvent) -> void:
	return

func physics_process(delta: float) -> void:
	return
		
func process(delta: float) -> void:
	return

func enter(msg: Dictionary = {}) -> void:
	hurtbox.monitorable = true
	hurtbox.visible = true
	owner.player.skin.play_animated_sprite("normalAttack", 1)
	owner.player.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	
func exit() -> void:
	hurtbox.monitorable = false
	hurtbox.visible = false
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
