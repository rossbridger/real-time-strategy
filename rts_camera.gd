extends Node3D

const CAMERA_PAN_MARGIN := 5.0 #pixels to trigger pan on screen edge
const CAMERA_ROTATION_SPEED := 1.0
const CAMERA_ZOOM_SPEED := 4.0
const CAMERA_ZOOM_RANGE := Vector2(50, 200)
const CAMERA_MOVE_SPEED := Vector2(40, 100)
var cam_movement_velocity := Vector3.ZERO
var cam_zoom_velocity := 0.0


@onready var camera_3d := $Camera3D

func _ready() -> void:
	_setup_camera(camera_3d)

func _process(delta: float) -> void:
	camera_pan(delta)
	camera_move(delta)
	camera_rotate(delta)
	camera_zoom(delta)
	_apply_movement_velocity()
	_apply_zoom_velocity()

func camera_pan(delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		return
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	if mouse_pos.x < CAMERA_PAN_MARGIN:
		cam_movement_velocity.x = -1 * delta
	if mouse_pos.y < CAMERA_PAN_MARGIN:
		cam_movement_velocity.z = -1 * delta
	if mouse_pos.x > viewport_size.x - CAMERA_PAN_MARGIN:
		cam_movement_velocity.x = 1 * delta
	if mouse_pos.y > viewport_size.y - CAMERA_PAN_MARGIN:
		cam_movement_velocity.z = 1 * delta

func camera_move(delta: float) -> void:
	if Input.is_action_pressed("camera_forward"):
		cam_movement_velocity.z = -1 * delta
	if Input.is_action_pressed("camera_backward"):
		cam_movement_velocity.z = 1 * delta
	if Input.is_action_pressed("camera_left"):
		cam_movement_velocity.x = -1 * delta
	if Input.is_action_pressed("camera_right"):
		cam_movement_velocity.x = 1 * delta

func camera_rotate(delta: float) -> void:
	if Input.is_action_pressed("camera_rotate_right"):
		global_rotation.y += CAMERA_ROTATION_SPEED * delta
	if Input.is_action_pressed("camera_rotate_left"):
		global_rotation.y -= CAMERA_ROTATION_SPEED * delta

func camera_zoom(delta: float) -> void:
	if Input.is_action_just_pressed("camera_zoom_in"):
		cam_zoom_velocity -= (CAMERA_ZOOM_SPEED * 1000) * delta
	if Input.is_action_just_pressed("camera_zoom_out"):
		cam_zoom_velocity += (CAMERA_ZOOM_SPEED * 1000) * delta

func _setup_camera(cam: Camera3D) -> void:
	cam.fov = 10
	cam.position.y = 3.0
	cam.rotation.x = deg_to_rad(-30)
	rotation.y = deg_to_rad(-45)
	cam.translate_object_local(Vector3(0, 0, 100))

func _apply_movement_velocity():
	if cam_movement_velocity != Vector3.ZERO:
		var camera_zoom_speed := remap(
			camera_3d.position.z,
			CAMERA_ZOOM_RANGE.x, CAMERA_ZOOM_RANGE.y,
			CAMERA_MOVE_SPEED.x, CAMERA_MOVE_SPEED.y
		)
		translate_object_local(cam_movement_velocity * camera_zoom_speed)
		cam_movement_velocity = Vector3.ZERO

func _apply_zoom_velocity(cam: Camera3D = camera_3d) -> void:
	if cam_zoom_velocity != 0:
		var calculated_zoom := cam.position.z + cam_zoom_velocity
		if calculated_zoom > CAMERA_ZOOM_RANGE.x \
		&& calculated_zoom < CAMERA_ZOOM_RANGE.y:
			cam.translate_object_local(Vector3(0, 0, cam_zoom_velocity))
	cam_zoom_velocity = 0
