extends Control

class_name VideoControl

@export var video : PolygonVideo

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_divisions_slider_value_changed(value: float) -> void:
	video.divisions = int(value)
