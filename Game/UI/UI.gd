extends CanvasLayer

var pauseMenuScene = preload("res://UI/PauseMenu.tscn")

onready var player = $"%Player"


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		add_child(pauseMenuScene.instance())
		pass

func _process(delta):
	#var player = get_tree().get_nodes_in_group("Player")[0]
	if player != null :
		$HP.value = player.get_current_health()
	
