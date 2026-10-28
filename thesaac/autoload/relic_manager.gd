extends Node

var collected_relics: Array = []
var relic_slots: int = 3

signal relic_collected(relic_id: String)
signal relic_removed(relic_id: String)

func _ready() -> void:
	print("RelicManager initialized")

func collect_relic(relic_id: String) -> void:
	if relic_id in collected_relics:
		print("Relic already collected: ", relic_id)
		return
	
	if collected_relics.size() >= relic_slots:
		print("No relic slots available")
		return
	
	var relic_data = DataManager.get_relic_data(relic_id)
	if relic_data.is_empty():
		push_error("Invalid relic ID: ", relic_id)
		return
	
	collected_relics.append(relic_id)
	
	apply_relic_effects(relic_id)
	relic_collected.emit(relic_id)
	
	print("Collected relic: ", relic_id, " - ", relic_data.get("name", "Unknown"))

func apply_relic_effects(relic_id: String) -> void:
	var relic_data = DataManager.get_relic_data(relic_id)
	if relic_data.is_empty():
		return
	
	var stat_modifiers = relic_data.get("stat_modifiers", {})
	for stat_name in stat_modifiers:
		StatsManager.add_stat_modifier(stat_name, stat_modifiers[stat_name], relic_id)
	
	var special_effects = relic_data.get("special_effects", {})
	for effect in special_effects:
		apply_special_effect(effect, relic_id)

func apply_special_effect(effect: Dictionary, relic_id: String) -> void:
	var effect_type = effect.get("type", "")
	match effect_type:
		"damage_reflection":
			print("Applied damage reflection from relic: ", relic_id)
		"health_regen":
			print("Applied health regen from relic: ", relic_id)
		"luck_boost":
			print("Applied luck boost from relic: ", relic_id)
		_:
			print("Unknown effect type: ", effect_type)

func remove_relic(relic_id: String) -> void:
	if relic_id not in collected_relics:
		return
	
	var relic_data = DataManager.get_relic_data(relic_id)
	
	var stat_modifiers = relic_data.get("stat_modifiers", {})
	for stat_name in stat_modifiers:
		StatsManager.remove_stat_modifier(stat_name, relic_id)
	
	collected_relics.erase(relic_id)
	relic_removed.emit(relic_id)
	
	print("Removed relic: ", relic_id)

func get_collected_relics() -> Array:
	return collected_relics.duplicate()

func has_relic(relic_id: String) -> bool:
	return relic_id in collected_relics

func clear_relics() -> void:
	for relic_id in collected_relics.duplicate():
		remove_relic(relic_id)
	
	collected_relics.clear()

func get_relic_description(relic_id: String) -> Dictionary:
	var relic_data = DataManager.get_relic_data(relic_id)
	if relic_data.is_empty():
		return {}
	
	return {
		"id": relic_data.get("id", ""),
		"name": relic_data.get("name", "Unknown"),
		"description": relic_data.get("description", ""),
		"stat_modifiers": relic_data.get("stat_modifiers", {}),
		"special_effects": relic_data.get("special_effects", [])
	}
