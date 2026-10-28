extends Node

var keys: int = 0
var bombs: int = 0
var coins: int = 0

signal keys_changed(new_count: int)
signal bombs_changed(new_count: int)
signal coins_changed(new_count: int)

func add_key() -> void:
	keys += 1
	keys_changed.emit(keys)

func add_bomb() -> void:
	bombs += 1
	bombs_changed.emit(bombs)

func add_coin(amount: int = 1) -> void:
	coins += amount
	coins_changed.emit(coins)

func use_key() -> bool:
	if keys > 0:
		keys -= 1
		keys_changed.emit(keys)
		return true
	return false

func use_bomb() -> bool:
	if bombs > 0:
		bombs -= 1
		bombs_changed.emit(bombs)
		return true
	return false

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		coins_changed.emit(coins)
		return true
	return false

func get_keys() -> int:
	return keys

func get_bombs() -> int:
	return bombs

func get_coins() -> int:
	return coins
