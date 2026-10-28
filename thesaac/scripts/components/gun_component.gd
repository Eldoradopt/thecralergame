extends Node

signal projectile_fired(projectile: Node)

var base_damage: float = 1.0
var base_fire_rate: float = 1.0
var projectile_speed: float = 400.0
var projectile_count: int = 1
var spread: float = 0.0
var pierce: int = 0
var bounce: int = 0

var shooting_modifiers: Dictionary = {}
var can_shoot: bool = true
var fire_timer: float = 0.0

@onready var owner_node = get_parent()

func _ready() -> void:
	print("GunComponent initialized")

func _process(delta: float) -> void:
	if not can_shoot:
		fire_timer -= delta
		if fire_timer <= 0.0:
			can_shoot = true

func shoot(direction: Vector2) -> void:
	if not can_shoot:
		return
	
	var effective_fire_rate = base_fire_rate
	for modifier in shooting_modifiers.values():
		effective_fire_rate *= modifier.get("fire_rate", 1.0)
	
	var fire_delay = 1.0 / effective_fire_rate
	can_shoot = false
	fire_timer = fire_delay
	
	var effective_damage = base_damage
	for modifier in shooting_modifiers.values():
		effective_damage *= modifier.get("damage", 1.0)
	
	var effective_count = projectile_count
	for modifier in shooting_modifiers.values():
		effective_count += modifier.get("projectile_count", 0)
	
	var effective_spread = spread
	for modifier in shooting_modifiers.values():
		effective_spread += modifier.get("spread", 0.0)
	
	for i in effective_count:
		var angle_offset = 0.0
		if effective_count > 1:
			angle_offset = (i - (effective_count - 1) / 2.0) * deg_to_rad(effective_spread)
		
		var shoot_direction = direction.rotated(angle_offset)
		spawn_projectile(shoot_direction, effective_damage)

func spawn_projectile(direction: Vector2, damage: float) -> void:
	var projectile_scene = load("res://scenes/core/projectile.tscn")
	if projectile_scene == null:
		push_error("Failed to load projectile scene")
		return
	
	var projectile = projectile_scene.instantiate()
	
	if owner_node:
		projectile.global_position = owner_node.global_position
	
	if projectile.has_method("setup"):
		projectile.setup(direction, projectile_speed, damage, pierce, bounce)
	
	get_tree().current_scene.add_child(projectile)
	projectile_fired.emit(projectile)

func apply_shooting_modifier(item_id: String, modifiers: Dictionary) -> void:
	shooting_modifiers[item_id] = modifiers
	
	if modifiers.has("projectile_count"):
		projectile_count += modifiers.projectile_count
	if modifiers.has("spread"):
		spread += modifiers.spread
	if modifiers.has("pierce"):
		pierce += modifiers.pierce
	if modifiers.has("bounce"):
		bounce += modifiers.bounce

func remove_shooting_modifier(item_id: String) -> void:
	if shooting_modifiers.has(item_id):
		var modifiers = shooting_modifiers[item_id]
		
		if modifiers.has("projectile_count"):
			projectile_count -= modifiers.projectile_count
		if modifiers.has("spread"):
			spread -= modifiers.spread
		if modifiers.has("pierce"):
			pierce -= modifiers.pierce
		if modifiers.has("bounce"):
			bounce -= modifiers.bounce
		
		shooting_modifiers.erase(item_id)

func set_base_damage(value: float) -> void:
	base_damage = value

func set_base_fire_rate(value: float) -> void:
	base_fire_rate = value
