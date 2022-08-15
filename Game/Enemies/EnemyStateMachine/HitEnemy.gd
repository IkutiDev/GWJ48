extends State

func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("MoveEnemy/IdleEnemy")

func enter(_msg: Dictionary = {}) -> void:
	owner.skin.play_animated_sprite("hit", 98)
	owner.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")

func exit() -> void:
	owner.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
