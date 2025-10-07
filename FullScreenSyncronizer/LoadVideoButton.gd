extends Button

class_name VideoButton

var video_path : String = ""
var file_dialog := FileDialog.new()
var file : AudioStreamWAV
var status : String

func _ready() -> void:
	pressed.connect(_on_pressed)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	text = "LOAD VIDEO"
	
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	#file_dialog.root_subfolder = OS.get_system_dir()
	file_dialog.filters = ["*.mp4 ; MP4 File"]
	file_dialog.file_selected.connect(on_file_dialog_file_selected)
	add_child(file_dialog)
	

func _on_pressed()->void:
	file_dialog.popup_centered_ratio(0.6)

func on_file_dialog_file_selected(path:String) -> void:
	video_path = path
	text = path
	get_parent().add_child(VideoButton.new())
