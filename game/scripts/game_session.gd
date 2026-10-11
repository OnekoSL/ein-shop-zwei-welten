class_name GameSession
extends RefCounted
## The only entry point for day progression. Nothing commits before saving.

signal changed
signal save_failed(message: String)

enum Phase { WORLD_SELECTION, CITY_MAP, VISIT, EVENT, SUMMARY }

var state: GameState
var phase := Phase.WORLD_SELECTION
var world_id := ""
var location_id := ""
var saves: SaveService
var _busy := false


func _init(service: SaveService) -> void:
	saves = service


func _adopt(next_state: GameState) -> void:
	state = next_state
	phase = Phase.WORLD_SELECTION
	world_id = ""
	location_id = ""
	changed.emit()


func new_game() -> bool:
	var initial := GameState.new()
	var error := saves.save_game(initial)
	if not error.is_empty():
		save_failed.emit(error)
		return false
	_adopt(initial)
	return true


func continue_game() -> String:
	var result := saves.load_game()
	if result.state == null:
		return result.error
	_adopt(result.state)
	return ""


func choose_world(id: String) -> bool:
	if state == null or phase != Phase.WORLD_SELECTION or not id in GameState.WORLDS:
		return false
	world_id = id
	phase = Phase.CITY_MAP
	changed.emit()
	return true


func visit(id: String) -> bool:
	if phase != Phase.CITY_MAP or not id in GameState.LOCATIONS:
		return false
	location_id = id
	phase = Phase.VISIT
	changed.emit()
	return true


func end_round() -> bool:
	if phase != Phase.VISIT:
		return false
	phase = Phase.EVENT
	changed.emit()
	return true


func finish_event() -> bool:
	if phase != Phase.EVENT or _busy:
		return false
	_busy = true
	var candidate := state.copy()
	candidate.data.last_summary = {"world_id": world_id, "location_id": location_id, "day": candidate.data.worlds[world_id].day}
	candidate.data.worlds[world_id].day += 1
	var error := saves.save_game(candidate)
	_busy = false
	if not error.is_empty():
		save_failed.emit(error)
		return false
	state = candidate
	phase = Phase.SUMMARY
	changed.emit()
	return true


func next_round() -> bool:
	if phase != Phase.SUMMARY:
		return false
	phase = Phase.WORLD_SELECTION
	world_id = ""
	location_id = ""
	changed.emit()
	return true


func has_unfinished_day() -> bool:
	return phase in [Phase.CITY_MAP, Phase.VISIT, Phase.EVENT]
