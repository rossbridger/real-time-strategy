extends Node

const TYPE_HINT_RTS_CAMERA := preload("../rts_camera/rts_camera.gd")
const TYPE_HINT_SELECTION_MANAGER := preload("../selection_manager/selection_manager.gd")

@onready var obj_rts_camera:TYPE_HINT_RTS_CAMERA = $"../RTSCamera"
@onready var obj_selection_manager:TYPE_HINT_SELECTION_MANAGER = $SelectionManager
@onready var obj_units_nodetree := $"../Units"

var _mouse_dragbox_start_position := Vector2.ZERO
var _mouse_dragbox_end_position := Vector2.ZERO
var _player_selection: Array[Node3D] = []
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	camera_inputs(obj_rts_camera, delta)
	update_selection_dragbox()

func update_player_selection(new_obj_selection: Array[Node3D]) -> void:
	obj_selection_manager.deselect_array(_player_selection)
	_player_selection = new_obj_selection
	obj_selection_manager.select_array(_player_selection)

func update_selection_dragbox() -> void:
	if Input.is_action_pressed("mouseclick_left"):
		_mouse_dragbox_end_position = get_viewport().get_mouse_position()
		if _mouse_dragbox_start_position == Vector2.ZERO:
			_mouse_dragbox_start_position = _mouse_dragbox_end_position
		obj_selection_manager.update_selection_rectangle(Rect2(
				_mouse_dragbox_start_position,
				_mouse_dragbox_end_position - _mouse_dragbox_start_position).abs())
	if Input.is_action_just_released("mouseclick_left"):
		var dragbox_rectangle := Rect2(
				_mouse_dragbox_start_position,
				_mouse_dragbox_end_position - _mouse_dragbox_start_position).abs()
		if dragbox_rectangle.get_area() > obj_selection_manager.DRAGBOX_MIN_SIZE:
			update_player_selection(obj_selection_manager.get_dragbox_select_objects(obj_units_nodetree.get_children(), dragbox_rectangle))
		else:
			update_player_selection([])
			for object: Node3D in obj_units_nodetree.get_children():
				if obj_selection_manager.select_object_by_aabb(
					object,
					get_viewport().get_mouse_position(),
					get_viewport().get_camera_3d()):
					update_player_selection([object])
					break
		_mouse_dragbox_start_position = Vector2.ZERO
		_mouse_dragbox_end_position = Vector2.ZERO
		obj_selection_manager.dragbox_hide()

func camera_inputs(camera: TYPE_HINT_RTS_CAMERA, delta: float):
	_camera_pan(camera, delta)
	_camera_move(camera, delta)
	_camera_rotate(camera, delta)
	_camera_zoom(camera, delta)

func _camera_pan(camera: TYPE_HINT_RTS_CAMERA, delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		return
	var mouse_pos := get_viewport().get_mouse_position()
	var viewport_size := get_viewport().get_visible_rect().size
	camera.camera_pan(mouse_pos, viewport_size, delta)

func _camera_move(camera: TYPE_HINT_RTS_CAMERA, delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("camera_forward"):
		direction.y = -1
	if Input.is_action_pressed("camera_backward"):
		direction.y = 1
	if Input.is_action_pressed("camera_left"):
		direction.x = -1
	if Input.is_action_pressed("camera_right"):
		direction.x = 1
	if direction == Vector2.ZERO:
		return
	camera.camera_move(direction, delta)

func _camera_rotate(camera: TYPE_HINT_RTS_CAMERA, delta: float) -> void:
	var direction := 0.0
	if Input.is_action_pressed("camera_rotate_right"):
		direction = 1
	if Input.is_action_pressed("camera_rotate_left"):
		direction = -1
	if direction == 0:
		return
	camera.camera_rotate(direction, delta)

func _camera_zoom(camera: TYPE_HINT_RTS_CAMERA, delta: float) -> void:
	var direction := 0.0
	if Input.is_action_just_pressed("camera_zoom_in"):
		direction = -1
	if Input.is_action_just_pressed("camera_zoom_out"):
		direction = 1
	if direction == 0:
		return
	camera.camera_zoom(direction, delta)
