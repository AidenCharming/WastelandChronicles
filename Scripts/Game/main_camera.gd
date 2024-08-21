extends Camera2D

@export var move_speed: float = 200.0
@export var drag_sensitivity: float = 50.0
@export var lerp_factor: float = 0.15

var is_dragging: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO
var target_position: Vector2

func _ready() -> void:
	target_position = position

func _physics_process(delta: float) -> void:
	handle_keyboard_input(delta)
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
	if !get_viewport().gui_get_drag_data():  # Ensures the camera doesn't drag if a UI element is being interacted with
		if Input.is_action_just_pressed("click"):
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
	if !get_viewport().gui_get_drag_data():  # Ensures the camera doesn't interfere with UI element inputs
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				is_dragging = true
				last_mouse_position = get_global_mouse_position()
			elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				is_dragging = false
		elif event is InputEventMouseMotion and is_dragging:
			var card_position = get_global_mouse_position() + last_mouse_position
			position = lerp(position, card_position, lerp_factor)
