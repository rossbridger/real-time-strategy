extends Node

const DRAGBOX_MIN_SIZE := 4 # area values
@onready var ui_dragbox := $NinePatchRect

func dragbox_select_object(object_list: Array[Node], dragbox_rect: Rect2) -> void:
	for object: Node3D in object_list:
		var position_in_2d: Vector2 = get_viewport().get_camera_3d().unproject_position(object.global_position)
		if dragbox_rect.has_point(position_in_2d):
			_selected_object(object)
		else:
			_deselect_object(object)

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

func _selected_object(object: Node) -> void:
	object.selection = true

func _deselect_object(object: Node) -> void:
	object.selection = false

func _toggle_select_object(object: Node) -> void:
	object.selection = !object.selection
