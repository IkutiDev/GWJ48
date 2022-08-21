extends Area2D

var bossScene = preload("res://Boss/Boss.tscn")

func _on_BossSpawner_body_entered(body):
	if get_tree().get_nodes_in_group("Spawner")[0].bossReady:
		var sky = get_tree().get_nodes_in_group("Sky")[0]
		var oldMoon = get_tree().get_nodes_in_group("Moon")
		assert(oldMoon.size()>0)
		oldMoon = oldMoon[0]
		oldMoon.visible = false
		sky.modulate = Color(1, 0.384314, 0.384314)
		var newMoon = bossScene.instance()
		newMoon.global_position = get_tree().get_nodes_in_group("Camera")[0].get_camera_position() + Vector2(-80,-45)
		get_parent().get_parent().add_child(newMoon)
		get_tree().get_nodes_in_group("Spawner")[0].boss_started()
		queue_free()
