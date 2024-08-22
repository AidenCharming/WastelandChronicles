extends Node

var cursor_scene = load("res://Scenes/UI/cursor.tscn")
var custom_cursor: CanvasLayer

func _ready():
	print("CursorManager script is running")
	
	if cursor_scene is PackedScene:
		print("cursor_scene is a valid PackedScene")
		custom_cursor = cursor_scene.instantiate() as CanvasLayer
		if custom_cursor:
			call_deferred("add_cursor_to_scene")
		else:
			print("Failed to instantiate cursor from scene")
	else:
		print("Error: cursor_scene is not a PackedScene")

func add_cursor_to_scene():
	get_tree().root.add_child(custom_cursor)
	var cursor_node = custom_cursor.get_node("Cursor")
	if cursor_node:
		cursor_node.position = get_viewport().size / 2  # Center the cursor
	else:
		print("Error: 'Cursor' node not found")
	custom_cursor.visible = true
	print("Cursor instantiated and added to the scene tree successfully")
