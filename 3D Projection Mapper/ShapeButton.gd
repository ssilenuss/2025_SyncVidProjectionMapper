extends Button

class_name ShapeButton

func _ready() -> void:
	pressed.connect(owner._on_shape_button_pressed.bind(self))
