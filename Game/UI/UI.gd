extends CanvasLayer

var pauseMenuScene = preload("res://UI/PauseMenu.tscn")
onready var score_dynamic_value: Label = $ScoreDynamicValue

onready var player = $"%Player"

var current_score = 0

func _on_HealthUpdated(current_health: int):
	$HP.value = current_health

func _on_ScoreUpdated(score_to_add: int):
	current_score += score_to_add
	score_dynamic_value.text = str(current_score)

func _ready() -> void:
	yield(player, "ready")
	player.player_combat.connect("health_changed", self, "_on_HealthUpdated")
	var value = Events.connect("score_gained", self, "_on_ScoreUpdated")
	assert(value == OK)
	_on_HealthUpdated(player.get_current_health())
	score_dynamic_value.text = str(current_score)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		add_child(pauseMenuScene.instance())
		pass
