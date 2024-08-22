extends Node2D

@onready var fullscreen_toggle = $FullscreenToggle

func _ready() -> void:
	if Settings:
		Settings.load_settings()
		update_fullscreen_toggle()
		Settings.apply_settings()  # Ensure settings are applied on load
		
		if fullscreen_toggle:
			fullscreen_toggle.toggled.connect(_on_fullscreen_toggle_toggled)
		else:
			print("FullscreenToggle node not found")

func update_fullscreen_toggle() -> void:
	if fullscreen_toggle:
		fullscreen_toggle.set_pressed(Settings.fullscreen)
		fullscreen_toggle.text = "Fullscreen: " + ("On" if Settings.fullscreen else "Off")
	else:
		print("FullscreenToggle node not found")

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	Settings.set_fullscreen(toggled_on)
	Settings.apply_settings()  # Ensure settings are applied when toggled
	update_fullscreen_toggle()
