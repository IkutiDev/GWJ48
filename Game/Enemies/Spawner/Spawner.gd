extends Node

export var buff_enemies_on_every_x_wave : int = 5
export var minimal_spawn_timer : float = 0.5
export var spawn_timer_increase_per_wave : float = 0.1

export(Array, Resource) var enemies_data

#var enemyScenes = {
#	enemyData.types.ghost : preload("res://Enemies/Ghost/Ghost.tscn")
#	}

var allExits = [] # holes have antialiasing set to true

var allGates = []

var allEnemies = []

var allowedEnemies : Array

var waveCounter = 0

var enemiesToSpawn = 0

var enemiesToKill = 100

var buff_counter = 1

var current_spawn_wait_time = 3

func _enter_tree() -> void:
	for d in enemies_data:
		assert(d is enemyData)

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(owner, "ready")
	current_spawn_wait_time = $SpawnTimer.wait_time
	Events.connect("spawner_record_death", self, "record_death")
	SoundManager.play_song(1)
	allExits = $Exits.get_children()
	for z in allExits:
		if !z.antialiased:
			allGates.push_back(z)

func _exit_tree() -> void:
	Events.disconnect("spawner_record_death", self, "record_death")

func _process(_delta):
	if $WaveTimer.time_left > 0:
		$Overlay/Label.text = String("%.1f" % ($WaveTimer.time_left))
	else:
		$Overlay/Label.text = ""

func record_death(enemy):
	allEnemies.erase(enemy)
	enemiesToKill -= 1
	if enemiesToKill < 1:
		$WaveTimer.start()
		SoundManager.play_song(1)

func start_next_wave():
	SoundManager.play_song(2)
	waveCounter += 1
	current_spawn_wait_time -= spawn_timer_increase_per_wave
	if waveCounter % buff_enemies_on_every_x_wave == 0:
		buff_counter +=1
	enemiesToSpawn = 5 + pow(2, (waveCounter/4)) + waveCounter
	enemiesToKill = enemiesToSpawn
	allowedEnemies.clear()
	for d in enemies_data:
		if (d as enemyData).start_wave <= waveCounter:
			allowedEnemies.append(d)
	$SpawnTimer.wait_time = current_spawn_wait_time
	$SpawnTimer.start()
	pass

func spawn_enemy(data : enemyData):
	var newEnemy : Enemy = data.enemy_scene.instance()
	if buff_counter > 1:
		newEnemy.buff_enemy(buff_counter)
	var validExits = []
	if data.walker:
		validExits = allGates.duplicate()
	else:
		validExits = allExits.duplicate()
	if validExits.size()>2:
		validExits.sort_custom(self,"is_a_closer")
	var spawnPoint = validExits[randi()% int(min(2,validExits.size()))].global_position
	newEnemy.global_position = spawnPoint
	get_parent().add_child(newEnemy)
	allEnemies.push_back(newEnemy)
	pass

func is_a_closer(a,b): # is a not a closer! is a me! Mario!
	var targetPos = $Exits.get_global_mouse_position()
	return targetPos.distance_to(a.global_position) < targetPos.distance_to(b.global_position)
	pass



func _on_SpawnTimer_timeout():
	var enemy_to_spawn : enemyData = allowedEnemies[randi() % allowedEnemies.size()]
	spawn_enemy(enemy_to_spawn)
	enemiesToSpawn -= 1
	if enemiesToSpawn < 1:
		$SpawnTimer.stop()
	pass # Replace with function body.


func _on_WaveTimer_timeout():
	start_next_wave()
	pass # Replace with function body.


