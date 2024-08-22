extends Control

@export var lerp_factor: float = 0.2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide the system cursor

func _process(delta: float) -> void:
	var target_position = get_viewport().get_mouse_position()
	position = position.lerp(target_position, lerp_factor)
