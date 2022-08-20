extends Enemy

onready var hurtbox: Hurtbox = $Hurtbox

var velocity = Vector2.ZERO

var attackMode = false

export var mass:= 20.0

func _on_AnimationPlayer_finished(anim_name: String) -> void:
	match anim_name:
		"spawn":
			spawn_finished()
		"death":
			death_finished()

func death_finished() -> void:
	skin.disconnect("animation_finished", self, "_on_AnimationPlayer_finished")
	queue_free()
	
func spawn_finished() -> void:
	current_enemy_life_state = enemy_life_state.Alive
	hurtbox.is_active = true

func buff_enemy(buff_counter: float) -> void:
	.buff_enemy(buff_counter)

func _ready() -> void:
	._ready()
	hurtbox.damage = damage
	skin.play_animation_player("spawn")
	skin.connect("animation_finished", self, "_on_AnimationPlayer_finished")


func _physics_process(delta):
	if not _is_enemy_alive():
		return
	._physics_process(delta)	
	if attackMode:
		return
	velocity = Steering.follow(velocity,global_position,desiredLoc,speed,mass)
	move_and_collide(velocity* delta)
	$Skin.scale.x = -int(sign(target.global_position.x - global_position.x))

func start_attack():
	attackMode = true
	$AttackAnimator.play("Explode")

func resume_follow():
	if $AttackRange.get_overlapping_bodies().size() > 0: #check if player is in range
		$AttackAnimator.stop()
		call_deferred("start_attack")
	else:
		attackMode = false

func _on_Hurtbox_dealt_damage(damage) -> void:
	pass # Replace with function body.


func _on_Hitbox_got_hit(damage) -> void:
	if not _is_enemy_alive():
		return
	if hitbox.current_health <= 0:
		return
	_got_hit(damage)
	if hitbox.current_health > 0:
		skin.play_animation_player("hit")


func _on_Hitbox_died() -> void:
	if not _is_enemy_alive():
		return
	_death()
	hurtbox.is_active = false
	$Death.pitch_scale = 0.7 + randf()*0.25
	$Death.play()
	skin.play_animation_player("death")


func _on_AttackRange_body_entered(body):
	if attackMode == false:
		start_attack()
	
	pass # Replace with function body.

