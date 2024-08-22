extends Control

@export var drag_sensitivity: float = 1.0
@export var lerp_factor: float = 0.5  # Increase for faster response

var is_dragging = false
var drag_offset = Vector2.ZERO
var target_position: Vector2

func _ready():
	target_position = position

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_dragging = true
			drag_offset = position - event.position
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_dragging = false
	elif event is InputEventMouseMotion and is_dragging:
		target_position = event.position + drag_offset * drag_sensitivity

func _process(delta: float) -> void:
	if is_dragging:
		position = position.lerp(target_position, lerp_factor)
