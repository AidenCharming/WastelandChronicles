# settings.gd
extends Node

var config: ConfigFile = ConfigFile.new()
var fullscreen: bool

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var err: int = config.load("user://settings.cfg")
	if err == OK:
		fullscreen = config.get_value("display", "fullscreen", false)
	else:
		print("Error loading config file: ", err)

func save_settings() -> void:
	config.set_value("display", "fullscreen", fullscreen)
	var save_err: int = config.save("user://settings.cfg")
	if save_err != OK:
		print("Error saving config file: ", save_err)

func set_fullscreen(value: bool) -> void:
	fullscreen = value
	save_settings()

func apply_settings() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		fullscreen = false
