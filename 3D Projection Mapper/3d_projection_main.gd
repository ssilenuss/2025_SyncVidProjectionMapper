extends Node3D

@export var plane_vid : PackedScene

@onready var video_parent : Node3D = $Videos



func _on_shape_button_pressed(_button: ShapeButton) -> void:
	match _button.name:
		"Plane":
			video_parent.add_child(plane_vid.instantiate())
			
