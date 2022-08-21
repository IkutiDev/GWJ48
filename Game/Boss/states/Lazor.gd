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
	turnSpeed = 2.4
	$BlastTimer.start()
	owner.get_node("Laser").look_at(owner.player.global_position)
	owner.get_node("Laser").visible = true
	owner.get_node("SuperAnimator").play("Focus")
	owner.get_node("Laser").get_node("Hurtbox").get_node("Shape").disabled = true
	owner.get_node("Laser").width = 2
	owner.get_node("Laser").get_node("Charge").play()
	owner.get_node("Pupil").modulate.a = 0
	
	pass

func physics_process(delta):
	time += delta
	track(delta)
	if time > duration :
		time = 0
		_state_machine.transition_to("Stop")
		
	if owner.global_position.distance_to(owner.player.global_position) < 200:
		var direction = owner.global_position - owner.player.global_position
		direction = direction.normalized()
		owner.velocity = Steering.follow(owner.velocity,owner.global_position,direction * 5 + owner.global_position,owner.speed*0.3,owner.mass)
		owner.move_and_collide(owner.velocity * delta)
	
func track(delta):
	var significantAngle = owner.get_node("Laser").get_angle_to(owner.player.global_position)
	
	if abs(significantAngle) < 0.02:
		return
	else:
		owner.get_node("Laser").rotate(turnSpeed * delta * sign(significantAngle) * distance_bonus() ) 

func distance_bonus():
	var origin = owner.global_position
	var point = owner.player.global_position
	return max(0.2, -0.016 * origin.distance_to(point) + 2.0)
	


func exit():
	owner.get_node("Pupil").modulate.a = 1
	owner.get_node("Laser").get_node("Hurtbox").get_node("Shape").disabled = true
	owner.get_node("Laser").visible = false
	pass
	
	


func _on_BlastTimer_timeout():
	turnSpeed = 1.57
	yield(get_tree().create_timer(0.4),"timeout")
	owner.get_node("Laser").width = 20
	owner.get_node("Laser").get_node("Fire").play()
	owner.get_node("Laser").get_node("Hurtbox").get_node("Shape").disabled = false
	pass # Replace with function body.
