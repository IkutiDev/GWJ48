extends Node2D

onready var surface_detector: Area2D = $SurfaceDetector

onready var foot_steps: AudioStreamPlayer2D = $FootSteps
onready var jump: AudioStreamPlayer2D = $Jump
onready var jump_grunt: AudioStreamPlayer2D = $JumpGrunt
onready var fall: AudioStreamPlayer2D = $Fall
onready var swing: AudioStreamPlayer2D = $Swing
onready var pain: AudioStreamPlayer2D = $Pain
onready var death: AudioStreamPlayer2D = $Death
onready var spawn: AudioStreamPlayer2D = $Spawn
onready var shield_unsheath: AudioStreamPlayer2D = $ShieldUnsheath
onready var shield_sheath: AudioStreamPlayer2D = $ShieldSheath
onready var shield_hit: AudioStreamPlayer2D = $ShieldHit
onready var shield_error: AudioStreamPlayer2D = $ShieldError


export(Array, Resource) var wood_foot_steps
export(Array, Resource) var rock_foot_steps
export(Array, Resource) var gravel_foot_steps

export(Array, Resource) var jump_grunts
export(Array, Resource) var wood_jumps
export(Array, Resource) var rock_jumps
export(Array, Resource) var gravel_jumps

export(Array, Resource) var wood_falls
export(Array, Resource) var rock_falls
export(Array, Resource) var gravel_falls

export(Array, Resource) var sword_swings
export(Array, Resource) var pain_grunts

export(Array, Resource) var death_sounds

export(Array, Resource) var sheath_sounds
export(Array, Resource) var unsheath_sounds

var currentSurfaceType : int = Surface.SurfaceType.Air

func _physics_process(_delta: float) -> void:
	self.currentSurfaceType = find_current_surface_type()
	

func play_footstep_SFX():
	foot_steps.stream = null
	match currentSurfaceType:
		Surface.SurfaceType.Wood:
			foot_steps.stream = wood_foot_steps[randi() % wood_foot_steps.size()]
		Surface.SurfaceType.Rock:
			foot_steps.stream = rock_foot_steps[randi() % rock_foot_steps.size()]
		Surface.SurfaceType.Gravel:
			foot_steps.stream = gravel_foot_steps[randi() % gravel_foot_steps.size()]
	foot_steps.pitch_scale = 0.8 + randf()*0.25
	foot_steps.play()

func play_jump_SFX():
	jump.stream = null
	jump_grunt.stream = null
	match currentSurfaceType:
		Surface.SurfaceType.Wood:
			jump.stream = wood_jumps[randi() % wood_jumps.size()]
		Surface.SurfaceType.Rock:
			jump.stream = rock_jumps[randi() % rock_jumps.size()]
		Surface.SurfaceType.Gravel:
			jump.stream = gravel_jumps[randi() % gravel_jumps.size()]
	jump.pitch_scale = 0.8 + randf()*0.25
	jump.play()	
	
	jump_grunt.stream = null
	jump_grunt.stream = jump_grunts[randi() % jump_grunts.size()]
	jump_grunt.play()
	
func play_fall_SFX():
	fall.stream = null
	match currentSurfaceType:
		Surface.SurfaceType.Wood:
			fall.stream = wood_falls[randi() % wood_falls.size()]
		Surface.SurfaceType.Rock:
			fall.stream = rock_falls[randi() % rock_falls.size()]
		Surface.SurfaceType.Gravel:
			fall.stream = gravel_falls[randi() % gravel_falls.size()]
	fall.pitch_scale = 0.8 + randf()*0.25
	fall.play()		
	
func play_sword_swing_SFX():
	swing.stream = null
	
	swing.stream = sword_swings[randi() % sword_swings.size()]
	swing.pitch_scale = 0.8 + randf()*0.25
	swing.play()
	
func play_pain_SFX():
	pain.stream = null
	
	pain.stream = pain_grunts[randi() % pain_grunts.size()]
	pain.pitch_scale = 0.8 + randf()*0.25
	pain.play()
	
func play_death_SFX():
	death.stream = null
	
	death.stream = death_sounds[randi() % death_sounds.size()]
	death.play()

func play_shield_hit_SFX():
	shield_hit.play()
	
func play_shield_unsheath_SFX():
	shield_unsheath.stream = null
	
	shield_unsheath.stream = unsheath_sounds[randi() % unsheath_sounds.size()]
	shield_unsheath.play()

func play_shield_sheath_SFX():
	shield_sheath.stream = null
	
	shield_sheath.stream = sheath_sounds[randi() % sheath_sounds.size()]
	shield_sheath.play()

func play_shield_error_SFX():
	shield_error.play()

func play_spawn_SFX():
	spawn.play()
	
	
func find_current_surface_type() -> int:
	var closest_surface: int = Surface.SurfaceType.Air

	var surfaces: = surface_detector.get_overlapping_bodies()
	for s in surfaces:
		if s is Surface:
			closest_surface = (s as Surface).surfaceType
			

	return closest_surface

