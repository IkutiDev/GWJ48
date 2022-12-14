extends Enemy

var bulletScene = preload("res://Enemies/Ghost/GhostBullet.tscn")

export var wobble = 0.0

export var mass: = 30.0

export var bulletSpeed = 150

export var fire_rate: = 7.0

var velocity = Vector2(0,0)

var attackMode = false

var cooldown = 0.0


func death_finished() -> void:
	skin.disconnect("animated_sprite_finished", self, "_on_AnimatedSprite_finished")
	queue_free()

func hit_finished() -> void:
	skin.play_animated_sprite("float")
	
func _on_AnimatedSprite_finished(anim_name: String) -> void:
	match anim_name:
		"spawn":
			spawn_finished()
		"hit":
			hit_finished()
		"death":
			death_finished()
	
func spawn_finished() -> void:
	skin.play_animated_sprite("float")
	current_enemy_life_state = enemy_life_state.Alive

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	$Death.pitch_scale = 0.6 + randf()*0.2
	$Death.stream = load("res://Enemies/Ghost/VO_Ghost_Death_0"+String(1+randi()%2)+".wav")
	skin.play_animated_sprite("spawn")
	var value = skin.connect("animated_sprite_finished", self, "_on_AnimatedSprite_finished")
	assert(value == OK)

func fire_bullet():
	if not _is_enemy_alive():
		return
	$AttackSound.pitch_scale = 1.0 + randf()*0.5
	$AttackSound.play()
	var newBullet : GhostBullet = bulletScene.instance()
	newBullet.damage = damage
	newBullet.global_position = global_position
	var attackDir = target.global_position - global_position
	attackDir = attackDir.normalized()
	newBullet.apply_central_impulse(attackDir * bulletSpeed) 
	get_parent().add_child(newBullet)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not _is_enemy_alive():
		return
	._physics_process(delta)
	if !$StalkRange.get_overlapping_bodies().size()>0:
		velocity += -velocity * delta
	velocity = Steering.follow(velocity,global_position,desiredLoc,speed,mass)
	var _collision = move_and_collide((velocity + Vector2(0,wobble) )* delta)
	$Skin.scale.x = int(sign(target.global_position.x - global_position.x))
	cooldown -= delta
	cooldown = max(cooldown,0)
	if cooldown < 0.1 and attackMode:
		cooldown += fire_rate
		fire_bullet()



func _on_AttackRange_body_entered(_body):
	attackMode = true
	pass # Replace with function body.


func _on_AttackRange_body_exited(_body):
	attackMode = false
	pass # Replace with function body.


func _on_Hitbox_got_hit(damage) -> void:
	if not _is_enemy_alive():
		return
	if hitbox.current_health <= 0:
		return
	_got_hit(damage)
	if hitbox.current_health > 0:
		skin.play_animated_sprite("hit")


func _on_Hitbox_died() -> void:
	if not _is_enemy_alive():
		return
	_death()
	skin.play_animated_sprite("death")
	$Death.play()
	$Glow.visible = false
