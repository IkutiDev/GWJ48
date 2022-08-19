extends State

var _start_position: = Vector2.ZERO

func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position


func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Move/Idle")

func enter(_msg: Dictionary = {}) -> void:
	owner.player_combat.hitbox.current_health = owner.player_combat.health
	owner.player_combat.emit_signal("health_changed", owner.player_combat.hitbox.current_health)
	owner.position = _start_position
	# To force is_on_floor in spawn state, to not have falling state right after spawn
	owner.move_and_slide(Vector2.DOWN, owner.FLOOR_NORMAL)
	owner.skin.play_animated_sprite("spawn")
	owner.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")

func exit() -> void:
	owner.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
