extends State

var _start_position: = Vector2.ZERO

func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position

func _on_Skin_animation_finished() -> void:
	_state_machine.transition_to("Spawn")

func enter(msg: Dictionary = {}) -> void:
	owner.skin.play_animated_sprite("die")
	owner.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")

func exit() -> void:
	owner.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
