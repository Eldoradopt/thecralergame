extends Control

@onready var keys_label = $HBoxContainer/KeysLabel
@onready var bombs_label = $HBoxContainer/BombsLabel
@onready var coins_label = $HBoxContainer/CoinsLabel

func _ready() -> void:
	PickupManager.keys_changed.connect(_on_keys_changed)
	PickupManager.bombs_changed.connect(_on_bombs_changed)
	PickupManager.coins_changed.connect(_on_coins_changed)
	update_display()

func _on_keys_changed(new_count: int) -> void:
	if keys_label:
		keys_label.text = "Keys: " + str(new_count)

func _on_bombs_changed(new_count: int) -> void:
	if bombs_label:
		bombs_label.text = "Bombs: " + str(new_count)

func _on_coins_changed(new_count: int) -> void:
	if coins_label:
		coins_label.text = "Coins: " + str(new_count)

func update_display() -> void:
	if keys_label:
		keys_label.text = "Keys: " + str(PickupManager.get_keys())
	if bombs_label:
		bombs_label.text = "Bombs: " + str(PickupManager.get_bombs())
	if coins_label:
		coins_label.text = "Coins: " + str(PickupManager.get_coins())
