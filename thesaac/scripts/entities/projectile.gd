extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 400.0
var damage: float = 1.0
var pierce_count: int = 0
var bounce_count: int = 0
var pierced_enemies: Array = []

@onready var sprite = $Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("projectile")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	var screen_rect = get_viewport_rect()
	if not screen_rect.has_point(position):
		queue_free()

func setup(proj_direction: Vector2, proj_speed: float, proj_damage: float, proj_pierce: int, proj_bounce: int) -> void:
	direction = proj_direction.normalized()
	speed = proj_speed
	damage = proj_damage
	pierce_count = proj_pierce
	bounce_count = proj_bounce
	rotation = direction.angle()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		if body in pierced_enemies:
			return
		
		if body.has_method("take_damage"):
			body.take_damage(damage)
		
		pierced_enemies.append(body)
		
		if pierced_enemies.size() > pierce_count:
			queue_free()
		else:
			if bounce_count > 0:
				bounce()
			else:
				queue_free()
	else:
		queue_free()

func bounce() -> void:
	bounce_count -= 1
	direction = direction.reflect(Vector2.UP)
	rotation = direction.angle()
