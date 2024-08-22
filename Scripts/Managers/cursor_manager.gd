extends Node

var cursor_scene = preload("res://Scenes/UI/cursor.tscn")
var custom_cursor: Node

func _ready():
	print("CursorManager ready")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	custom_cursor = cursor_scene.instantiate()
	print("Cursor instantiated")
	add_child(custom_cursor)
	custom_cursor.visible = true
	custom_cursor.z_index = 1000
	custom_cursor.position = Vector2(500, 500)

func show_cursor():
	print("Showing cursor")
	if custom_cursor:
		custom_cursor.visible = true

func hide_cursor():
	print("Hiding cursor")
	if custom_cursor:
		custom_cursor.visible = false
