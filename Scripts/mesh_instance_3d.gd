extends MeshInstance3D

var mdt : MeshDataTool
var pins : PackedColorArray
var prev_verts : PackedVector3Array
var verts :PackedVector3Array
var next_verts : PackedVector3Array
var normals : PackedVector3Array

var edges : PackedInt32Array
var v_edges: Array = []
var dists : Array = []
var nverts : int #num verts

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
	
func create_mesh()->void:
	mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	nverts = mdt.get_vertex_count()
	
	verts = []
	v_edges = []
	normals = []
	dists = []
	pins = []
	
	for i in range(nverts):
		verts.append(mdt.get_vertex(i))
		v_edges.append(mdt.get_vertex_edges(i))
		normals.append(mdt.get_vertex_normal(i))
		# for each edge, save default edgelength
		dists.append([])
		# pinned vertices have a vertex color > 0 
		pins.append (mdt.get_vertex_color(i))
		
	# save default lengths
	for i in range(nverts):
		for j in range(v_edges[i].size()):
			var diff=verts[mdt.get_edge_vertex(v_edges[i][j],0)] - verts[mdt.get_edge_vertex(v_edges[i][j],1)]
			dists[i].append(diff.length())
	
	# with pool data arrays, assigning to variables copies the data , rather than the reference
	# which is handy for us in this case
	next_verts=verts
	prev_verts=verts
#var mdt
#var pins :PoolColorArray		# vertex data (colorset) to define pinned verts
#var prevverts: PoolVector3Array # previous state of mesh
#var verts: PoolVector3Array		# current state of mesh
#var nextverts: PoolVector3Array # next state of mesh
#var normals: PoolVector3Array # 
#
#var edges:PoolIntArray	# edges in mesh
#var vedges=[]	# 2d array, the edges connected to each vertex 
#var dists=[]	# rest state length of each edge
#var nverts 		# number of verts
#var hasdata=false
#export var tension=0.5 # default tension of edge 'spring'
#export var verlet=.7 # how much of previous state  to use
#
## 'ball' position for demo
#var col
#export var cvel:Vector3
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#
	#mdt=MeshDataTool.new()
#
	## grab data from mesh
	#mdt.create_from_surface(mesh,0)
	#nverts=mdt.get_vertex_count()
	#
	#for i in range(nverts):
		#verts.append(mdt.get_vertex(i))
		#vedges.append(mdt.get_vertex_edges(i))
		#normals.append(mdt.get_vertex_normal(i))
		## for each edge, save default edgelength
		#dists.append([])
		## pinned vertices have a vertex color > 0 
		#pins.append (mdt.get_vertex_color(i))
		#
	## save default lengths
	#for i in range(nverts):
		#for j in range(vedges[i].size()):
			#var diff=verts[mdt.get_edge_vertex(vedges[i][j],0)] - verts[mdt.get_edge_vertex(vedges[i][j],1)]
			#dists[i].append(diff.length())
		#
	#
	## with pool data arrays, assigning to variables copies the data , rather than the reference
	## which is handy for us in this case
	#nextverts=verts
	#prevverts=verts
	#
	## ball object
	#col = get_parent().get_node("Coll")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
	## we take the data from the previous frame and calculate a new set of vertex positions
	#
	#mdt.create_from_surface(mesh,0)
	#
	#for i in range(nverts):
		## gravity
		#var forces=Vector3(0,-0.002500,0)
		#var force=Vector3.ZERO
		## loop over edges for this vertex and compare rest length to current length
		#for j in range(vedges[i].size()):
			#var v = vedges[i][j]
			#var v1 = verts[mdt.get_edge_vertex(v,0)]
			#var v2 = verts[mdt.get_edge_vertex(v,1)]
			#var sv = v1-v2
			## slight hack because the edge vertices can sometimes be flipped
			#if  (i==mdt.get_edge_vertex(v,0)):
				#sv=-sv
			#
			## simple spring damper model
			#var nl=dists[i][j]
			#var l = sv.length()
			#var fs =(l-nl)/nl
			#
			#force += sv * fs * 0.5
		#
		## 'tension' is the stiffness of the spring
		#forces += force * tension
		#
		## for demo , move the points if they are close to the ball
		#var dball = verts[i] - col.translation 
		#forces+=(1.0-smoothstep(1,3,dball.length()))*10.0 * normals[i] * pins[i].r 
		#
		#var last= (verts[i]-prevverts[i] ) * verlet
		#nextverts[i] = last + verts[i] + (forces  * pins[i].r ) * delta 
		#
		#
		#mdt.set_vertex(i, nextverts[i])
		#
	## update mesh
	#mesh.surface_remove(0)
	#mdt.commit_to_surface(mesh)
	## copy data for next frame
	#prevverts=verts
	#verts=nextverts
	#
	#
	## move the ball around
	#if (Input.is_action_pressed("ui_left")):
		#col.translation.x-=1
	#elif (Input.is_action_pressed("ui_right")):
		#col.translation.x+=1
	#if (Input.is_action_pressed("ui_up")):
		#col.translation.z-=1
	#elif (Input.is_action_pressed("ui_down")):
		#col.translation.z+=1

func update_mesh()->void:
	mdt.create_from_surface(mesh,0)
	
	for i in range(nverts):
		# gravity
		var forces=Vector3(0,-0.002500,0)
		var force=Vector3.ZERO
		# loop over edges for this vertex and compare rest length to current length
		for j in range(v_edges[i].size()):
			var v = v_edges[i][j]
			var v1 = verts[mdt.get_edge_vertex(v,0)]
			var v2 = verts[mdt.get_edge_vertex(v,1)]
			var sv = v1-v2
			# slight hack because the edge vertices can sometimes be flipped
			if  (i==mdt.get_edge_vertex(v,0)):
				sv=-sv
			
			# simple spring damper model
			var nl=dists[i][j]
			var l = sv.length()
			var fs =(l-nl)/nl
			
			force += sv * fs * 0.5
		
		## 'tension' is the stiffness of the spring
		#forces += force * tension
		
		# for demo , move the points if they are close to the ball
		var dball = verts[i] - col.translation 
		forces+=(1.0-smoothstep(1,3,dball.length()))*10.0 * normals[i] * pins[i].r 
		
		var last= (verts[i]-prevverts[i] ) * verlet
		nextverts[i] = last + verts[i] + (forces  * pins[i].r ) * delta 
		
		
		mdt.set_vertex(i, nextverts[i])
		
	# update mesh
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	# copy data for next frame
	prevverts=verts
	verts=nextverts
	
	
	# move the ball around
	if (Input.is_action_pressed("ui_left")):
		col.translation.x-=1
	elif (Input.is_action_pressed("ui_right")):
		col.translation.x+=1
	if (Input.is_action_pressed("ui_up")):
		col.translation.z-=1
	elif (Input.is_action_pressed("ui_down")):
		col.translation.z+=1
