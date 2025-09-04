extends Control

@export var video_node : PackedScene 
@export var control_vbox : VBoxContainer
@export var videos : Node2D

var controls_visible : bool = true

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		switch_controller_visibility()
		
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func switch_controller_visibility()->void:
	controls_visible = !controls_visible
	control_vbox.visible = controls_visible
	for v in videos.get_children():
			v.handles.visible = controls_visible
	#print("controls hidden: ", controls_visible)


func _on_resized() -> void:
	for v in videos.get_children():
		v.size = size
	print("screensize changed to ", size)


func _on_addvid_button_pressed() -> void:
	var v : PolygonVideo = video_node.instantiate()
	v.size = size
	
	videos.add_child(v)


func _on_subvid_pressed() -> void:
	var vidnum : int = videos.get_child_count()-1
	if vidnum<0:
		return
	var vid : PolygonVideo = videos.get_child(vidnum)
	vid.queue_free()
