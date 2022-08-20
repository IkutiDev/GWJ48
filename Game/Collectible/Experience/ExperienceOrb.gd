extends Collectible

func _on_Pickup():
	Events.emit_signal("increase_experience", self.value)
