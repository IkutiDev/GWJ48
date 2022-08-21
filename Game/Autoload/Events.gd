extends Node

var testMode = false

var score = 0

#warning-ignore:unused_signal
signal player_moved(player)
#warning-ignore:unused_signal
signal player_slept()
#warning-ignore:unused_signal
signal score_gained(score)
#warning-ignore:unused_signal
signal increase_experience(gained_experience)
#warning-ignore:unused_signal
signal spawner_record_death(enemy)

signal health_gained(HP)
