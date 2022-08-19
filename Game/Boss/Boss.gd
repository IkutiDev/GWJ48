extends KinematicBody2D

var allPhases = ["Summon","Spray","Lazor"]

var currentPhase

var player = null

var energy = 100

var velocity = Vector2(0,0)

var speed = 200

var mass = 100

var maxHP = 3000

export var HP = 3000

func _ready():
	#Fetch the player
	if get_tree().get_nodes_in_group("Player").size()>0:
		#This will break if we have more than 1 entity in player group so we do assert here to have a sanity check
		assert(get_tree().get_nodes_in_group("Player").size(), 1)
		player = get_tree().get_nodes_in_group("Player")[0]

func next_phase():
	# get next phase from list and update list
	# return next phase as String
	currentPhase = allPhases[0]
	energy -= 75
	return currentPhase
	pass

func _process(delta):
	$CanvasLayer/Label.text = $StateMachine._state_name
#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		if $PinJoint2D.softness == 0:
#			$PinJoint2D.softness = 4
#		else:
#			$PinJoint2D.softness = 0


