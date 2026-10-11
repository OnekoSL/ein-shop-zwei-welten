class_name SaveService
extends RefCounted
## All filesystem work is isolated here; tests inject a separate directory.

var path: String


func _init(directory: String = "user://") -> void:
	path = ProjectSettings.globalize_path(directory.path_join("savegame.json"))


func has_files() -> bool:
	return FileAccess.file_exists(path) or FileAccess.file_exists(path + ".bak")


func read_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		return {"state": null, "error": "Noch kein Spielstand vorhanden.", "missing": true}
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return {"state": null, "error": "Der Spielstand kann nicht gelesen werden.", "missing": false}
	var parser := JSON.new()
	var parse_error := parser.parse(file.get_as_text())
	file.close()
	if parse_error != OK:
		return {"state": null, "error": "Die Spielstanddatei ist beschädigt (ungültiges JSON).", "missing": false}
	var validation := GameState.validate(parser.data)
	if not validation.is_empty():
		return {"state": null, "error": validation, "missing": false}
	return {"state": GameState.from_data(parser.data), "error": "", "missing": false}


func load_game() -> Dictionary:
	return read_file(path)


func load_backup() -> Dictionary:
	return read_file(path + ".bak")


func _replace_file(source: String, destination: String) -> Error:
	return DirAccess.rename_absolute(source, destination)


func save_game(state: GameState, preserve_backup: bool = false) -> String:
	var validation := GameState.validate(state.data)
	if not validation.is_empty():
		return "Speichern nicht möglich: " + validation
	if DirAccess.make_dir_recursive_absolute(path.get_base_dir()) != OK:
		return "Der Speicherordner kann nicht angelegt werden."
	var temporary := path + ".tmp"
	var file := FileAccess.open(temporary, FileAccess.WRITE)
	if file == null:
		return "Der Spielstand kann nicht geschrieben werden. Bitte Speicherplatz und Schreibrechte prüfen."
	file.store_string(JSON.stringify(state.data, "\t"))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK or read_file(temporary).state == null:
		return "Der neue Spielstand konnte nicht vollständig geschrieben werden."
	# Only a valid current save may replace the recovery copy.
	if not preserve_backup and load_game().state != null:
		var backup_temp := path + ".bak.tmp"
		if DirAccess.copy_absolute(path, backup_temp) != OK or _replace_file(backup_temp, path + ".bak") != OK:
			return "Die Sicherung konnte nicht aktualisiert werden. Der bisherige Spielstand bleibt erhalten."
	if _replace_file(temporary, path) != OK:
		return "Die Spielstanddatei konnte nicht ersetzt werden. Der bisherige Spielstand bleibt erhalten."
	return ""


func restore_backup() -> String:
	var result := load_backup()
	if result.state == null:
		return result.error
	return save_game(result.state, true)
