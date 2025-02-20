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
		if polygon:
			set_polygon_vertices()

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_resized() -> void:
	set_polygon_vertices()

func set_polygon_vertices()->void:
	var vertices : PackedVector2Array = []
	
	var vec2 := Vector2(0,0)
	#vertices.append(vec2)
	
	#for y in divisions+1:
		#for x in divisions+1:
			#print(divisions)
			#vec2 = Vector2(size.x * (x/float(divisions)), size.y * (y/float(divisions)) )
			#vertices.append(vec2)
	
	#print(vertices)
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
			print("returning")
		else:
			vertices.append(vec2)
	
	
	polygon.polygon = vertices
	
	
		
	for v in vertices.size():
		vertices[v] = (vertices[v] / size) * polygon.texture.get_size()
	print(vertices)
	polygon.uv = vertices
	


func _on_marker_2d_rect_changed() -> void:
	print("changed")
