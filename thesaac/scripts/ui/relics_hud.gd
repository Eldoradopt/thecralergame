extends Control

@onready var relic_container = $HBoxContainer

func _ready() -> void:
	RelicManager.relic_collected.connect(_on_relic_collected)
	RelicManager.relic_removed.connect(_on_relic_removed)
	update_relics_display()

func _on_relic_collected(relic_id: String) -> void:
	update_relics_display()

func _on_relic_removed(relic_id: String) -> void:
	update_relics_display()

func update_relics_display() -> void:
	if not relic_container:
		return
	
	for child in relic_container.get_children():
		child.queue_free()
	
	var collected_relics = RelicManager.get_collected_relics()
	for relic_id in collected_relics:
		var relic_data = DataManager.get_relic_data(relic_id)
		if relic_data.is_empty():
			continue
		
		var relic_slot = ColorRect.new()
		relic_slot.custom_minimum_size = Vector2(40, 40)
		
		var rarity = relic_data.get("rarity", "common")
		match rarity:
			"common":
				relic_slot.color = Color(0.5, 0.5, 0.5, 1)
			"uncommon":
				relic_slot.color = Color(0.3, 1.0, 0.3, 1)
			"rare":
				relic_slot.color = Color(0.3, 0.3, 1.0, 1)
			"legendary":
				relic_slot.color = Color(1.0, 0.8, 0.0, 1)
		
		relic_container.add_child(relic_slot)
