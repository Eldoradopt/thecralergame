extends Node

signal game_started
signal game_paused
signal game_resumed
signal game_over
signal floor_changed(floor_number: int)
signal room_changed(room_id: String)

var current_state: String = "menu"
var current_floor: int = 1
var current_room_id: String = ""
var is_paused: bool = false

func _ready() -> void:
	print("GameManager initialized")

func start_game(character_id: String) -> void:
	current_state = "playing"
	current_floor = 1
	is_paused = false
	print("Starting game with character: ", character_id)
	game_started.emit()

func pause_game() -> void:
	if current_state == "playing":
		is_paused = true
		get_tree().paused = true
		current_state = "paused"
		game_paused.emit()

func resume_game() -> void:
	if current_state == "paused":
		is_paused = false
		get_tree().paused = false
		current_state = "playing"
		game_resumed.emit()

func end_game() -> void:
	current_state = "game_over"
	get_tree().paused = false
	game_over.emit()

func change_floor(floor_number: int) -> void:
	current_floor = floor_number
	floor_changed.emit(floor_number)
	print("Changed to floor: ", floor_number)

func change_room(room_id: String) -> void:
	current_room_id = room_id
	room_changed.emit(room_id)
	print("Changed to room: ", room_id)

func restart_game() -> void:
	current_state = "menu"
	current_floor = 1
	current_room_id = ""
	is_paused = false
	get_tree().paused = false
	get_tree().reload_current_scene()
