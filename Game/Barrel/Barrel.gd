extends StaticBody2D


var mode = 1 # 1 for Barrel / 2 for Crate

var unBroken = true

func _ready():
	randomize()
	un_brake()
	if randi()%2 == 0:
		$Smash.stream = load("res://Barrel/SFX_Barrel_03.wav")

func _on_Hitbox_got_hit(damage):
	if unBroken :
		un_repair()
	pass # Replace with function body.

func un_brake():
	$Blocker.disabled = false
	mode = 1 + randi()%2
	get_node("Whole"+String(mode)).visible = true
	unBroken = true
	pass

func un_repair():
	unBroken = false
	$Blocker.disabled = true
	$Smash.pitch_scale = 0.7 + randf() * 0.9
	$Smash.play()
	$SmashAnimator.play(String(mode))
	pass
