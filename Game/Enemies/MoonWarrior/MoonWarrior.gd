extends Enemy
onready var ledge_detector: Area2D = $LedgeDetector
onready var hurtbox: Area2D = $Hurtbox
onready var state_machine: Node = $StateMachine
onready var grunt: AudioStreamPlayer2D = $Grunt
onready var death: AudioStreamPlayer2D = $Death

export(Array, Resource) var grunt_sounds
export(Array, Resource) var death_sounds

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
	if state_machine._state_name == "MoveEnemy/TeleportEnemy":
		return
	if hitbox.current_health <= 0:
		return
	_got_hit(damage)
	skin.play_animation_player("hit")
	if hitbox.current_health > 0 and not is_attacking:
		state_machine.transition_to("HitEnemy")

func _on_Hitbox_died() -> void:
	if not _is_enemy_alive():
		return
	_death()
	grunt.stream_paused = true
	death.stream = null
	death.stream = death_sounds[randi() % death_sounds.size()]
	death.play()
	state_machine.transition_to("DieEnemy")


func _on_GruntTimer_timeout() -> void:
	if (randi() % 10) > 5:
		grunt.stream = null
		grunt.stream = grunt_sounds[randi() % grunt_sounds.size()]
		grunt.play()


func _on_TeleportCooldown_timeout() -> void:
	can_teleport = true
