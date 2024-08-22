extends Control

@export var drag_sensitivity: float = 1.0
@export var lerp_factor: float = 0.2  # Smoothness factor for movement

var is_dragging = false
var drag_offset = Vector2.ZERO
var target_position: Vector2
var card: Sprite2D  # Reference to the Card node as Sprite2D

func _ready():
	card = $SurvivorCard  # Initialize card reference with the correct node name
	if card:
		print("SurvivorCard node successfully initialized.")
		# Initialize target_position based on card's position
		target_position = card.position
	else:
		print("Error: SurvivorCard node not found. Check if the node named 'SurvivorCard' exists and is correctly named.")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if card and is_point_in_sprite(card, get_viewport().get_mouse_position()):
					is_dragging = true
					# Calculate drag offset correctly
					drag_offset = card.position - get_viewport().get_mouse_position()
				else:
					print("Click outside card detected. Event position: ", event.position)
			else:
				if is_dragging:  # Only reset if dragging was active
					is_dragging = false

func _process(_delta: float) -> void:
	if is_dragging and card:
		# Calculate the target position based on mouse position and drag offset
		target_position = get_viewport().get_mouse_position() + drag_offset
		# Smoothly move the card to the target position
		card.position = card.position.lerp(target_position, lerp_factor)

# Utility function to check if a point is within a Sprite2D's area
func is_point_in_sprite(sprite: Sprite2D, point: Vector2) -> bool:
	var rect = sprite.get_rect()
	var local_point = sprite.to_local(point)
	return rect.has_point(local_point)
