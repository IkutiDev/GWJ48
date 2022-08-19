extends State


"""
	FOLLOW
"""

var duration = 9 # how long this state lasts - in seconds

var time = 0 # time since phase started

# make the boss move in realtion to the player - by keeping an anvergae distance


func enter(_msg: Dictionary = {}):
	time = 0
	pass


func exit():
	
	pass


func physics_process(delta):
	time += delta
	if time > duration :
		_state_machine.transition_to(owner.next_phase())
		time = 0
	# locate a nice resting spot based on player location, boss location and distance between them
	var target = find_rest_position(owner.player.global_position,owner.global_position)
	# move towards that fine spot
	owner.velocity = Steering.follow(owner.velocity,owner.global_position,target,owner.speed,owner.mass)
	owner.move_and_collide(owner.velocity * delta)


func find_rest_position(player_pos : Vector2, boss_poss : Vector2):
	var output
	if player_pos.distance_to(boss_poss) > 250 :
		output = player_pos.linear_interpolate(boss_poss,randf())
	else:
		output = boss_poss.move_toward(player_pos + Vector2(0,-120) , player_pos.distance_to(boss_poss)*0.7)
	return output
