extends Node

var custom_cursor: Node

func _ready():
	var cursor_scene = preload("res://Scenes/UI/cursor.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	custom_cursor = cursor_scene.instantiate()
	custom_cursor.visible = true
	custom_cursor.z_index = 1000  # Set a high z-index to ensure it's on top
	add_child(custom_cursor)

func show_cursor():
	if custom_cursor:
		custom_cursor.visible = true

func hide_cursor():
	if custom_cursor:
		custom_cursor.visible = false

func _process(delta):
	if custom_cursor:
		custom_cursor.position = get_viewport().get_mouse_position()
