class_name BuffIcon
extends Panel

onready var info_panel: PanelContainer = $BuffIcon/InfoPanel
onready var buff_icon: TextureRect = $BuffIcon
onready var label: Label = $Label
onready var title_label: Label = $BuffIcon/InfoPanel/VBoxContainer/Title
onready var description_label: Label = $BuffIcon/InfoPanel/VBoxContainer/Description

export var show_stacks_label : bool = false
export var hide_on_zero_stacks : bool = true

var buff_stack := 0

func set_buff_stack(current_buff_stack: int):
	buff_stack = current_buff_stack
	label.text = "x" + str(buff_stack)
	if not hide_on_zero_stacks:
		visible = true
	elif buff_stack >= 1:
		visible = true
	else:
		visible = false
	
	if show_stacks_label:
		label.visible = true
	else:
		label.visible = false

func _ready() -> void:
	var canvas_rid = info_panel.get_canvas_item()
	VisualServer.canvas_item_set_z_index(canvas_rid, 1000)
	VisualServer.canvas_item_set_draw_index(canvas_rid, 1000)

func _on_BuffIcon_mouse_entered() -> void:
	info_panel.visible = true


func _on_BuffIcon_mouse_exited() -> void:
	info_panel.visible = false
