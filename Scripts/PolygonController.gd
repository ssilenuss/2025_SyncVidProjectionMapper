@tool
extends Node2D
class_name PolygonVideo

@export_range(1, 4, 1) var divisions : int = 1

@export var set_vertices : bool :
	set(value):
		
		if polygon:
			set_polygon_vertices()
			
@export var size : Vector2 : set=set_screen_size
func set_screen_size(value: Vector2)->void:
		size = value
		print("set size ", size)

@export var polygon : Polygon2D :
	set(value):
		polygon = value
		if polygon and handles:
			set_polygon_vertices()
			
			
@export var handles : Node2D :
	set(value):
		handles = value
		print("set Handles")
		
@export var controller : VideoControl

@export var collider: CollisionPolygon2D

var active : bool = false
var hover : bool = false
var bottom_right: Vector2

func _ready() -> void:
	set_polygon_vertices()

func switch_videocontrol_visibility()->void:
	handles.visible = !handles.visible
	print(name, " handles visible ", visible)


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("left_mouse") and hover:
			active = true
		elif Input.is_action_just_released("left_mouse"):
			active = false
	
		if active:
			position = get_global_mouse_position()-polygon.position 


#func _on_resized() -> void:
	##set_polygon_vertices()
	#set_screen_size(get_viewport_rect().size)
	#pass

func set_polygon_vertices()->void:
	var vertices : PackedVector2Array = []
	
	var vec2 := Vector2(0,0)

	
	for d in divisions+1:
		vec2 = Vector2(size.x*d/float(divisions), 0.0)
		vertices.append(vec2)
	
	for d in divisions:
		vec2 = Vector2(size.x, size.y*((d+1)/float(divisions)))
		vertices.append(vec2)
	
	for d in divisions:
		vec2 = Vector2(size.x * (((divisions-1)-d)/float(divisions)), size.y)
		vertices.append(vec2)
	
	for d in divisions:

		vec2 = Vector2(0.0 , size.y * (((divisions-1)-d)/float(divisions)))
		if vec2 == Vector2(0,0):
			pass
		else:
			vertices.append(vec2)
	
	
	polygon.polygon = vertices
	
	

	for v in vertices.size():
		vertices[v] = (vertices[v] / size) * polygon.texture.get_size()

	polygon.uv = vertices
	
	print(collider.polygon)
	

	gen_handles()
	print("set polygon vertices")
	
func gen_handles()->void:
	print("generating " + str(handles) +  " handles")
	
	for i in handles.get_children():
		i.queue_free()
	
	
	
	for v in polygon.polygon.size():
		var h := Handle2D.new()
		h.idx = v
		h.polygon = polygon
		h.size = Vector2(40,40)
		#the handles node is outside of the polygon 2D, so:
		h.position = polygon.polygon[v]*polygon.scale + polygon.position
		#center on button
		h.position -= h.size/2.0		
		handles.add_child(h)
		h.button_up.connect(handle_released)
		
		

	
	update_area2D()
		
func handle_released()->void:
	update_area2D()
	
func update_area2D()->void:
	var collider_polygon : PackedVector2Array = []
	bottom_right = Vector2.ZERO
	
	for h in handles.get_children():
		#for use in recentering on mouse click
		bottom_right.x = max(h.position.x, bottom_right.x)
		bottom_right.y = max(h.position.y, bottom_right.y)
		
		var vert : Vector2 = h.position/polygon.scale
		vert -= polygon.position/polygon.scale
		#center on handles
		vert += h.size/(2.0*polygon.scale)
		collider_polygon.append(vert)
		bottom_right.x = max(bottom_right.x, h.position.x)
		bottom_right.y = max(bottom_right.y, h.position.y)
	
	collider.polygon = collider_polygon
		
	
	
func _exit_tree() -> void:
	if controller:
		controller.queue_free()
	


func _on_area_2d_mouse_entered() -> void:
	if handles.visible:
		modulate = Color(1,0,0,1)
	
	hover = true
	


func _on_area_2d_mouse_exited() -> void:
	modulate = Color(1,1,1,1)
	hover = false
	
