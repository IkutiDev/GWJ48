extends State

"""
	SPAWN
"""

func _ready():
	yield(owner, "ready")


func enter(_msg: Dictionary = {}):
	get_tree().get_nodes_in_group("OGPlayer")[0].freeze_player(true)
	# play intro animation
	owner.get_node("SuperAnimator").play("Spawn")
	owner.get_node("SuperAnimator").connect("animation_finished", self, "he_bue_bue")


func exit():
	get_tree().get_nodes_in_group("OGPlayer")[0].freeze_player(false)
	owner.get_node("SuperAnimator").disconnect("animation_finished", self, "he_bue_bue")


func he_bue_bue(animName: String): # 2Mo794eLbPw
	assert(animName,"Spawn")
	_state_machine.transition_to("Follow")

