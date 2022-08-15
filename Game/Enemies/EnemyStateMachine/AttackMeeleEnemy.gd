extends State

export var start_frame: int = 0

export var end_frame: int = 0

onready var hurtbox: Area2D = $"../../Hurtbox"
onready var attack_cooldown: Timer = $AttackCooldown

func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("MoveEnemy/IdleEnemy")
	attack_cooldown.start()
		
func process(_delta: float) -> void:
	if owner.skin.get_current_frame() >= start_frame and owner.skin.get_current_frame() <= end_frame:
		hurtbox.is_active = true
	else:
		hurtbox.is_active = false

func enter(_msg: Dictionary = {}) -> void:
	hurtbox.is_active = false
	owner.skin.play_animated_sprite("attack", 1)
	owner.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	
func exit() -> void:
	owner.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	hurtbox.is_active = false
