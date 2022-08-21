extends State
onready var spell_duration_timer: Timer = $SpellDurationTimer

func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Idle")

func unhandled_input(event: InputEvent) -> void:
	return

func physics_process(_delta: float) -> void:
	return
		
func process(_delta: float) -> void:
	return

func enter(_msg: Dictionary = {}) -> void:
	owner.player.skin.play_animated_sprite("spell", 1)
	owner.player.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	owner.player.audio_player.play_spell_SFX()
	owner.stop_movement = true
	owner.current_mana -= owner.spell_cost
	owner.spell_active = true
	spell_duration_timer.start()
	owner.spell_animation_player.play("regen")
	
func exit() -> void:
	owner.player.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	owner.stop_movement = false
