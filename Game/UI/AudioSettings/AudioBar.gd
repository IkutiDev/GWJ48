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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(targetBus,value)
	print(AudioServer.get_bus_name(targetBus)," : ",AudioServer.get_bus_volume_db(targetBus))
	pass # Replace with function body.
