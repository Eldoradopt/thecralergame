extends Node

var base_speed: float = 200.0
var speed_multiplier: float = 1.0
var acceleration: float = 1000.0
var friction: float = 1000.0

var velocity: Vector2 = Vector2.ZERO
var input_vector: Vector2 = Vector2.ZERO

@onready var owner_node = get_parent()

func _ready() -> void:
	print("MovementComponent initialized")

func _physics_process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * get_effective_speed(), acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if owner_node and owner_node.has_method("move_and_slide"):
		owner_node.velocity = velocity
		owner_node.move_and_slide()

func set_input_vector(vector: Vector2) -> void:
	input_vector = vector.normalized()

func get_effective_speed() -> float:
	return base_speed * speed_multiplier

func set_speed_multiplier(value: float) -> void:
	speed_multiplier = value

func set_base_speed(value: float) -> void:
	base_speed = value

func get_velocity() -> Vector2:
	return velocity

func stop() -> void:
	velocity = Vector2.ZERO
	input_vector = Vector2.ZERO
