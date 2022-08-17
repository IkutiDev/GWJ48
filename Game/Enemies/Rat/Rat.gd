extends Enemy
onready var ledge_detector: Area2D = $LedgeDetector
onready var hurtbox: Area2D = $Hurtbox
onready var state_machine: Node = $StateMachine

func _ready():
	
	._ready()
	hurtbox.damage = damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not _is_enemy_alive():
		return
	._physics_process(delta)
	
func flip_direction(move_direction : float) -> void:
	if move_direction > 0:
		skin.animated_sprite.flip_h = false
		ledge_detector.scale.x = 1
		hurtbox.scale.x = 1
	elif move_direction < 0:
		skin.animated_sprite.flip_h = true
		ledge_detector.scale.x = -1
		hurtbox.scale.x = -1
	
func _on_Hitbox_got_hit(damage) -> void:
	if not _is_enemy_alive():
		return
	if hitbox.current_health <= 0:
		return
	_got_hit(damage)
	if hitbox.current_health > 0 and not is_attacking:
		state_machine.transition_to("HitEnemy")

func _on_Hitbox_died() -> void:
	if not _is_enemy_alive():
		return
	_death()
	$Squeaks.stream_paused = true
	state_machine.transition_to("DieEnemy")




func _on_Squeaks_finished():
	$Squeaks.pitch_scale = 0.7 + randf()*0.8
	yield(get_tree().create_timer(1+randf()*3), "timeout")
	$Squeaks.play()
	pass # Replace with function body.
