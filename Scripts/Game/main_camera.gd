extends Camera2D

@export var move_speed: float = 200.0
@export var drag_sensitivity: float = 50.0

var is_dragging: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	handle_keyboard_input(delta)
	handle_mouse_drag(delta)
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

	position += direction.normalized() * move_speed * delta

func handle_mouse_drag(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		is_dragging = true
		last_mouse_position = get_global_mouse_position()
	elif Input.is_action_just_released("click"):
		is_dragging = false

	if is_dragging:
		var mouse_position = get_global_mouse_position()
		var mouse_delta = last_mouse_position - mouse_position
		
		if mouse_delta != Vector2.ZERO:
			position += mouse_delta * drag_sensitivity * delta
			last_mouse_position = mouse_position

func _ready() -> void:
	pass
