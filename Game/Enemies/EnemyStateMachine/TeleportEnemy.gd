extends State

func _on_StartTeleportFinished(_anim_name: String) -> void:
	owner.global_position = owner.target.global_position
	owner.skin.play_animated_sprite("teleportEnd", 1)
	owner.skin.disconnect("animated_sprite_finished", self, "_on_StartTeleportFinished")
	owner.skin.connect("animated_sprite_finished", self, "_on_TeleportAnimation_finished")

func _on_TeleportAnimation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("MoveEnemy/IdleEnemy")

func enter(_msg: Dictionary = {}) -> void:
	owner.can_teleport = false
	owner.skin.play_animated_sprite("teleportStart", 1)
	owner.skin.connect("animated_sprite_finished", self, "_on_StartTeleportFinished")
	
func exit() -> void:
	owner.skin.disconnect("animated_sprite_finished", self, "_on_TeleportAnimation_finished")
