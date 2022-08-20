extends State

"""
	REST
"""

# move down till the Boss lands on something
# locate landing spot with $GroundDetector
# wait for x time or untill y damage is dealt

var duration = 7

var time = 0

var landingSpot

var startingHP

var earlyWake = 0.1

func enter(_msg: Dictionary = {}):
	owner.get_node("GroundDetector").force_raycast_update()
	landingSpot = owner.get_node("GroundDetector").get_collision_point() + Vector2(0,-20)
	time = 0
	startingHP = owner.HP # copy boss HP at start of rest
	pass


func exit():
	owner.energy += 100
	pass


func physics_process(delta):
	time += delta
	if time > duration or (startingHP - earlyWake * owner.maxHP > owner.HP) :
		_state_machine.transition_to("Follow")
		time = 0
	# move towards the ground
	owner.velocity = Steering.follow(owner.velocity,owner.global_position,landingSpot,80,5)
	owner.move_and_collide(owner.velocity * delta)

func back_to_wrk():
	time = 9001
	pass
