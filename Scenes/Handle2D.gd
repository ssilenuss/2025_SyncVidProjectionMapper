extends Button
class_name Handle2D

var idx : int
var polygon : Polygon2D
var active : bool = false

func _ready() -> void:
	button_down.connect(mouse_pressed)
	button_up.connect(mouse_released)
	
func _process(delta: float) -> void:
	if active:
		position = get_global_mouse_position() - size/2
		polygon.polygon[idx] = (get_global_mouse_position() - polygon.position)/polygon.scale
		
	
func mouse_pressed()->void:
	active = true

func mouse_released()->void:
	active = false
	
	
