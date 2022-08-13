extends State

var _start_position: = Vector2.ZERO

func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position

func _on_Skin_animation_finished() -> void:
	_state_machine.transition_to("Move/Idle")

func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	owner.position = _start_position
	owner.skin.play_animated_sprite("spawn")
	owner.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")

func exit() -> void:
	owner.is_active = true
	owner.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
