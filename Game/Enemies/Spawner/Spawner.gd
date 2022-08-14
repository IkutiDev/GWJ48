extends Node

var enemyScenes = {
	enemyData.types.ghost : preload("res://Enemies/Ghost/Ghost.tscn")
	}

var allExits = [] # holes have antialiasing set to true

var allGates = []

var allEnemies = []

var waveCounter = 0

var enemiesToSpawn = 0

var enemiesToKill = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_song(1)
	allExits = $Exits.get_children()
	for z in allExits:
		if !z.antialiased:
			allGates.push_back(z)
	spawn_enemy(enemyData.new())

func _process(delta):
	if $WaveTimer.time_left > 0:
		$Overlay/Label.text = String($WaveTimer.time_left)
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
	enemiesToSpawn = 5 + waveCounter
	enemiesToKill = enemiesToSpawn
	$SpawnTimer.start()
	pass

func spawn_enemy(data : enemyData):
	var newEnemy = enemyScenes[data.type].instance()
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
	spawn_enemy(enemyData.new())
	enemiesToSpawn -= 1
	if enemiesToSpawn < 1:
		$SpawnTimer.stop()
	pass # Replace with function body.


func _on_WaveTimer_timeout():
	start_next_wave()
	pass # Replace with function body.


