extends Node2D

@onready var camera = $Camera2D
var player_scene = preload("res://scenes/core/player.tscn")
var current_player: Node = null

func _ready() -> void:
	GameManager.game_started.connect(_on_game_started)
	
	call_deferred("setup_test_pickup")
	spawn_player()

func _process(_delta: float) -> void:
	if current_player and camera:
		camera.position = current_player.position

func setup_test_pickup() -> void:
	var test_pickup = $TestItemPickup
	if test_pickup and test_pickup.has_method("setup"):
		test_pickup.setup(DataManager.get_item_data("damage_up"))
	
	var test_key = $TestKeyPickup
	if test_key and test_key.has_method("setup"):
		test_key.setup(DataManager.get_pickup_data("key"))

func spawn_player() -> void:
	if current_player:
		current_player.queue_free()
	
	current_player = player_scene.instantiate()
	current_player.position = Vector2(400, 300)
	add_child(current_player)
	
	if current_player.has_method("setup_character"):
		current_player.setup_character("default_character")

func _on_game_started() -> void:
	print("Game started in MainGame")
	if not current_player:
		spawn_player()
