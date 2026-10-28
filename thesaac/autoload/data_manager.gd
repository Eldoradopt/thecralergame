extends Node

var characters_data: Dictionary = {}
var items_data: Dictionary = {}
var stats_data: Dictionary = {}
var rooms_data: Dictionary = {}
var floors_data: Dictionary = {}
var enemies_data: Dictionary = {}
var relics_data: Dictionary = {}
var pickups_data: Dictionary = {}
var mods_data: Dictionary = {}

signal data_loaded
signal data_error(message: String)

func _ready() -> void:
	load_all_data()

func load_all_data() -> void:
	print("Loading game data...")
	load_characters()
	load_items()
	load_stats()
	load_rooms()
	load_floors()
	load_enemies()
	load_relics()
	load_pickups()
	load_mods()
	data_loaded.emit()
	print("All data loaded successfully")

func load_json_file(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + path)
		data_error.emit("Failed to open file: " + path)
		return {}
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_text)
	if error != OK:
		push_error("Failed to parse JSON in file: " + path)
		data_error.emit("Failed to parse JSON in file: " + path)
		return {}
	
	return json.data

func load_characters() -> void:
	var dir = DirAccess.open("res://data/characters/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json") and not file_name.begins_with("_"):
				var path = "res://data/characters/" + file_name
				var data = load_json_file(path)
				if not data.is_empty():
					var char_id = data.get("id", file_name.get_basename())
					characters_data[char_id] = data
			file_name = dir.get_next()
		dir.list_dir_end()
	print("Loaded ", characters_data.size(), " characters")

func load_items() -> void:
	var dir = DirAccess.open("res://data/items/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json") and not file_name.begins_with("_"):
				var path = "res://data/items/" + file_name
				var data = load_json_file(path)
				if not data.is_empty():
					var item_id = data.get("id", file_name.get_basename())
					items_data[item_id] = data
			file_name = dir.get_next()
		dir.list_dir_end()
	print("Loaded ", items_data.size(), " items")

func load_stats() -> void:
	var path = "res://data/stats/stat_definitions.json"
	if FileAccess.file_exists(path):
		stats_data = load_json_file(path)
		print("Loaded stats definitions")
	else:
		print("No stats definitions found, using defaults")

func load_rooms() -> void:
	var dir = DirAccess.open("res://data/rooms/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json") and not file_name.begins_with("_"):
				var path = "res://data/rooms/" + file_name
				var data = load_json_file(path)
				if not data.is_empty():
					var room_id = data.get("id", file_name.get_basename())
					rooms_data[room_id] = data
			file_name = dir.get_next()
		dir.list_dir_end()
	print("Loaded ", rooms_data.size(), " room templates")

func load_floors() -> void:
	var dir = DirAccess.open("res://data/floors/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json") and not file_name.begins_with("_"):
				var path = "res://data/floors/" + file_name
				var data = load_json_file(path)
				if not data.is_empty():
					var floor_id = data.get("id", file_name.get_basename())
					floors_data[floor_id] = data
			file_name = dir.get_next()
		dir.list_dir_end()
	print("Loaded ", floors_data.size(), " floor configurations")

func load_enemies() -> void:
	var dir = DirAccess.open("res://data/enemies/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json") and not file_name.begins_with("_"):
				var path = "res://data/enemies/" + file_name
				var data = load_json_file(path)
				if not data.is_empty():
					var enemy_id = data.get("id", file_name.get_basename())
					enemies_data[enemy_id] = data
			file_name = dir.get_next()
		dir.list_dir_end()
	print("Loaded ", enemies_data.size(), " enemy definitions")

func load_relics() -> void:
	var dir = DirAccess.open("res://data/relics/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json") and not file_name.begins_with("_"):
				var path = "res://data/relics/" + file_name
				var data = load_json_file(path)
				if not data.is_empty():
					var relic_id = data.get("id", file_name.get_basename())
					relics_data[relic_id] = data
			file_name = dir.get_next()
		dir.list_dir_end()
	print("Loaded ", relics_data.size(), " relic definitions")

func load_pickups() -> void:
	var dir = DirAccess.open("res://data/pickups/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				var path = "res://data/pickups/" + file_name
				var data = load_json_file(path)
				if not data.is_empty():
					var pickup_id = data.get("id", file_name.get_basename())
					pickups_data[pickup_id] = data
			file_name = dir.get_next()
		dir.list_dir_end()
	print("Loaded ", pickups_data.size(), " pickup definitions")

func load_mods() -> void:
	var mods_dir = "res://mods/"
	if DirAccess.dir_exists_absolute(mods_dir):
		var dir = DirAccess.open(mods_dir)
		if dir:
			dir.list_dir_begin()
			var mod_name = dir.get_next()
			while mod_name != "":
				if dir.current_is_dir():
					load_mod_data(mods_dir + mod_name + "/")
				mod_name = dir.get_next()
			dir.list_dir_end()
	print("Loaded mods from mods directory")

func load_mod_data(mod_path: String) -> void:
	var subdirs = ["characters", "items", "rooms", "enemies", "relics"]
	for subdir in subdirs:
		var dir = DirAccess.open(mod_path + subdir + "/")
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.ends_with(".json"):
					var data = load_json_file(mod_path + subdir + "/" + file_name)
					if not data.is_empty():
						match subdir:
							"characters":
								characters_data[data.get("id", file_name.get_basename())] = data
							"items":
								items_data[data.get("id", file_name.get_basename())] = data
							"rooms":
								rooms_data[data.get("id", file_name.get_basename())] = data
							"enemies":
								enemies_data[data.get("id", file_name.get_basename())] = data
							"relics":
								relics_data[data.get("id", file_name.get_basename())] = data
				file_name = dir.get_next()
			dir.list_dir_end()

func get_character_data(character_id: String) -> Dictionary:
	return characters_data.get(character_id, {})

func get_item_data(item_id: String) -> Dictionary:
	return items_data.get(item_id, {})

func get_room_data(room_id: String) -> Dictionary:
	return rooms_data.get(room_id, {})

func get_floor_data(floor_id: String) -> Dictionary:
	return floors_data.get(floor_id, {})

func get_enemy_data(enemy_id: String) -> Dictionary:
	return enemies_data.get(enemy_id, {})

func get_relic_data(relic_id: String) -> Dictionary:
	return relics_data.get(relic_id, {})

func get_pickup_data(pickup_id: String) -> Dictionary:
	return pickups_data.get(pickup_id, {})

func reload_data() -> void:
	characters_data.clear()
	items_data.clear()
	rooms_data.clear()
	floors_data.clear()
	mods_data.clear()
	load_all_data()
