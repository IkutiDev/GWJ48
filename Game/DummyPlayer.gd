extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		global_position = get_global_mouse_position()

func damage(value):
	print("ouch")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
