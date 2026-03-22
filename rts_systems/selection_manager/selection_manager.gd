extends Node

const DRAGBOX_MIN_SIZE := 4 # area values
@onready var ui_dragbox := $NinePatchRect

func get_dragbox_select_objects(object_list: Array[Node], dragbox_rect: Rect2) -> Array[Node3D]:
	var selected_array:Array[Node3D] = []
	for object: Node3D in object_list:
		var position_in_2d: Vector2 = get_viewport().get_camera_3d().unproject_position(object.global_position)
		if dragbox_rect.has_point(position_in_2d):
			selected_array.append(object)
	return selected_array

func select_object_by_aabb(object: MeshInstance3D, mouse_pos: Vector2, camera: Camera3D) -> bool:
	var object_aabb: AABB = object.global_transform * object.mesh.get_aabb()
	if object_aabb.intersects_ray(camera.project_ray_origin(mouse_pos),
	camera.project_ray_normal(mouse_pos)):
		return true
	return false

func update_selection_rectangle(new_rect: Rect2) -> void:
	new_rect = new_rect.abs()
	ui_dragbox.position = new_rect.position
	ui_dragbox.size = new_rect.size
	
	if new_rect.get_area() > DRAGBOX_MIN_SIZE:
		ui_dragbox.show()

func dragbox_show():
	ui_dragbox.show()

func dragbox_hide():
	ui_dragbox.hide()

func select_array(array: Array[Node3D]):
	for object in array:
		_select_object(object)

func deselect_array(array: Array[Node3D]):
	for object in array:
		_deselect_object(object)

func _select_object(object: Node) -> void:
	object.selection = true

func _deselect_object(object: Node) -> void:
	object.selection = false

func _toggle_select_object(object: Node) -> void:
	object.selection = !object.selection
