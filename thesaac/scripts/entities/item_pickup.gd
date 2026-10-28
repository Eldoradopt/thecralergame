extends Area2D

var item_id: String = ""

@onready var sprite = $Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("item_pickup")

func setup(pickup_item_id: String) -> void:
	item_id = pickup_item_id
	
	var item_data = DataManager.get_item_data(item_id)
	if not item_data.is_empty():
		if sprite:
			sprite.modulate = Color(0.5, 0.5, 1.0, 1)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		ItemManager.collect_item(item_id)
		
		var popup = get_tree().get_first_node_in_group("item_description_popup")
		if popup and popup.has_method("show_item_description"):
			popup.show_item_description(item_id)
		
		queue_free()
