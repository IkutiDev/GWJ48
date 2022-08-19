extends State

"""
	SPRAY
"""

var bulletScene = preload("res://Boss/BossBullet.tscn")

var bulletCount = 0

# create a bunch of projectiles
# imuplse them in random directions away from the player over 4 seconds
# make it so bullets stop and arm after 3 seconds
# armed bullets fly towards player's current location

func enter(_msg: Dictionary = {}):
	bulletCount = 0
	$BulletTimer.start()
	owner.get_node("SuperAnimator").play("Focus")
	pass


func exit():
	pass


func fire_bullet():
	var sprayDirection = owner.global_position - owner.player.global_position
	sprayDirection = sprayDirection.normalized()
	sprayDirection = sprayDirection.rotated(rand_range(-1,1))
	var newBullet = bulletScene.instance()
	newBullet.global_position = owner.global_position
	newBullet.apply_central_impulse(sprayDirection * 260)
	newBullet.player = owner.player
	owner.get_parent().add_child(newBullet)
	pass

func _on_BulletTimer_timeout():
	fire_bullet()
	bulletCount += 1
	if bulletCount > 10:
		$BulletTimer.stop()
		_state_machine.transition_to("Stop")
	pass # Replace with function body.
