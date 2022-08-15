extends Enemy

var velocity = Vector2.ZERO

export var mass:= 20.0

func _on_AnimationPlayer_finished(anim_name: String) -> void:
	match anim_name:
		"spawn":
			spawn_finished()
		"death":
			death_finished()

func death_finished() -> void:
	Events.emit_signal("spawner_record_death", self)
	skin.disconnect("animation_finished", self, "_on_AnimationPlayer_finished")
	queue_free()
	
func spawn_finished() -> void:
	current_enemy_life_state = enemy_life_state.Alive

func _ready() -> void:
	._ready()
	skin.play_animation_player("spawn")
	skin.connect("animation_finished", self, "_on_AnimationPlayer_finished")


func _physics_process(delta):
	if not _is_enemy_alive():
		return
	._physics_process(delta)	
	velocity = Steering.follow(velocity,global_position,desiredLoc,speed,mass)
	move_and_collide(velocity* delta)


func _on_Hurtbox_dealt_damage(damage) -> void:
	pass # Replace with function body.


func _on_Hitbox_got_hit(damage) -> void:
	if not _is_enemy_alive():
		return
	if hitbox.current_health <= 0:
		return
	_got_hit(damage)



func _on_Hitbox_died() -> void:
	if not _is_enemy_alive():
		return
	_death()
	skin.play_animation_player("death")
