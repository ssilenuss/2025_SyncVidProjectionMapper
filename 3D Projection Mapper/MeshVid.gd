extends MeshInstance3D

class_name MeshVid

@export var material : Material
#@export var handle_material : Material

@export var handle_scene : PackedScene

var verts : PackedVector3Array = []
var verts_hidden: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arraymesh_from_primitive()
	create_vertices()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		show_hide_vertices()
	pass

func arraymesh_from_primitive()->void:
	var surface_tool := SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	var array_mesh = surface_tool.commit()
	set_surface_override_material(0, material)
	mesh = array_mesh

func create_vertices()->void:
	verts = get_all_local_vertices()
	for v in verts:
		var handle : Handle3D = handle_scene.instantiate()
		add_child(handle)
		handle.scale *= 0.5
		handle.position = v
		
		
func show_hide_vertices()->void:
	verts_hidden = !verts_hidden
	if verts_hidden:
		for vert in get_children():
			vert.visible=false
	else:
		for vert in get_children():
			vert.visible=true

func get_all_local_vertices() -> PackedVector3Array:
	var local_verts: PackedVector3Array = []
	var mesh_res = mesh
	
	if not mesh_res:
		return local_verts
		
	

	var mdt = MeshDataTool.new()
	
	# Meshes can have multiple surfaces (materials)
	for surface in range(mesh_res.get_surface_count()):
		# Load the surface into the tool
		mdt.create_from_surface(mesh_res, surface)
		for i in range(mdt.get_vertex_count()):
			var local_v = mdt.get_vertex(i)
			# Transform the local Vector3 to global world space
			#var global_v = global_transform * local_v
			local_verts.append(local_v)
			
	return local_verts

func get_all_global_vertices() -> PackedVector3Array:
	var global_verts: PackedVector3Array = []
	var mesh_res = mesh
	
	if not mesh_res:
		return global_verts

	var mdt = MeshDataTool.new()
	
	# Meshes can have multiple surfaces (materials)
	for surface in range(mesh_res.get_surface_count()):
		# Load the surface into the tool
		mdt.create_from_surface(mesh_res, surface)
		
		for i in range(mdt.get_vertex_count()):
			var local_v = mdt.get_vertex(i)
			# Transform the local Vector3 to global world space
			var global_v = global_transform * local_v
			global_verts.append(global_v)
			
	return global_verts
	
func update_mesh_vertices():
	# 1. Ensure we are working with an ArrayMesh to allow modifications
	if not mesh is ArrayMesh:
		var new_mesh = ArrayMesh.new()
		new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.get_mesh_arrays())
		mesh = new_mesh

	var mdt = MeshDataTool.new()
	
	# 2. Iterate through each surface
	for surface in range(mesh.get_surface_count()):
		mdt.create_from_surface(mesh, surface)
		
		for i in range(mdt.get_vertex_count()):
			# Get the current local position
			var vertex_pos = mdt.get_vertex(i)
			
			# Modify the position (e.g., move it up by 0.5 units)
			vertex_pos.y += 0.5
			
			# Set the new position in the tool
			mdt.set_vertex(i, vertex_pos)
		
		# 3. Commit changes back to the mesh
		# Remove the old surface before adding the updated one
		mesh.surface_remove(surface)
		mdt.commit_to_surface(mesh)
