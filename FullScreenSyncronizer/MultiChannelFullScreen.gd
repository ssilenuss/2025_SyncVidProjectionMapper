extends Control

@export_global_file() var test_path: String 

func _ready() -> void:
	get_viewport().set_embedding_subwindows(false)
	
	if test_path:
		$VBoxContainer/MarginContainer/Videos/LoadVideo.on_file_dialog_file_selected(test_path)
	
	

	


func _on_play_button_pressed() -> void:
	print($Windows.get_children())
