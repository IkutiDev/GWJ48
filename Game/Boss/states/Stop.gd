extends State

"""
	STOP
"""

var duration = 1.5 # how long this state lasts - in seconds

var time = 0 # time since phase started


# make the boss not move for a solid 2-3 seconds before it resumes
# this state is a short brake after a main phase before follwing is resumed
# or rest is started


func enter(_msg: Dictionary = {}):
	if _msg.has("time"):
		time += _msg["time"]
	owner.velocity = Vector2(0,0)
	owner.get_node("SuperAnimator").play("Default")
	pass

func exit():
	pass


func physics_process(delta):
	time += delta
	if time > duration :
		if owner.energy < 0:
			_state_machine.transition_to("Rest")
		else:
			_state_machine.transition_to("Follow")
		time = 0
		pass
	# locate a nice resting spot based on player location, boss location and distance between them
	# move towards that fine spot
	pass
