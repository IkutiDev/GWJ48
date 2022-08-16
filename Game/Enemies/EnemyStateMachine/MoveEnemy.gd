extends State
onready var ledge_detector: Area2D = $"../../LedgeDetector"

export var max_fall_speed: = 1500.0
export var acceleration_default: = Vector2(100000, 3000.0)
export var decceleration_default: = Vector2(500, 3000.0)
export var distance_to_player: = Vector2(4, 200)

var acceleration_local: = acceleration_default
var decceleration_local: = decceleration_default
var max_speed_local: = Vector2.ZERO
var max_speed_default := Vector2.ZERO
var velocity: = Vector2.ZERO


func _ready() -> void:
	yield(owner, "ready")
	max_speed_default = Vector2(owner.speed, owner.speed)
	max_speed_local = max_speed_default

func physics_process(delta: float) -> void:
	var enemy = owner as Enemy
	velocity = calculate_velocity(velocity, max_speed_local, acceleration_local, decceleration_local, delta, 
	get_move_direction(enemy.desiredLoc, owner.global_position, distance_to_player), max_fall_speed)
	
	if abs(abs(enemy.global_position.x) - abs(enemy.desiredLoc.x)) < 4 or abs(enemy.global_position.y - enemy.desiredLoc.y) > 200:
		velocity = Vector2.ZERO
	
	if ledge_detector.get_overlapping_bodies().size() == 0:
		velocity = Vector2.ZERO
	
	velocity = enemy.move_and_slide(velocity, enemy.FLOOR_NORMAL)
	
func process(_delta: float) -> void:
	var enemy = owner as Enemy
	owner.flip_direction(get_move_direction(enemy.desiredLoc, owner.global_position, distance_to_player).x)
	
	if velocity == Vector2.ZERO:
		owner.skin.play_animated_sprite("idle")
	else:
		owner.skin.play_animated_sprite("run")

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
	
	new_velocity += move_direction * acceleration * delta
	
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, fall_speed)
	return new_velocity

static func get_move_direction(target: Vector2, global_position: Vector2, distance_to_player : Vector2) -> Vector2:
	if abs(abs(global_position.x) - abs(target.x)) < distance_to_player.x or abs(global_position.y - target.y) > distance_to_player.y:
		return Vector2.ZERO
	return Vector2((target - global_position).normalized().x, 1.0)
