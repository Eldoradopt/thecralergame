extends Control

@onready var item_name_label = $PanelContainer/VBoxContainer/ItemNameLabel
@onready var item_description_label = $PanelContainer/VBoxContainer/ItemDescriptionLabel
@onready var stats_label = $PanelContainer/VBoxContainer/StatsLabel
@onready var close_button = $PanelContainer/VBoxContainer/CloseButton

var current_item_id: String = ""

func _ready() -> void:
	hide()
	add_to_group("item_description_popup")
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func show_item_description(item_id: String) -> void:
	current_item_id = item_id
	var item_data = ItemManager.get_item_description(item_id)
	
	if item_name_label:
		item_name_label.text = item_data.get("name", "Unknown")
	
	if item_description_label:
		item_description_label.text = item_data.get("description", "")
	
	if stats_label:
		var stats_text = ""
		var stats = item_data.get("stats", {})
		for stat_name in stats:
			var value = stats[stat_name]
			stats_text += stat_name + ": " + str(value) + "\n"
		
		var shooting_mods = item_data.get("shooting_modifiers", {})
		for mod_name in shooting_mods:
			var value = shooting_mods[mod_name]
			stats_text += mod_name + ": " + str(value) + "\n"
		
		stats_label.text = stats_text
	
	show()

func _on_close_pressed() -> void:
	hide()
