extends State

var deathScreenScene = preload("res://UI/DeathScreen.tscn")

var _start_position: = Vector2.ZERO

func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position

func _end_game() -> void:
	get_tree().get_nodes_in_group("Game")[0].add_child(deathScreenScene.instance())
	
	#_state_machine.transition_to("Spawn")

func process(delta: float) -> void:
	if owner.skin.is_animated_sprite_on_last_frame():
		_end_game()

func enter(msg: Dictionary = {}) -> void:
	owner.skin.play_animated_sprite("die", 99)
	owner.audio_player.play_death_SFX()


func exit() -> void:
	return
