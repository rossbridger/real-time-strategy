extends Node

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter") \
	|| Input.is_action_just_released("mouseclick_left"):
		get_viewport().set_input_as_handled()
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

	if Input.is_action_just_released("esc"):
		get_viewport().set_input_as_handled()
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().quit()
