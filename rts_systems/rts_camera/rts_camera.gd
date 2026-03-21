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
	_apply_movement_velocity()
	_apply_zoom_velocity()

func camera_pan(mouse_pos: Vector2, viewport_size: Vector2, delta: float) -> void:
	if mouse_pos.x < CAMERA_PAN_MARGIN:
		cam_movement_velocity.x = -1 * delta
	if mouse_pos.y < CAMERA_PAN_MARGIN:
		cam_movement_velocity.z = -1 * delta
	if mouse_pos.x > viewport_size.x - CAMERA_PAN_MARGIN:
		cam_movement_velocity.x = 1 * delta
	if mouse_pos.y > viewport_size.y - CAMERA_PAN_MARGIN:
		cam_movement_velocity.z = 1 * delta

func camera_move(direction: Vector2, delta: float) -> void:
		cam_movement_velocity.x = direction.x * delta
		cam_movement_velocity.z = direction.y * delta

func camera_rotate(direction: float, delta: float) -> void:
		global_rotation.y += direction * CAMERA_ROTATION_SPEED * delta

func camera_zoom(direction: float, delta: float) -> void:
	cam_zoom_velocity += direction * (CAMERA_ZOOM_SPEED * 1000) * delta

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
