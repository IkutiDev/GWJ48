extends Collectible

func _on_Pickup():
	Events.emit_signal("health_gained", self.value)
