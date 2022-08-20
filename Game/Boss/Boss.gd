extends KinematicBody2D

var winScreenScene = preload("res://UI/WinScreen.tscn")

var allPhases = ["Summon","Spray","Lazor"]

var currentPhase

var player = null

var energy = 100

var velocity = Vector2(0,0)

var speed = 200

var mass = 100

var maxHP = 300

export var HP = 300

func _ready():
	if HP > maxHP:
		maxHP = HP
	$Overlay/HealthBar.max_value = maxHP
	$Overlay/HealthBar.value = HP
	SoundManager.play_song(3)
	
	#Fetch the player
	if get_tree().get_nodes_in_group("Player").size()>0:
		#This will break if we have more than 1 entity in player group so we do assert here to have a sanity check
		assert(get_tree().get_nodes_in_group("Player").size(), 1)
		player = get_tree().get_nodes_in_group("Player")[0]

func next_phase():
	# get next phase from list and update list
	# return next phase as String
	currentPhase = allPhases[randi()%3]
	energy -= 75
	return currentPhase
	pass

func _process(delta):
	pass
#	$CanvasLayer/Label.text = $StateMachine._state_name
#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		if $PinJoint2D.softness == 0:
#			$PinJoint2D.softness = 4
#		else:
#			$PinJoint2D.softness = 0

func boss_defeat():
	
	get_tree().get_nodes_in_group("Game")[0].add_child(winScreenScene.instance())
	# 
	pass

func _on_Hitbox_got_hit(damage):
	HP -= damage
	if HP <= 0:
		boss_defeat()
	$Damage.stop()
	$Damage.stream = load("res://Boss/SFX_Moon_Grunt_0"+String(randi()%2)+".wav")
	$Damage.pitch_scale = 0.9 + randf()*0.15
	$Damage.play()
	$SuperAnimator.play("Damage")
	$Overlay/HealthBar.value = HP
	pass # Replace with function body.
