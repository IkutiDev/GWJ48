extends Collectible

func _on_Pickup():
	Events.emit_signal("score_gained", self.value)
