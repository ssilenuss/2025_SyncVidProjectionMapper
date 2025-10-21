extends Button

var ffplay_path : String = "res://ffplay/ffplay"
var file_dialog := FileDialog.new()
var status : String

@export var root_node : VideoController

func _ready() -> void:
	if FileAccess.file_exists(ffplay_path):
		on_file_dialog_file_selected(ffplay_path)
	
	pressed.connect(_on_pressed)
	set_anchors_preset(Control.PRESET_FULL_RECT)

	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	#file_dialog.root_subfolder = OS.get_system_dir()
	#file_dialog.filters = ["*.ogv ; OGV File"]
	file_dialog.file_selected.connect(on_file_dialog_file_selected)
	add_child(file_dialog)
	

func _on_pressed()->void:
	file_dialog.popup_centered_ratio(0.6)

func on_file_dialog_file_selected(path:String) -> void:
	ffplay_path = path
	text = path
	root_node.ffplay_path = path
	
	

	#var file:= Resource.new() 
	#file.set_file(path)

	
	
	
