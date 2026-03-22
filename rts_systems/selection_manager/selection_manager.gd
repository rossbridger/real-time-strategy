extends Node

const DRAGBOX_MIN_SIZE := 4
@onready var ui_dragbox := $NinePatchRect

func update_selection_rectangle(new_rect: Rect2) -> void:
	new_rect = new_rect.abs()
	ui_dragbox.position = new_rect.position
	ui_dragbox.size = new_rect.size
	
	if new_rect.get_area() > DRAGBOX_MIN_SIZE:
		ui_dragbox.show()

func dragbox_show():
	ui_dragbox.show()

func dragbox_hide():
	ui_dragbox.hide()
