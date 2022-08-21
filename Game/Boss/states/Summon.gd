extends State

"""
	SUMMON
"""

# spawn a bunch of ghosts

var ghostsSpawned = 0

var ghostMax = 4 # how many should be spawned in 1 phase

var ghostTimer = 0

var ghostScene = preload("res://Enemies/Ghost/Ghost.tscn")

func enter(_msg: Dictionary = {}):
	ghostsSpawned = 0
	owner.get_node("SuperAnimator").play("Focus")
	pass

func physics_process(delta):
	ghostTimer += delta
	if ghostTimer > 0.8:
		ghostTimer = 0
		spawn_ghost()
		if ghostsSpawned >= ghostMax:
			_state_machine.transition_to("Stop",{"duration":3.0})

func exit():
	pass
	

func spawn_ghost():
	ghostsSpawned += 1
	var newGhost = ghostScene.instance()
	newGhost.global_position = owner.global_position
	newGhost.velocity = Vector2(rand_range(-500,500),rand_range(-100,0)) 
	owner.get_parent().add_child(newGhost)
	pass

