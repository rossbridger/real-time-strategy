extends Node3D

const CAMERA_PAN_MARGIN: float = 5.0 #pixels to trigger pan on screen edge

var cam_movement_velocity = Vector3.ZERO
@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	_setup_camera(camera_3d)

func _process(delta: float) -> void:
	camera_pan(delta)
	_apply_movement_velocity()

func camera_pan(delta: float) -> void:
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

func _setup_camera(cam: Camera3D) -> void:
	cam.fov = 10
	cam.position.y = 3.0
	cam.rotation.x = deg_to_rad(-30)
	rotation.y = deg_to_rad(-45)
	cam.translate_object_local(Vector3(0, 0, 100))

func _apply_movement_velocity():
	if cam_movement_velocity != Vector3.ZERO:
		translate_object_local(cam_movement_velocity * 40)
		cam_movement_velocity = Vector3.ZERO
