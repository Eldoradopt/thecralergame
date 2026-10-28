extends Area2D

var relic_id: String = ""

@onready var sprite = $ColorRect

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("relic_pickup")

func setup(pickup_relic_id: String) -> void:
	relic_id = pickup_relic_id
	
	var relic_data = DataManager.get_relic_data(relic_id)
	if not relic_data.is_empty():
		var rarity = relic_data.get("rarity", "common")
		match rarity:
			"common":
				if sprite:
					sprite.color = Color(0.5, 0.5, 0.5, 1)
			"uncommon":
				if sprite:
					sprite.color = Color(0.3, 1.0, 0.3, 1)
			"rare":
				if sprite:
					sprite.color = Color(0.3, 0.3, 1.0, 1)
			"legendary":
				if sprite:
					sprite.color = Color(1.0, 0.8, 0.0, 1)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		RelicManager.collect_relic(relic_id)
		
		var popup = get_tree().get_first_node_in_group("item_description_popup")
		if popup and popup.has_method("show_item_description"):
			popup.show_item_description(relic_id)
		
		queue_free()
