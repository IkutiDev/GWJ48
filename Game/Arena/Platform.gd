extends Area2D

func _on_Area2D_body_exited(body: Node) -> void:
	if body is Player:
		(body as Player).emit_signal("body_exited")
