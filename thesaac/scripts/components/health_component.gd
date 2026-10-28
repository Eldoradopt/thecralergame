extends Node

signal health_changed(current_health: float, max_health: float)
signal health_depleted
signal damage_taken(amount: float)
signal healed(amount: float)

var max_health: float = 6.0
var current_health: float = 6.0
var is_invulnerable: bool = false
var invulnerability_timer: float = 0.0
var invulnerability_duration: float = 0.5

@onready var owner_node = get_parent()

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

func _process(delta: float) -> void:
	if is_invulnerable:
		invulnerability_timer -= delta
		if invulnerability_timer <= 0.0:
			is_invulnerable = false

func take_damage(amount: float) -> void:
	if is_invulnerable or amount <= 0:
		return
	
	current_health -= amount
	damage_taken.emit(amount)
	
	if current_health <= 0:
		current_health = 0
		health_depleted.emit()
	else:
		set_invulnerable()
	
	health_changed.emit(current_health, max_health)

func heal(amount: float) -> void:
	if amount <= 0:
		return
	
	current_health = min(current_health + amount, max_health)
	healed.emit(amount)
	health_changed.emit(current_health, max_health)

func set_max_health(value: float) -> void:
	max_health = value
	if current_health > max_health:
		current_health = max_health
	health_changed.emit(current_health, max_health)

func set_invulnerable(duration: float = invulnerability_duration) -> void:
	is_invulnerable = true
	invulnerability_duration = duration
	invulnerability_timer = duration

func get_health_percentage() -> float:
	if max_health <= 0:
		return 0.0
	return current_health / max_health

func is_dead() -> bool:
	return current_health <= 0
