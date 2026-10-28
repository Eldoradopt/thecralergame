extends Node

var current_floor_config: Dictionary = {}
var current_room: Node2D = null
var visited_rooms: Array = []
var room_history: Array = []

signal room_loaded(room: Node2D)
signal floor_completed

func _ready() -> void:
	print("RoomManager initialized")

func load_floor(floor_number: int) -> void:
	var floor_id = "floor_" + str(floor_number)
	current_floor_config = DataManager.get_floor_data(floor_id)
	
	if current_floor_config.is_empty():
		print("No floor config found for floor ", floor_number, ", using defaults")
		current_floor_config = {
			"id": floor_id,
			"floor_number": floor_number,
			"room_count": 10,
			"difficulty": 1.0 + (floor_number * 0.1)
		}
	
	print("Loaded floor: ", floor_number, " with config: ", current_floor_config)
	GameManager.change_floor(floor_number)

func generate_room(room_type: String = "normal") -> Node2D:
	var room_id = "room_" + str(randi())
	var room_scene = load("res://scenes/rooms/room_base.tscn")
	
	if room_scene == null:
		push_error("Failed to load room_base.tscn")
		return null
	
	var room = room_scene.instantiate()
	room.name = room_id
	
	var room_data = get_room_template(room_type)
	if not room_data.is_empty():
		apply_room_template(room, room_data)
	
	current_room = room
	visited_rooms.append(room_id)
	room_history.append(room_id)
	
	print("Generated room: ", room_id, " of type: ", room_type)
	room_loaded.emit(room)
	
	return room

func get_room_template(room_type: String) -> Dictionary:
	var matching_rooms = []
	
	for room_id in DataManager.rooms_data:
		var room_data = DataManager.rooms_data[room_id]
		if room_data.get("type", "normal") == room_type:
			matching_rooms.append(room_data)
	
	if matching_rooms.is_empty():
		return {}
	
	return matching_rooms[randi() % matching_rooms.size()]

func apply_room_template(room: Node2D, room_data: Dictionary) -> void:
	var layout = room_data.get("layout", {})
	var enemy_spawns = room_data.get("enemy_spawns", [])
	var item_spawns = room_data.get("item_spawns", [])
	
	print("Applying room template with ", enemy_spawns.size(), " enemies and ", item_spawns.size(), " items")

func transition_to_next_room() -> void:
	if current_room:
		current_room.queue_free()
	
	var next_room_type = determine_next_room_type()
	var new_room = generate_room(next_room_type)
	
	if new_room:
		new_room.add_to_group("room")
		get_tree().current_scene.add_child(new_room)
		
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.position = Vector2(400, 300)
		
		GameManager.change_room(new_room.name)

func determine_next_room_type() -> String:
	var floor_config = current_floor_config
	var room_count = floor_config.get("room_count", 10)
	var visited_count = visited_rooms.size()
	
	if visited_count >= room_count:
		return "boss"
	
	var rand = randf()
	if rand < 0.1:
		return "treasure"
	elif rand < 0.15:
		return "shop"
	elif rand < 0.2:
		return "secret"
	else:
		return "normal"

func is_floor_complete() -> void:
	var floor_config = current_floor_config
	var room_count = floor_config.get("room_count", 10)
	
	if visited_rooms.size() >= room_count:
		floor_completed.emit()

func get_current_room() -> Node2D:
	return current_room

func get_visited_count() -> int:
	return visited_rooms.size()

func reset_floor() -> void:
	visited_rooms.clear()
	room_history.clear()
	if current_room:
		current_room.queue_free()
		current_room = null
