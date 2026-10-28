extends Node

var collected_items: Array = []
var active_items: Dictionary = {}
var inventory_size: int = 999

signal item_collected(item_id: String)
signal item_removed(item_id: String)

func _ready() -> void:
	print("ItemManager initialized")

func collect_item(item_id: String) -> void:
	if item_id in collected_items:
		print("Item already collected: ", item_id)
		return
	
	var item_data = DataManager.get_item_data(item_id)
	if item_data.is_empty():
		push_error("Invalid item ID: ", item_id)
		return
	
	collected_items.append(item_id)
	
	var item_type = item_data.get("type", "passive")
	match item_type:
		"passive":
			apply_passive_item(item_id)
		"active":
			active_items[item_id] = item_data
	
	StatsManager.apply_item_stats(item_id)
	item_collected.emit(item_id)
	
	print("Collected item: ", item_id, " - ", item_data.get("name", "Unknown"))

func apply_passive_item(item_id: String) -> void:
	var item_data = DataManager.get_item_data(item_id)
	if item_data.is_empty():
		return
	
	var shooting_modifiers = item_data.get("shooting_modifiers", {})
	if not shooting_modifiers.is_empty():
		apply_shooting_modifiers(item_id, shooting_modifiers)

func apply_shooting_modifiers(item_id: String, modifiers: Dictionary) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("apply_shooting_modifier"):
		player.apply_shooting_modifier(item_id, modifiers)

func remove_item(item_id: String) -> void:
	if item_id not in collected_items:
		return
	
	var item_data = DataManager.get_item_data(item_id)
	var item_type = item_data.get("type", "passive")
	
	match item_type:
		"passive":
			StatsManager.remove_item_stats(item_id)
		"active":
			active_items.erase(item_id)
	
	collected_items.erase(item_id)
	item_removed.emit(item_id)
	
	print("Removed item: ", item_id)

func use_active_item(item_id: String) -> void:
	if item_id not in active_items:
		return
	
	var item_data = DataManager.get_item_data(item_id)
	var script_path = item_data.get("script", "")
	
	if not script_path.is_empty():
		var script = load(script_path)
		if script:
			var item_instance = script.new()
			if item_instance.has_method("use"):
				item_instance.use()
	
	print("Used active item: ", item_id)

func get_collected_items() -> Array:
	return collected_items.duplicate()

func get_active_items() -> Dictionary:
	return active_items.duplicate()

func has_item(item_id: String) -> bool:
	return item_id in collected_items

func clear_inventory() -> void:
	for item_id in collected_items.duplicate():
		remove_item(item_id)
	
	collected_items.clear()
	active_items.clear()

func get_item_description(item_id: String) -> Dictionary:
	var item_data = DataManager.get_item_data(item_id)
	if item_data.is_empty():
		return {}
	
	return {
		"id": item_data.get("id", ""),
		"name": item_data.get("name", "Unknown"),
		"description": item_data.get("description", ""),
		"type": item_data.get("type", "passive"),
		"stats": item_data.get("stats", {}),
		"shooting_modifiers": item_data.get("shooting_modifiers", {})
	}
