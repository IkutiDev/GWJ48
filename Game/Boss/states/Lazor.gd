extends State

"""
	LAZOR
"""

# stop the boss - create a line2D between player and boss
# after 0.5 s make it wide and deal damage
# follows the player, but slowly
var time = 0

var duration = 7

var turnSpeed


func enter(_msg: Dictionary = {}):
	time = 0
	turnSpeed = 1.2
	$BlastTimer.start()
	owner.get_node("Laser").look_at(owner.player.global_position)
	owner.get_node("Laser").visible = true
	owner.get_node("SuperAnimator").play("Focus")
	owner.get_node("Laser").get_node("Hurtbox").get_node("Shape").disabled = true
	owner.get_node("Laser").width = 2
	owner.get_node("Laser").get_node("Charge").play()
	
	pass

func physics_process(delta):
	time += delta
	track(delta)
	if time > duration :
		time = 0
		_state_machine.transition_to("Stop")


	
func track(delta):
	var significantAngle = owner.get_node("Laser").get_angle_to(owner.player.global_position)

	if abs(significantAngle) < 0.02:
		return
	else:
		owner.get_node("Laser").rotate(turnSpeed * delta * sign(significantAngle)) 


func exit():

	owner.get_node("Laser").get_node("Hurtbox").get_node("Shape").disabled = true
	owner.get_node("Laser").visible = false
	pass
	
	


func _on_BlastTimer_timeout():
	turnSpeed = 0.62
	owner.get_node("Laser").width = 20
	owner.get_node("Laser").get_node("Fire").play()
	owner.get_node("Laser").get_node("Hurtbox").get_node("Shape").disabled = false
	pass # Replace with function body.
