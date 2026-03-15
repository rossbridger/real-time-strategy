extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	_setup_camera(camera_3d)

func _setup_camera(cam: Camera3D) -> void:
	cam.fov = 10
	cam.position.y = 3.0
	cam.rotation.x = deg_to_rad(-30)
	rotation.y = deg_to_rad(-45)
	cam.translate_object_local(Vector3(0, 0, 100))
