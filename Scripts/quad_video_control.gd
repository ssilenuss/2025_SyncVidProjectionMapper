@tool
extends Control

@export var reset_handles:= false :
	set(value):
		generate_handles()
@export var camera : Camera3D
@export var video_mesh : MeshInstance3D
@export var quad_mesh := QuadMesh.new()
@export_range(0,4,1) var sub_div_x : int = 0 : 
	set(value):
		sub_div_x = value
		generate_quadmesh()
		
@export_range(0,4,1) var sub_div_y : int = 0 : 
	set(value):
		sub_div_y = value
		generate_quadmesh()

func generate_quadmesh()->void:
	quad_mesh = QuadMesh.new()
	if size.x > size.y:
		quad_mesh.size.x= size.x/size.y
	else:
		quad_mesh.size.y = size.y/size.x
	quad_mesh.subdivide_width = sub_div_x
	quad_mesh.subdivide_depth = sub_div_y
	generate_video_mesh()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_quadmesh()
	generate_handles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resized() -> void:
	generate_quadmesh()

func generate_handles()->void:
	var handles : Node2D = $handles
	
	for h in handles.get_children():
		h.queue_free()
		
	var mdt := MeshDataTool.new()
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, quad_mesh.get_mesh_arrays()  )
	var error := mdt.create_from_surface(array_mesh,0)
	check_error(error, "could not create mesh")
	
	var vertices : PackedVector2Array = []

	for index in mdt.get_vertex_count():
		var vertex : Vector3 = mdt.get_vertex(index)
		var x := remapf(vertex.x, -quad_mesh.size.x/2.0, quad_mesh.size.x/2.0, 0, size.x)
		var y := remapf(vertex.y, -quad_mesh.size.y/2.0, quad_mesh.size.y/2.0, 0, size.y)
		vertices.append(Vector2(x, y))
	
	var h_idx : int = 0
	for v in vertices:
		var h = MeshHandle.new()
		handles.add_child(h)
		h.new_pos.connect(_on_handle_moved)
		h.position = v-h.size/2.0
		h.idx = h_idx
		h_idx += 1
		
		
func _on_handle_moved(_idx:int, _pos:Vector2)->void:

	print(_idx, _pos)
	var mdt := MeshDataTool.new()
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, quad_mesh.get_mesh_arrays()  )
	var error := mdt.create_from_surface(array_mesh,0)
	check_error(error, "could not create mesh")
	
	var vertex : Vector3 = mdt.get_vertex(_idx)
	vertex.x = remapf(_pos.x, 0, size.x, -quad_mesh.size.x/2.0, quad_mesh.size.x/2.0)
	vertex.y = remapf(_pos.y, 0, size.y, -quad_mesh.size.y/2.0, quad_mesh.size.y/2.0)
	mdt.set_vertex(_idx, vertex)
	print(vertex)
	error = mdt.commit_to_surface(array_mesh)
	check_error(error, "could not create mesh")
	video_mesh.mesh = array_mesh
	

	
func generate_video_mesh()->void:
	var mdt := MeshDataTool.new()
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, quad_mesh.get_mesh_arrays()  )
	var error := mdt.create_from_surface(array_mesh,0)
	#var error : Error = mdt.create_from_surface(video_mesh.mesh, 0)
	check_error(error, "could not create mesh")
	
	for index in mdt.get_vertex_count():
		var vertex : Vector3 = mdt.get_vertex(index)
		#change vertex here
		#vertex = Vector3(new,new)
		mdt.set_vertex(index, vertex)
	
	error = mdt.commit_to_surface(array_mesh)
	check_error(error, "could not create mesh")
	video_mesh.mesh = array_mesh
	

func manipulate_surface()->void:
	var mdt := MeshDataTool.new()
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, (video_mesh.mesh as QuadMesh).get_mesh_arrays()  )
	var error := mdt.create_from_surface(array_mesh,0)
	#var error : Error = mdt.create_from_surface(video_mesh.mesh, 0)
	check_error(error, "could not create mesh")
	
	for index in mdt.get_vertex_count():
		var vertex : Vector3 = mdt.get_vertex(index)
		#change vertex here
		#vertex = Vector3(new,new)
		mdt.set_vertex(index, vertex)
	
	error = mdt.commit_to_surface(array_mesh)
	check_error(error, "could not create mesh")
	video_mesh.mesh = array_mesh

func check_error(_error: Error, _fail_message: String)->void:
	if _error != OK:
		print(_fail_message)
		return

func remapf(value:float, InputA:float, InputB:float, OutputA:float, OutputB:float)->float:
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
