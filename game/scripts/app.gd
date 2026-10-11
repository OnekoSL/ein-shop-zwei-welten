extends Control
## Owns navigation, the session, and application-level confirmations.
const MAIN_MENU: PackedScene = preload("res://scenes/main_menu.tscn")
const GAME_SCREEN: PackedScene = preload("res://scenes/game_screen.tscn")
var saves: SaveService
var session: GameSession
var _current_screen: Control
var _dialog: DecisionDialog
var _in_game := false
var _retry_save: Callable

func _ready() -> void:
	get_window().min_size = Vector2i(960, 540)
	get_tree().auto_accept_quit = false
	get_window().close_requested.connect(_request_exit.bind(true))
	var directory := "user://"
	# Optional isolated directory for QA, including the standalone executable.
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--save-dir="):
			directory = argument.trim_prefix("--save-dir=")
	if saves == null:
		saves = SaveService.new(directory)
	session = GameSession.new(saves)
	session.changed.connect(_on_session_changed)
	session.save_failed.connect(_on_save_failed)
	_show_main_menu()

func _replace_screen(screen: Control) -> void:
	if is_instance_valid(_current_screen):
		remove_child(_current_screen)
		_current_screen.queue_free()
	_current_screen = screen
	add_child(screen)

func _show_main_menu() -> void:
	_in_game = false
	var menu := MAIN_MENU.instantiate()
	var current := saves.load_game()
	var backup := saves.load_backup()
	menu.can_continue = current.state != null
	menu.can_restore = current.state == null and backup.state != null
	menu.save_status = "" if current.state != null or current.missing else current.error
	if current.missing and backup.state != null:
		menu.save_status = "Eine Sicherung deiner letzten Partie ist vorhanden."
	menu.new_requested.connect(_request_new_game)
	menu.continue_requested.connect(_continue_game)
	menu.restore_requested.connect(_request_restore)
	menu.quit_requested.connect(_request_exit.bind(true))
	_replace_screen(menu)

func _request_new_game() -> void:
	if saves.has_files():
		_confirm("Eine neue Partie ersetzt deinen bisherigen Spielstand. Neues Spiel beginnen?", "Neues Spiel", _new_game)
	else:
		_new_game()

func _new_game() -> void:
	_retry_save = _new_game
	if session.new_game():
		_in_game = true
		_show_game()

func _continue_game() -> void:
	var error := session.continue_game()
	if not error.is_empty():
		_show_main_menu()
		_confirm(error, "Erneut laden", _continue_game, "Zurück")
		return
	_in_game = true
	_show_game()

func _request_restore() -> void:
	_confirm("Die Sicherung enthält den vorherigen gültigen Speicherstand. Möchtest du diesen Stand wiederherstellen?", "Wiederherstellen", _restore_backup)

func _restore_backup() -> void:
	var error := saves.restore_backup()
	if not error.is_empty():
		_confirm(error, "Erneut versuchen", _restore_backup, "Zurück")
		return
	_show_main_menu()

func _on_session_changed() -> void:
	if _in_game:
		_show_game()

func _show_game() -> void:
	var screen := GAME_SCREEN.instantiate()
	screen.state = session.state.copy()
	screen.phase = session.phase
	screen.world_id = session.world_id
	screen.location_id = session.location_id
	screen.world_requested.connect(session.choose_world)
	screen.visit_requested.connect(session.visit)
	screen.end_requested.connect(session.end_round)
	screen.finish_requested.connect(_finish_event)
	screen.next_requested.connect(session.next_round)
	screen.back_requested.connect(_request_exit.bind(false))
	_replace_screen(screen)

func _finish_event() -> void:
	_retry_save = _finish_event
	session.finish_event()

func _on_save_failed(message: String) -> void:
	_confirm(message + "\nDein bisheriger Speicherstand bleibt erhalten.", "Erneut versuchen", _retry_save, "Zurück")

func _confirm(message: String, accept_text: String, action: Callable, cancel_text: String = "Abbrechen") -> void:
	if is_instance_valid(_dialog) and _dialog.is_inside_tree():
		return
	_dialog = DecisionDialog.new()
	_dialog.name = "DecisionDialog"
	add_child(_dialog)
	_dialog.setup(message, accept_text, action, cancel_text)

func _request_exit(quit_app: bool) -> void:
	if is_instance_valid(_dialog) and _dialog.is_inside_tree():
		return
	if _in_game and session.has_unfinished_day():
		_confirm("Der begonnene Tag ist noch nicht gespeichert. Tag verwerfen und " + ("das Spiel beenden?" if quit_app else "zum Hauptmenü zurückkehren?"), "Tag verwerfen", _leave.bind(quit_app))
	else:
		_leave(quit_app)

func _leave(quit_app: bool) -> void:
	if quit_app:
		get_tree().quit()
	else:
		_show_main_menu()

func _unhandled_key_input(event: InputEvent) -> void:
	if _in_game and event.is_action_pressed(&"ui_cancel") and not event.is_echo():
		get_viewport().set_input_as_handled()
		_request_exit(false)
