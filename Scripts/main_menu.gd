extends CanvasLayer

@export var game_scene: PackedScene
@export var menu_options: PackedScene
var config: ConfigFile = ConfigFile.new()
var fullscreen = Settings.fullscreen
var fullscreen_toggle = load("$res://menu_options.tscn/fullscreen_toggle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_position(Vector2(1000, 100))
	CursorManager.show_cursor()
	
	# Ensure that Settings singleton is loaded
	if Settings:
		Settings.load_settings()
		
		if fullscreen_toggle:
			fullscreen_toggle.set_pressed(fullscreen)
			Settings.apply_settings()
			fullscreen_toggle.toggled.connect(_on_fullscreen_toggle_toggled)
		else:
			print("FullscreenToggle node not found")

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	Settings.set_fullscreen(toggled_on)
	if fullscreen_toggle:
		fullscreen_toggle.set_pressed(toggled_on)
	else:
		print("FullscreenToggle node not found")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_load_game_pressed() -> void:
	pass # Replace with function body.

func _on_continue_pressed() -> void:
	pass # Replace with function body.

func _on_new_game_pressed():
	#Start a new game.
	get_tree().change_scene_to_packed(game_scene)

func _on_options_pressed():
	#Go to the options menu.
	get_tree().change_scene_to_packed(menu_options)

func _on_exit_game_pressed():
	#Quit the game
	get_tree().quit()
