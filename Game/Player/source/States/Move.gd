class_name MoveState
extends State
"""
Parent state that abstracts and handles basic movement
Move-related children states can delegate movement to it, or use its utility functions
"""

const PASS_THROUGH_LAYER := 3
const DECCELERATION_ENABLED: = false
const HOOK_ENABLED: = true

export var max_speed_default: = Vector2(500.0, 2000.0)
export var max_fall_speed: = 1500.0
export var acceleration_default: = Vector2(100000, 3000.0)
export var decceleration_default: = Vector2(500, 3000.0)


onready var max_speed_base: = max_speed_default
var acceleration_local: = acceleration_default
var decceleration_local: = decceleration_default
var max_speed_local: = max_speed_default
var velocity: = Vector2.ZERO

func update_max_speed(stacks : int)-> void:
	max_speed_default = max_speed_base + (Vector2(17.0, 0.0) * stacks)

func _ready() -> void:
	yield(owner, "ready")
	var value = owner.buff_manager.connect("update_speed_up", self, "update_max_speed")
	assert(value == OK)

func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return
	_state_machine.transition_to("Hook", {target_global_position = target_global_position,
	velocity = velocity})


func _on_PassThrough_body_exited() -> void:
	owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = true })
	if event.is_action_pressed("move_down") and owner.is_on_floor():
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, false)
		_state_machine.transition_to("Move/Air")
	elif event.is_action_released("move_down") and not owner.get_collision_mask_bit(PASS_THROUGH_LAYER):
		owner.set_collision_mask_bit(PASS_THROUGH_LAYER, true)

func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed_local, acceleration_local, decceleration_local, delta, 
	get_move_direction(owner.player_combat.block_active), max_fall_speed)
	var player = owner as Player
	velocity = player.move_and_slide(velocity, player.FLOOR_NORMAL)
	Events.emit_signal("player_moved", player)
	
func enter(_msg: Dictionary = {}) -> void:
	#owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	var value = $Air.connect("jumped", $Idle.jump_delay, "start")
	assert(value == OK)
	value = owner.connect("body_exited", self, "_on_PassThrough_body_exited")
	assert(value == OK)
	
func exit() -> void:
	#owner.hook.disconnect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.disconnect("jumped", $Idle.jump_delay, "start")
	owner.disconnect("body_exited", self, "_on_PassThrough_body_exited")
	
func process(_delta: float) -> void:
	owner.flip_direction(get_move_direction(owner.player_combat.block_active).x)
	
	if get_move_direction(owner.player_combat.block_active).x == 0:
		owner.skin.play_animated_sprite("idle")
	else:
		movement_animation()
			
func movement_animation() -> void:
	var run_is_pressed: = Input.is_action_pressed("sprint")
	if run_is_pressed:
		owner.skin.play_animated_sprite("run")
	else:
		owner.skin.play_animated_sprite("walk")

static func calculate_velocity(
	old_velocity: Vector2,
	max_speed: Vector2,
	acceleration: Vector2,
	decceleration: Vector2,
	delta: float,
	move_direction: Vector2,
	fall_speed: float
) -> Vector2:
	
	var new_velocity : = old_velocity
	
	if DECCELERATION_ENABLED:
		new_velocity.y += move_direction.y * acceleration.y * delta
		
		if move_direction.x:
			new_velocity.x += move_direction.x * acceleration.x * delta
		elif abs(new_velocity.x) > 0.1:
			new_velocity.x -= decceleration.x * delta * sign(new_velocity.x)
			new_velocity.x = new_velocity.x if sign(new_velocity.x) == sign(old_velocity.x) else 0.0
	else:
		new_velocity += move_direction * acceleration * delta
	
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, fall_speed)
	return new_velocity

static func get_move_direction(block_active: bool) -> Vector2:
	var direction_value : float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") if not block_active else 0.0
	return Vector2(
		direction_value,
		1.0
	)
