extends Node

const TYPE_RTS_CAMERA := preload("../rts_camera/rts_camera.gd")

@onready var rts_camera := $"../RTSCamera"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	camera_pan(rts_camera, delta)
	camera_move(rts_camera, delta)
	camera_rotate(rts_camera, delta)
	camera_zoom(rts_camera, delta)

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
