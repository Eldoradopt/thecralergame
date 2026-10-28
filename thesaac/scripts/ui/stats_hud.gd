extends Control

@onready var damage_label = $VBoxContainer/DamageLabel
@onready var fire_rate_label = $VBoxContainer/FireRateLabel
@onready var speed_label = $VBoxContainer/SpeedLabel
@onready var luck_label = $VBoxContainer/LuckLabel

func _ready() -> void:
	StatsManager.stat_changed.connect(_on_stat_changed)
	update_all_stats()

func _on_stat_changed(stat_name: String, new_value: float) -> void:
	update_stat(stat_name, new_value)

func update_all_stats() -> void:
	var stats = StatsManager.get_all_stats()
	for stat_name in stats:
		update_stat(stat_name, stats[stat_name])

func update_stat(stat_name: String, value: float) -> void:
	var formatted_value = StatsManager.format_stat_value(stat_name, value)
	
	match stat_name:
		"damage":
			if damage_label:
				damage_label.text = "Damage: " + formatted_value
		"fire_rate":
			if fire_rate_label:
				fire_rate_label.text = "Fire Rate: " + formatted_value
		"speed":
			if speed_label:
				speed_label.text = "Speed: " + formatted_value
		"luck":
			if luck_label:
				luck_label.text = "Luck: " + formatted_value
