extends StaticBody2D

var goldScene = preload("res://Collectible/Gold/GoldCoin.tscn")

var healthScene = preload("res://Collectible/Health/HealthPotion.tscn")

var lootTable = {
	0 : [0],
	5 : [1,1],
	12 : [1,1,1],
	18 : [2],
}

var mode = 1 # 1 for Barrel / 2 for Crate

var unBroken = true

func _ready():
	Events.connect("player_slept", self, "_on_Slept")
	randomize()
	un_brake()
	if randi()%2 == 0:
		$Smash.stream = load("res://Barrel/SFX_Barrel_03.wav")

func _on_Hitbox_got_hit(damage):
	if unBroken :
		un_repair()
	pass # Replace with function body.

func un_brake():
	$Blocker.disabled = false
	mode = 1 + randi()%2
	get_node("Whole"+String(mode)).visible = true
	unBroken = true
	pass

func un_repair():
	unBroken = false
	$Blocker.disabled = true
	$Smash.pitch_scale = 0.7 + randf() * 0.9
	$Smash.play()
	var player = $"%Player".get_node("PlayerCombat")
	var lotto = randi()%22
	if player.current_health == player.health:
		lotto = min(17,lotto)
	var loot = 0
	for k in lootTable.keys():
		if lotto > k :
			loot = k
	for l in lootTable[loot]:
		match l:
			0:
				pass
			1:
				var newCoin = goldScene.instance()
				get_tree().root.add_child(newCoin)
				newCoin.global_position = global_position + Vector2(0,-30)
				newCoin.activate(10)
			2:
				var HPpot = healthScene.instance()
				get_tree().root.add_child(HPpot)
				HPpot.global_position = global_position + Vector2(0,-30)
				HPpot.activate(35)
	$SmashAnimator.play(String(mode))
	$TestTimer.start()
	pass


func _on_Slept():
	if !unBroken:
		un_brake()
	pass # Replace with function body.
