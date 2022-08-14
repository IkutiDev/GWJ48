extends Node

var enemyScenes = {
	enemyData.types.ghost : preload("res://Enemies/Ghost/Ghost.tscn")
	}

var allExits = [] # holes have antialiasing set to true

var allGates = []

var allEnemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	allExits = $Exits.get_children()
	print(allExits)
	for z in allExits:
		if !z.antialiased:
			allGates.push_back(z)
	print(allGates)
	spawn_enemy(enemyData.new())
	pass # Replace with function body.

func spawn_enemy(data : enemyData):
	var newEnemy = enemyScenes[data.type].instance()
	data.walker = true
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

func is_a_closer(a,b):
	var targetPos = $Exits.get_global_mouse_position()
	return targetPos.distance_to(a.global_position) < targetPos.distance_to(b.global_position)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	spawn_enemy(enemyData.new())
	pass # Replace with function body.


func _on_Button2_pressed():
	spawn_enemy(enemyData.new())
	pass # Replace with function body.


func _on_Button_pressed():
	$Timer.one_shot = !$Timer.is_stopped()
	$Timer.start()
	pass # Replace with function body.
