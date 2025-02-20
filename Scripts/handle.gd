@tool
extends Button

class_name MeshHandle

var dragging := false
var last_frame_position : Vector2

var idx : int
signal new_pos(_idx:int, _pos:Vector2)

@export var radius := 10.0:
	set(value):
		radius = value
		size = Vector2.ONE * radius * 2
		queue_redraw()
@export var color := Color(1,1,1,1):
	set(value):
		color = value
		queue_redraw()
@export var filled := false:
	set(value):
		filled = value
		queue_redraw()
@export var stroke_width := 2.0:
	set(value):
		stroke_width = value
		queue_redraw()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flat = true
	mouse_filter = MOUSE_FILTER_PASS
	size = Vector2.ONE * radius * 2
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	item_rect_changed.connect(_on_rect_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if dragging:
		last_frame_position = position
		position = get_global_mouse_position()
		if last_frame_position != position:
			new_pos.emit(idx, position)

func _on_button_down()->void:
	if Engine.is_editor_hint():
		return
	dragging = true

func _on_button_up()->void:
	if Engine.is_editor_hint():
		return
	dragging = false

func _on_rect_changed()->void:
	#print(position)
	pass
func _draw() -> void:
	var offset := Vector2.ONE*radius
	if filled:
		draw_circle(offset, radius, color, filled)
	else: 
		draw_circle(offset, radius, color, filled, stroke_width)
