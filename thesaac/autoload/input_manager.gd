extends Node

enum InputMethod { KEYBOARD_MOUSE, GAMEPAD, TOUCH }

var current_input_method: InputMethod = InputMethod.KEYBOARD_MOUSE
var movement_vector: Vector2 = Vector2.ZERO
var aim_vector: Vector2 = Vector2.ZERO
var is_shooting: bool = false
var touch_joystick_active: bool = false

signal input_method_changed(method: InputMethod)
signal shoot_pressed
signal shoot_released

func _ready() -> void:
	print("InputManager initialized")

func _process(_delta: float) -> void:
	detect_input_method()
	update_movement()
	update_aiming()
	update_shooting()

func detect_input_method() -> void:
	var previous_method = current_input_method
	
	if Input.get_connected_joypads().size() > 0:
		if Input.is_joy_known(0):
			if Input.get_joy_axis(0, JOY_AXIS_LEFT_X) != 0 or Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) != 0:
				current_input_method = InputMethod.GAMEPAD
		else:
			current_input_method = InputMethod.KEYBOARD_MOUSE
	else:
		if touch_joystick_active:
			current_input_method = InputMethod.TOUCH
		else:
			current_input_method = InputMethod.KEYBOARD_MOUSE
	
	if current_input_method != previous_method:
		input_method_changed.emit(current_input_method)

func update_movement() -> void:
	movement_vector = Vector2.ZERO
	
	match current_input_method:
		InputMethod.KEYBOARD_MOUSE:
			if Input.is_action_pressed("move_up"):
				movement_vector.y -= 1
			if Input.is_action_pressed("move_down"):
				movement_vector.y += 1
			if Input.is_action_pressed("move_left"):
				movement_vector.x -= 1
			if Input.is_action_pressed("move_right"):
				movement_vector.x += 1
		
		InputMethod.GAMEPAD:
			var left_stick = Vector2(
				Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
			)
			if left_stick.length() > 0.1:
				movement_vector = left_stick
		
		InputMethod.TOUCH:
			pass
	
	if movement_vector.length() > 1.0:
		movement_vector = movement_vector.normalized()

func update_aiming() -> void:
	aim_vector = Vector2.ZERO
	
	match current_input_method:
		InputMethod.KEYBOARD_MOUSE:
			var mouse_pos = Vector2(get_viewport().get_mouse_position())
			var camera = get_viewport().get_camera_2d()
			if camera:
				var viewport_center = Vector2(get_viewport().size) / 2
				aim_vector = (mouse_pos - viewport_center).normalized()
		
		InputMethod.GAMEPAD:
			var right_stick = Vector2(
				Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
				Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
			)
			if right_stick.length() > 0.1:
				aim_vector = right_stick.normalized()
		
		InputMethod.TOUCH:
			pass

func update_shooting() -> void:
	var was_shooting = is_shooting
	
	match current_input_method:
		InputMethod.KEYBOARD_MOUSE:
			is_shooting = Input.is_action_pressed("shoot")
		
		InputMethod.GAMEPAD:
			is_shooting = Input.is_action_pressed("shoot")
		
		InputMethod.TOUCH:
			pass
	
	if is_shooting and not was_shooting:
		shoot_pressed.emit()
	elif not is_shooting and was_shooting:
		shoot_released.emit()

func set_touch_joystick_active(active: bool) -> void:
	touch_joystick_active = active

func set_touch_aim_vector(vector: Vector2) -> void:
	aim_vector = vector.normalized()

func set_touch_movement_vector(vector: Vector2) -> void:
	movement_vector = vector.normalized()

func get_movement_vector() -> Vector2:
	return movement_vector

func get_aim_vector() -> Vector2:
	return aim_vector

func get_aim_angle() -> float:
	return aim_vector.angle()

func is_action_just_pressed(action: String) -> bool:
	return Input.is_action_just_pressed(action)

func is_action_pressed(action: String) -> bool:
	return Input.is_action_pressed(action)
