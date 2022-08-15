extends State

func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("MoveEnemy/IdleEnemy")
	owner.current_enemy_life_state = owner.enemy_life_state.Alive

func enter(_msg: Dictionary = {}) -> void:
	# To force is_on_floor in spawn state, to not have falling state right after spawn
	owner.move_and_slide(Vector2.DOWN, owner.FLOOR_NORMAL)
	owner.skin.play_animation_player("spawn")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
