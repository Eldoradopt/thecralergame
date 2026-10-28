extends CharacterBody2D

signal enemy_died

@onready var health_component = $HealthComponent

var enemy_id: String = "basic_enemy"
var base_damage: float = 1.0
var detection_range: float = 300.0
var attack_range: float = 50.0
var move_speed: float = 100.0

func _ready() -> void:
	add_to_group("enemy")
	
	if health_component:
		health_component.health_depleted.connect(_on_health_depleted)
	
	print("Enemy initialized: ", enemy_id)

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player < detection_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * move_speed
		move_and_slide()
		
		if distance_to_player < attack_range:
			attack_player(player)

func attack_player(player: Node) -> void:
	if player.has_method("take_damage"):
		player.take_damage(base_damage)

func take_damage(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)

func _on_health_depleted() -> void:
	print("Enemy died: ", enemy_id)
	enemy_died.emit()
	queue_free()

func setup(enemy_data: Dictionary) -> void:
	enemy_id = enemy_data.get("id", "basic_enemy")
	base_damage = enemy_data.get("damage", 1.0)
	move_speed = enemy_data.get("speed", 100.0)
	
	if health_component:
		health_component.set_max_health(enemy_data.get("health", 3.0))
