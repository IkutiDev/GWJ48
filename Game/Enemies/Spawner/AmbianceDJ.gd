extends Node

var inBattle = false

func _ready():
	randomize()
	$EffectTimer.start(8+randi()%7)
	_on_Impact_finished()
	_on_Hoot_finished()
	

func _on_Hoot_finished():
	$Hoot.pitch_scale = 0.85 + randf() * 0.15
	$Hoot.stream = load("res://Resouces/Ambiance/Owl_Hoot/AMB_Spot_Night_Out_Of_Town_Owl_Hoot_0"+ String(randi()%4)+".wav")

	pass # Replace with function body.

func _on_Impact_finished():
	$Impact.pitch_scale = 0.55 + randf() * 0.3
	if randi()%2 == 1:
		$Impact.stream = load("res://Resouces/Ambiance/HAL9K - Glass Hit 1.wav")
	else:
		$Impact.stream = load("res://Resouces/Ambiance/HAL9K - Low Thump.wav")
		
	pass # Replace with function body.

func _on_EffectTimer_timeout():
	if inBattle:
		$Impact.play()
	else:
		$Hoot.play()
	$EffectTimer.start(8+randi()%7)
	pass # Replace with function body.





func _on_Background_finished():
	$Background.play()
	pass # Replace with function body.
