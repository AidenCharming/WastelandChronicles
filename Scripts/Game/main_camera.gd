extends Camera2D

@export var move_speed: float = 200.0
@export var drag_sensitivity: float = 50.0
@export var lerp_factor: float = 0.15

var is_dragging: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO
var target_position: Vector2
var block_camera_movement: bool = false

func _ready() -> void:
	target_position = position
	# Connect to the card's signal using a Callable
	var card_instance = get_node_or_null("SurvivorCard")
	if card_instance:
		card_instance.connect("card_clicked", Callable(self, "_on_card_clicked"))
	else:
		print("Error: SurvivorCard node not found.")

func _physics_process(delta: float) -> void:
	handle_keyboard_input(delta)
	if not block_camera_movement:
		handle_camera_drag(delta)
	
	# Smoothly move the camera towards the target position
	position = lerp(position, target_position, lerp_factor)
	
	# Snap camera position to the nearest pixel
	position.x = round(position.x)
	position.y = round(position.y)

func handle_keyboard_input(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction.x += 1

	target_position += direction.normalized() * move_speed * delta

func handle_camera_drag(delta: float) -> void:
	if !get_viewport().gui_get_drag_data():
		if Input.is_action_just_pressed("click") and not is_mouse_over_card():
			is_dragging = true
			last_mouse_position = get_global_mouse_position()
		elif Input.is_action_just_released("click"):
			is_dragging = false
			
		if is_dragging:
			var mouse_position = get_global_mouse_position()
			var mouse_delta = last_mouse_position - mouse_position
			
			if mouse_delta != Vector2.ZERO:
				target_position += mouse_delta * drag_sensitivity * delta
				last_mouse_position = mouse_position

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not is_mouse_over_card():
				is_dragging = true
				last_mouse_position = get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_dragging = false

func is_mouse_over_card() -> bool:
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()

	# Load and instance the card scene
	var card_scene = preload("res://Scenes/Cards/Card.tscn")
	if not card_scene:
		print("Error: Card scene could not be loaded.")
		return false
	
	# Create an instance of the card scene
	var card_instance = card_scene.instantiate() as Control
	if not card_instance:
		print("Error: Card instance could not be created.")
		return false

	# Access the SurvivorCard node inside the card_instance
	var survivor_card = card_instance.get_node_or_null("SurvivorCard") as Sprite2D
	if not survivor_card:
		card_instance.queue_free()
		print("Error: SurvivorCard node not found in card scene.")
		return false

	# Get card's position and size in screen coordinates
	var card_global_pos = card_instance.get_global_position()
	var card_size = survivor_card.texture.get_size()
	var card_rect = Rect2(card_global_pos - card_size / 2, card_size)
	
	# Clean up card_instance if not needed
	card_instance.queue_free()
	
	# Check if the mouse position is within the card's bounds
	return card_rect.has_point(mouse_pos)

func _on_card_clicked() -> void:
	block_camera_movement = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				block_camera_movement = false
