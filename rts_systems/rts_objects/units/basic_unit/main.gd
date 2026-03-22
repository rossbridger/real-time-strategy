extends MeshInstance3D

@onready var selected_sprite := $CircleSelection
@onready var obj_selection_aabb: MeshInstance3D = $SelectionAABB

var selected := false

var selection: bool = false:
	set(new_value):
		selected = new_value
		if selected:
			selected_sprite.show()
		else:
			selected_sprite.hide()
	get():
		return selected

func _ready() -> void:
	startup()

func startup() -> void:
	obj_selection_aabb.queue_free()
	#obj_selection_aabb.mesh = BoxMesh.new()
	#var selection_aabb := global_transform * mesh.get_aabb()
	#var aabb_center := selection_aabb.position + selection_aabb.size * 0.5
	#obj_selection_aabb.mesh.size = selection_aabb.size
	#obj_selection_aabb.position = aabb_center
