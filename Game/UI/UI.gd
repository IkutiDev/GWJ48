extends CanvasLayer

var pauseMenuScene = preload("res://UI/PauseMenu.tscn")

onready var player = $"%Player"

func _on_HealthUpdated(current_health: int):
	$HP.value = current_health

func _ready() -> void:
	yield(player, "ready")
	player.player_combat.connect("health_changed", self, "_on_HealthUpdated")
	_on_HealthUpdated(player.get_current_health())

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		add_child(pauseMenuScene.instance())
		pass
