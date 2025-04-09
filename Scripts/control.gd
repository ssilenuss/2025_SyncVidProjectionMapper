@tool
extends Control

@export_range(1, 4, 1) var divisions : int = 1

@export var set_vertices : bool :
	set(value):
		
		if polygon:
			set_polygon_vertices()
			


@export var polygon : Polygon2D :
	set(value):
		polygon = value
		if polygon and handles:
			set_polygon_vertices()
			
@export var handles : Node2D :
	set(value):
		handles = value
		

func _ready() -> void:
	set_polygon_vertices()


func _process(delta: float) -> void:
	pass


func _on_resized() -> void:
	set_polygon_vertices()

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
	
func gen_handles()->void:
	print(handles)
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
