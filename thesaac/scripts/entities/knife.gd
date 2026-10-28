extends RigidBody2D

var damage: float = 1.0
var lifetime: float = 5.0
var has_owner: bool = false

@onready var color_rect = $ColorRect

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("knife")

func setup(dmg: float) -> void:
	damage = dmg
	if color_rect:
		color_rect.color = Color(0.8, 0.8, 0.8, 1)

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func throw(direction: Vector2, force: float) -> void:
	apply_central_impulse(direction * force)
	has_owner = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
