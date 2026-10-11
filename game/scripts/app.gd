extends Control
## Owns navigation. Views only emit requests; gameplay state comes later.

const MAIN_MENU: PackedScene = preload("res://scenes/main_menu.tscn")
const GAME_SCREEN: PackedScene = preload("res://scenes/game_screen.tscn")

var _current_screen: Control


func _ready() -> void:
	get_window().min_size = Vector2i(960, 540)
	_show_main_menu()


func _set_screen(scene: PackedScene) -> Control:
	if is_instance_valid(_current_screen):
		remove_child(_current_screen)
		_current_screen.queue_free()
	_current_screen = scene.instantiate() as Control
	add_child(_current_screen)
	return _current_screen


func _show_main_menu() -> void:
	var menu := _set_screen(MAIN_MENU)
	menu.connect(&"start_requested", _show_game)
	menu.connect(&"quit_requested", _quit)


func _show_game() -> void:
	var screen := _set_screen(GAME_SCREEN)
	screen.connect(&"back_requested", _show_main_menu)


func _quit() -> void:
	get_tree().quit()
