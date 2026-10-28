extends Control

@onready var hearts_container = $HBoxContainer

func _ready() -> void:
	StatsManager.stat_changed.connect(_on_stat_changed)
	update_hearts()

func _on_stat_changed(stat_name: String, _new_value: float) -> void:
	if stat_name == "health":
		update_hearts()

func update_hearts() -> void:
	if not hearts_container:
		return
	
	for child in hearts_container.get_children():
		child.queue_free()
	
	var health = StatsManager.get_stat("health")
	var heart_count = int(ceil(health / 2.0))
	
	for i in range(heart_count):
		var heart = create_heart(i, health)
		hearts_container.add_child(heart)

func create_heart(index: int, current_health: float) -> ColorRect:
	var heart = ColorRect.new()
	heart.custom_minimum_size = Vector2(24, 24)
	
	var heart_value = (current_health - (index * 2))
	
	if heart_value >= 2.0:
		heart.color = Color(1.0, 0.0, 0.0, 1)
	elif heart_value >= 1.0:
		heart.color = Color(1.0, 0.0, 0.0, 1)
		heart.custom_minimum_size = Vector2(12, 24)
	elif heart_value > 0.0:
		heart.color = Color(0.8, 0.0, 0.0, 1)
		heart.custom_minimum_size = Vector2(12, 24)
	else:
		heart.color = Color(0.3, 0.0, 0.0, 1)
	
	return heart
