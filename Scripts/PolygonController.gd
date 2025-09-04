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

func _ready() -> void:
	set_polygon_vertices()

func switch_videocontrol_visibility()->void:
	handles.visible = !handles.visible
	print(name, " handles visible ", visible)


func _process(delta: float) -> void:
	pass


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
		h.position = polygon.polygon[v]*polygon.scale + polygon.position
		h.position -= h.size/2.0
		handles.add_child(h)

func _exit_tree() -> void:
	if controller:
		controller.queue_free()
	
