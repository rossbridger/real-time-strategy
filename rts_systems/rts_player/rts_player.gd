extends Node

const TYPE_RTS_CAMERA := preload("../rts_camera/rts_camera.gd")
const TYPE_SELECTION_MANAGER := preload("../selection_manager/selection_manager.gd")

@onready var rts_camera := $"../RTSCamera"
@onready var selection_manager := $SelectionManager
@onready var units := $"../Units"

var mouse_dragbox_start_position := Vector2.ZERO
var mouse_dragbox_end_position := Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	camera_inputs(rts_camera, delta)
	selection_dragbox()

func selection_dragbox() -> void:
	if Input.is_action_pressed("mouseclick_left"):
		mouse_dragbox_end_position = get_viewport().get_mouse_position()
		if mouse_dragbox_start_position == Vector2.ZERO:
			mouse_dragbox_start_position = mouse_dragbox_end_position
		selection_manager.update_selection_rectangle(Rect2(
				mouse_dragbox_start_position,
				mouse_dragbox_end_position - mouse_dragbox_start_position).abs())
	if Input.is_action_just_released("mouseclick_left"):
		var dragbox_rectangle := Rect2(
				mouse_dragbox_start_position,
				mouse_dragbox_end_position - mouse_dragbox_start_position).abs()
		selection_manager.dragbox_select_object(units.get_children(), dragbox_rectangle)
		mouse_dragbox_start_position = Vector2.ZERO
		mouse_dragbox_end_position = Vector2.ZERO
		selection_manager.dragbox_hide()

func camera_inputs(camera: TYPE_RTS_CAMERA, delta: float):
	camera_pan(camera, delta)
	camera_move(camera, delta)
	camera_rotate(camera, delta)
	camera_zoom(camera, delta)

func camera_pan(camera: TYPE_RTS_CAMERA, delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		return
	var mouse_pos := get_viewport().get_mouse_position()
	var viewport_size := get_viewport().get_visible_rect().size
	camera.camera_pan(mouse_pos, viewport_size, delta)

func camera_move(camera: TYPE_RTS_CAMERA, delta: float) -> void:
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

func camera_rotate(camera: TYPE_RTS_CAMERA, delta: float) -> void:
	var direction := 0.0
	if Input.is_action_pressed("camera_rotate_right"):
		direction = 1
	if Input.is_action_pressed("camera_rotate_left"):
		direction = -1
	if direction == 0:
		return
	camera.camera_rotate(direction, delta)

func camera_zoom(camera: TYPE_RTS_CAMERA, delta: float) -> void:
	var direction := 0.0
	if Input.is_action_just_pressed("camera_zoom_in"):
		direction = -1
	if Input.is_action_just_pressed("camera_zoom_out"):
		direction = 1
	if direction == 0:
		return
	camera.camera_zoom(direction, delta)
