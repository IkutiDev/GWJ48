extends State

export var spawn_projectile_frame: int = 0
export var projectile_scene : PackedScene 

onready var attack_cooldown: Timer = $AttackCooldown

var already_shot := false

func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("MoveEnemy/IdleEnemy")
	attack_cooldown.start()
		
	
func spawn_projectile():
	if not owner._is_enemy_alive():
		return
	already_shot = true
	var newProjectile : Projectile = projectile_scene.instance()
	newProjectile.damage = owner.damage
	newProjectile.global_position = owner.global_position
	newProjectile.rotation = newProjectile.get_angle_to(owner.target.global_position)
	var attackDir = owner.target.global_position - owner.global_position
	attackDir = attackDir.normalized()
	newProjectile.apply_central_impulse(attackDir * owner.projectile_speed) 
	get_parent().add_child(newProjectile)
	
func process(_delta: float) -> void:
	if owner.skin.get_current_frame() == spawn_projectile_frame and not already_shot:
		spawn_projectile()

func enter(_msg: Dictionary = {}) -> void:
	already_shot = false
	owner.skin.play_animated_sprite("attack", 1)
	owner.skin.connect("animated_sprite_finished", self, "_on_Skin_animation_finished")
	
func exit() -> void:
	owner.skin.disconnect("animated_sprite_finished", self, "_on_Skin_animation_finished")
