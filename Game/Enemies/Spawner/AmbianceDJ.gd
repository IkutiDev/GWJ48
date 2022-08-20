extends Node

var inBattle = false

func _ready():
	randomize()
	$EffectTimer.start(8+randi()%7)
	_on_Impact_finished()
	_on_Hoot_finished()
	_on_Plop_finished()

func _on_Hoot_finished():
	$Hoot.pitch_scale = 0.85 + randf() * 0.15
	$Hoot.stream = load("res://Resouces/Ambiance/Owl_Hoot/AMB_Spot_Night_Out_Of_Town_Owl_Hoot_0"+ String(randi()%4)+".wav")

	pass # Replace with function body.

func _on_Impact_finished():
	
	$Impact.pitch_scale = 0.75 + randf() * 0.9
	pass # Replace with function body.


func _on_Plop_finished():
	$Impact.pitch_scale = 0.75 + randf() * 0.9
	pass # Replace with function body.

func _on_EffectTimer_timeout():
	if inBattle:
		if randi()%2 == 0:
			$Impact.play()
		else:
			$Plop.play()
	else:
		$Hoot.play()
	$EffectTimer.start(8+randi()%7)
	pass # Replace with function body.





func _on_Background_finished():
	$Background.play()
	pass # Replace with function body.



