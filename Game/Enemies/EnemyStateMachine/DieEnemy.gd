extends State

func death_finished() -> void:
	owner.queue_free()

func process(_delta: float) -> void:
	if owner.skin.is_animated_sprite_on_last_frame():
		death_finished()

func enter(_msg: Dictionary = {}) -> void:
	
	owner.skin.play_animated_sprite("death", 99)
	owner.skin.play_animation_player("death")


func exit() -> void:
	return
