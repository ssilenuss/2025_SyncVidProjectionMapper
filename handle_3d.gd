extends Area3D

class_name Handle3D

var hover :bool = false

@export var color : Color = Color.WHITE
@export var hover_color : Color = Color.RED

@onready var material : StandardMaterial3D= $MeshInstance3D.get_active_material(0)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered()->void:
	hover = true
	material.albedo_color = hover_color


func _on_mouse_exited()->void:
	hover = false
	material.albedo_color = color

	
func _process(delta: float) -> void:
	if hover and Input.is_action_pressed("left_mouse"):
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var intersect := get_mouse_intersect(mouse_pos)
		if intersect.is_empty():
			return
		if intersect.collider:
			print(intersect.position)
			intersect.collider.global_position.x = intersect.position.x
			intersect.collider.global_position.y = intersect.position.y


func get_mouse_intersect(_mouse_pos: Vector2)->Dictionary:
	
	var current_camera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	params.collide_with_areas = true
	params.from = current_camera.project_ray_origin(_mouse_pos)
	params.to = current_camera.project_position(_mouse_pos, 1000)
	
	var worldspace := get_world_3d().direct_space_state
	var result := worldspace.intersect_ray(params)
	return result
	
