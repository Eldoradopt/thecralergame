extends Area2D

var pickup_id: String = ""
var pickup_type: String = ""

@onready var color_rect = $ColorRect

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("pickup")

func setup(pickup_data: Dictionary) -> void:
	pickup_id = pickup_data.get("id", "")
	pickup_type = pickup_id
	
	var color_str = pickup_data.get("color", "Color(1, 1, 1, 1)")
	if color_rect and color_str.begins_with("Color"):
		color_rect.color = Color(color_str)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		match pickup_type:
			"key":
				PickupManager.add_key()
			"bomb":
				PickupManager.add_bomb()
			"coin":
				PickupManager.add_coin()
			"heart_pickup":
				var heal_amount = DataManager.get_pickup_data(pickup_id).get("heal_amount", 2.0)
				if body.has_method("heal"):
					body.heal(heal_amount)
			"chest":
				if PickupManager.use_key():
					pass
		
		queue_free()
