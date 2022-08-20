extends HBoxContainer


export var busName = "Master"
var targetBus = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	targetBus = AudioServer.get_bus_index(busName)

	if targetBus == -1 :
		print("error, no such bus as: ",busName)
		return

	$Name.text = busName
	$HSlider.value = AudioServer.get_bus_volume_db(targetBus)
	$Sample.bus = busName
	print(busName," : ",$Sample.bus)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(targetBus,value)
	if !$Sample.playing:
		$Sample.play()
	pass # Replace with function body.


func _on_Timer_timeout():
	$Sample.volume_db = 0
	pass # Replace with function body.
