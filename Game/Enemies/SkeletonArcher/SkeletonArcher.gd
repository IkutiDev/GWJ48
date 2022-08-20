extends Enemy
onready var ledge_detector: Area2D = $LedgeDetector
onready var state_machine: Node = $StateMachine

export var projectile_speed : float = 150.0

func _ready():
	._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not _is_enemy_alive():
		return
	._physics_process(delta)
	
func flip_direction(move_direction : float) -> void:
	if move_direction > 0:
		skin.animated_sprite.flip_h = false
		ledge_detector.scale.x = 1
	elif move_direction < 0:
		skin.animated_sprite.flip_h = true
		ledge_detector.scale.x = -1
	
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
	$Death.pitch_scale = 1.3 + randf()
	$Death.play()
	state_machine.transition_to("DieEnemy")
