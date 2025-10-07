extends Button

class_name VideoButton

var video_path : String = ""
var file_dialog := FileDialog.new()
var status : String

var video_window : PackedScene = preload("res://FullScreenSyncronizer/VideoWindow.tscn")


func _ready() -> void:
	pressed.connect(_on_pressed)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	text = "LOAD VIDEO"
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	#file_dialog.root_subfolder = OS.get_system_dir()
	file_dialog.filters = ["*.ogv ; OGV File"]
	file_dialog.file_selected.connect(on_file_dialog_file_selected)
	add_child(file_dialog)
	

func _on_pressed()->void:
	file_dialog.popup_centered_ratio(0.6)

func on_file_dialog_file_selected(path:String) -> void:
	video_path = path
	text = path
	get_parent().add_child(VideoButton.new())

	var file:= VideoStreamTheora.new() 
	file.set_file(path)
	spawn_video_window(file)
	
	
func spawn_video_window(_file: VideoStreamTheora):
	var vw : Node = video_window.instantiate()
	vw.file = _file
	add_child(vw)
	
