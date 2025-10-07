extends Control

var video_window : PackedScene = preload("res://FullScreenSyncronizer/VideoWindow.tscn")

func _ready() -> void:
	get_viewport().set_embedding_subwindows(false)
	
	
func spawn_video_window():
	var vw : Node = video_window.instantiate()
	add_child(vw)
	vw.visible = true
	vw.position = Vector2(800,800)
	vw.title = "test"
	vw.size = Vector2(300,200)
	
