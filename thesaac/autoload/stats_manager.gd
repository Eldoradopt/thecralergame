extends Node

var base_stats: Dictionary = {}
var stat_modifiers: Dictionary = {}
var calculated_stats: Dictionary = {}

signal stat_changed(stat_name: String, new_value: float)

func _ready() -> void:
	print("StatsManager initialized")
	load_stat_definitions()

func load_stat_definitions() -> void:
	var definitions = DataManager.stats_data
	if definitions.is_empty():
		print("Using default stat definitions")
		base_stats = {
			"health": 6.0,
			"damage": 1.0,
			"fire_rate": 1.0,
			"speed": 1.0,
			"luck": 1.0
		}
	else:
		for stat_name in definitions.keys():
			var stat_def = definitions[stat_name]
			if stat_def is Dictionary:
				base_stats[stat_name] = stat_def.get("default", 1.0)
			else:
				base_stats[stat_name] = 1.0
	
	recalculate_stats()

func set_base_stat(stat_name: String, value: float) -> void:
	base_stats[stat_name] = value
	recalculate_stats()

func get_base_stat(stat_name: String) -> float:
	return base_stats.get(stat_name, 0.0)

func add_stat_modifier(stat_name: String, modifier: float, item_id: String) -> void:
	if not stat_modifiers.has(stat_name):
		stat_modifiers[stat_name] = {}
	stat_modifiers[stat_name][item_id] = modifier
	recalculate_stats()

func remove_stat_modifier(stat_name: String, item_id: String) -> void:
	if stat_modifiers.has(stat_name):
		stat_modifiers[stat_name].erase(item_id)
		if stat_modifiers[stat_name].is_empty():
			stat_modifiers.erase(stat_name)
	recalculate_stats()

func clear_all_modifiers() -> void:
	stat_modifiers.clear()
	recalculate_stats()

func recalculate_stats() -> void:
	for stat_name in base_stats:
		var base_value = base_stats[stat_name]
		var total_modifier = 0.0
		
		if stat_modifiers.has(stat_name):
			for item_id in stat_modifiers[stat_name]:
				total_modifier += stat_modifiers[stat_name][item_id]
		
		calculated_stats[stat_name] = base_value + total_modifier
		stat_changed.emit(stat_name, calculated_stats[stat_name])

func get_stat(stat_name: String) -> float:
	return calculated_stats.get(stat_name, 0.0)

func get_all_stats() -> Dictionary:
	return calculated_stats.duplicate()

func reset_to_character(character_id: String) -> void:
	var char_data = DataManager.get_character_data(character_id)
	if not char_data.is_empty():
		var char_stats = char_data.get("stats", {})
		for stat_name in char_stats:
			base_stats[stat_name] = char_stats[stat_name]
	
	clear_all_modifiers()
	recalculate_stats()

func apply_item_stats(item_id: String) -> void:
	var item_data = DataManager.get_item_data(item_id)
	if item_data.is_empty():
		return
	
	var item_stats = item_data.get("stats", {})
	for stat_name in item_stats:
		add_stat_modifier(stat_name, item_stats[stat_name], item_id)

func remove_item_stats(item_id: String) -> void:
	var item_data = DataManager.get_item_data(item_id)
	if item_data.is_empty():
		return
	
	var item_stats = item_data.get("stats", {})
	for stat_name in item_stats:
		remove_stat_modifier(stat_name, item_id)

func format_stat_value(stat_name: String, value: float) -> String:
	match stat_name:
		"health":
			return str(int(value))
		"damage":
			return str(snapped(value, 0.1))
		"fire_rate":
			return str(snapped(value, 0.1))
		"speed":
			return str(snapped(value, 0.1))
		"luck":
			return str(snapped(value, 0.1))
		_:
			return str(value)

func get_health_hearts() -> int:
	return int(get_stat("health"))
