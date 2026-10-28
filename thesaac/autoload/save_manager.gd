extends Node

var save_path: String = "user://savegame.json"
var current_save_data: Dictionary = {}

signal game_saved
signal game_loaded
signal save_error(message: String)

func _ready() -> void:
	print("SaveManager initialized")

func save_game() -> void:
	current_save_data = {
		"character_id": GameManager.current_floor,
		"current_floor": GameManager.current_floor,
		"current_room_id": GameManager.current_room_id,
		"collected_items": ItemManager.get_collected_items(),
		"stats": StatsManager.get_all_stats(),
		"visited_rooms": RoomManager.visited_rooms,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file for writing")
		save_error.emit("Failed to open save file")
		return
	
	var json_string = JSON.stringify(current_save_data)
	file.store_string(json_string)
	file.close()
	
	print("Game saved to: ", save_path)
	game_saved.emit()

func load_game() -> void:
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		push_error("No save file found")
		save_error.emit("No save file found")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("Failed to parse save file")
		save_error.emit("Failed to parse save file")
		return
	
	current_save_data = json.data
	
	apply_save_data()
	
	print("Game loaded from: ", save_path)
	game_loaded.emit()

func apply_save_data() -> void:
	GameManager.current_floor = current_save_data.get("current_floor", 1)
	GameManager.current_room_id = current_save_data.get("current_room_id", "")
	
	var character_id = current_save_data.get("character_id", "")
	if not character_id.is_empty():
		StatsManager.reset_to_character(character_id)
	
	var collected_items = current_save_data.get("collected_items", [])
	for item_id in collected_items:
		ItemManager.collect_item(item_id)
	
	var visited_rooms = current_save_data.get("visited_rooms", [])
	RoomManager.visited_rooms = visited_rooms

func delete_save() -> void:
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("Save file deleted")
		current_save_data.clear()

func has_save() -> bool:
	return FileAccess.file_exists(save_path)

func get_save_data() -> Dictionary:
	return current_save_data.duplicate()

func create_save_slot(slot_number: int) -> void:
	var slot_path = "user://save_slot_" + str(slot_number) + ".json"
	current_save_data = {
		"character_id": GameManager.current_floor,
		"current_floor": GameManager.current_floor,
		"current_room_id": GameManager.current_room_id,
		"collected_items": ItemManager.get_collected_items(),
		"stats": StatsManager.get_all_stats(),
		"visited_rooms": RoomManager.visited_rooms,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	var file = FileAccess.open(slot_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save slot for writing")
		return
	
	var json_string = JSON.stringify(current_save_data)
	file.store_string(json_string)
	file.close()
	
	print("Saved to slot: ", slot_number)

func load_save_slot(slot_number: int) -> void:
	var slot_path = "user://save_slot_" + str(slot_number) + ".json"
	var file = FileAccess.open(slot_path, FileAccess.READ)
	if file == null:
		push_error("Save slot not found")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("Failed to parse save slot")
		return
	
	current_save_data = json.data
	apply_save_data()
	
	print("Loaded from slot: ", slot_number)
	game_loaded.emit()
