extends CharacterBody2D

signal player_died

@onready var movement_component = $MovementComponent
@onready var health_component = $HealthComponent
@onready var gun_component = $GunComponent

var character_id: String = "default_character"
var has_knife: bool = false
var knife_scene = preload("res://scenes/core/knife.tscn")
var current_knife: Node = null

func _ready() -> void:
	add_to_group("player")
	
	if health_component:
		health_component.health_depleted.connect(_on_health_depleted)
	
	print("Player initialized with character: ", character_id)

func _physics_process(delta: float) -> void:
	if GameManager.current_state != "playing":
		return
	
	var movement_vector = InputManager.get_movement_vector()
	if movement_component:
		movement_component.set_input_vector(movement_vector)
	
	var aim_vector = InputManager.get_aim_vector()
	if aim_vector.length() > 0.1 and InputManager.is_action_pressed("shoot"):
		if gun_component:
			gun_component.shoot(aim_vector)
	
	if has_knife and InputManager.is_action_just_pressed("secondary_fire"):
		throw_knife(aim_vector)
	
	check_door_collision()

func throw_knife(direction: Vector2) -> void:
	if current_knife:
		current_knife.queue_free()
	
	current_knife = knife_scene.instantiate()
	var char_data = DataManager.get_character_data(character_id)
	var damage = char_data.get("stats", {}).get("damage", 1.0)
	
	current_knife.setup(damage * 2.0)
	current_knife.global_position = global_position
	current_knife.throw(direction, 500.0)
	get_tree().current_scene.add_child(current_knife)
	
	call_deferred("spawn_new_knife")

func spawn_new_knife() -> void:
	await get_tree().create_timer(2.0).timeout
	current_knife = null

func check_door_collision() -> void:
	var room = get_tree().get_first_node_in_group("room")
	if not room:
		return
	
	var doors = room.get_node("Doors")
	if not doors:
		return
	
	for door in doors.get_children():
		if door is Area2D:
			if overlaps_body(door):
				RoomManager.transition_to_next_room()
				break

func overlaps_body(area: Area2D) -> bool:
	var player_shape = $CollisionShape2D.shape
	var door_shape = area.get_child(0).shape
	
	var distance = global_position.distance_to(area.global_position)
	return distance < (player_shape.radius + door_shape.radius)

func setup_character(char_id: String) -> void:
	character_id = char_id
	
	var char_data = DataManager.get_character_data(char_id)
	if char_data.is_empty():
		print("No character data found for: ", char_id)
		return
	
	var stats = char_data.get("stats", {})
	
	if health_component:
		health_component.set_max_health(stats.get("health", 6.0))
	
	if gun_component:
		gun_component.set_base_damage(stats.get("damage", 1.0))
		gun_component.set_base_fire_rate(stats.get("fire_rate", 1.0))
	
	if movement_component:
		movement_component.set_speed_multiplier(stats.get("speed", 1.0))
	
	has_knife = char_data.get("has_knife", false)
	
	StatsManager.reset_to_character(char_id)
	
	var starting_items = char_data.get("starting_items", [])
	for item_id in starting_items:
		ItemManager.collect_item(item_id)

func apply_shooting_modifier(item_id: String, modifiers: Dictionary) -> void:
	if gun_component:
		gun_component.apply_shooting_modifier(item_id, modifiers)

func remove_shooting_modifier(item_id: String) -> void:
	if gun_component:
		gun_component.remove_shooting_modifier(item_id)

func _on_health_depleted() -> void:
	print("Player died")
	player_died.emit()
	GameManager.end_game()

func take_damage(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)

func heal(amount: float) -> void:
	if health_component:
		health_component.heal(amount)
