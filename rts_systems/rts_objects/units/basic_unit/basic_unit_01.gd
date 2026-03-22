extends MeshInstance3D

@onready var selected_sprite := $CircleSelection

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
