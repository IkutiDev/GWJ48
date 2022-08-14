extends State

var _start_position: = Vector2.ZERO

func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position

func _end_game() -> void:
	print("You died lol")
	get_tree().paused = true
	#_state_machine.transition_to("Spawn")

func process(delta: float) -> void:
	if owner.skin.is_animated_sprite_on_last_frame():
		_end_game()

func enter(msg: Dictionary = {}) -> void:
	owner.skin.play_animated_sprite("die", 99)


func exit() -> void:
	return
