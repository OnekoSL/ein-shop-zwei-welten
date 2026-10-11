extends SceneTree
## Editor-binary integration check using viewport input events and rendered frames.
## Release templates ignore --script; check the packaged application separately.
## Usage: Godot --path game --script <absolute path>/tools/qa_ui.gd -- <output dir>

var app: Control
var output_dir: String
var checks: Array[String] = []
var failures: Array[String] = []


func _initialize() -> void:
	var arguments := OS.get_cmdline_user_args()
	if arguments.is_empty():
		printerr("QA: An absolute output directory is required after --.")
		quit(1)
		return
	output_dir = arguments[0]
	DirAccess.make_dir_recursive_absolute(output_dir)
	_run.call_deferred()


func _check(condition: bool, description: String) -> bool:
	if condition:
		checks.append(description)
	else:
		failures.append(description)
		printerr("QA FAIL: " + description)
	return condition


func _button(button_name: String) -> Button:
	return app.find_child(button_name, true, false) as Button


func _settle() -> void:
	await process_frame
	await process_frame


func _key(code: int, shift: bool = false) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.shift_pressed = shift
	event.pressed = true
	root.push_input(event, true)
	await _settle()
	event = InputEventKey.new()
	event.keycode = code
	event.shift_pressed = shift
	event.pressed = false
	root.push_input(event, true)
	await _settle()


func _click(button: Button) -> void:
	var position := button.get_global_rect().get_center()
	var motion := InputEventMouseMotion.new()
	motion.position = position
	motion.global_position = position
	root.push_input(motion, true)
	for pressed in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.position = position
		event.global_position = position
		event.pressed = pressed
		root.push_input(event, true)
		await _settle()


func _layout(label: String) -> void:
	var viewport_rect := root.get_visible_rect()
	for node in app.find_children("*", "Control", true, false):
		var control := node as Control
		if control.is_visible_in_tree() and (control is Button or control is Label or control is TextureRect):
			_check(viewport_rect.grow(1.0).encloses(control.get_global_rect()), label + ": visible " + control.name)


func _capture(label: String) -> void:
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(output_dir.path_join(label + ".png"))
	_check(error == OK, "Screenshot " + label)


func _save_report() -> void:
	var file := FileAccess.open(output_dir.path_join("report.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"passed": checks, "failed": failures}, "\t"))
	print("QA RESULT: %d passed, %d failed" % [checks.size(), failures.size()])


func _run() -> void:
	app = load("res://scenes/app.tscn").instantiate() as Control
	root.add_child(app)
	await _settle()
	if not _check(is_instance_valid(_button("StartButton")), "Main menu loaded"):
		_save_report()
		quit(1)
		return
	_check(root.gui_get_focus_owner() == _button("StartButton"), "Initial focus on Start")
	await _key(KEY_TAB)
	_check(root.gui_get_focus_owner() == _button("QuitButton"), "Tab to Quit")
	await _key(KEY_TAB, true)
	_check(root.gui_get_focus_owner() == _button("StartButton"), "Shift+Tab to Start")
	await _key(KEY_TAB, true)
	_check(root.gui_get_focus_owner() == _button("QuitButton"), "Shift+Tab wraps to Quit")
	await _key(KEY_TAB)
	_check(root.gui_get_focus_owner() == _button("StartButton"), "Tab wraps to Start")
	for cycle in range(3):
		await _click(_button("StartButton"))
		if not _check(is_instance_valid(_button("BackButton")), "Mouse start %d" % cycle):
			_save_report()
			quit(1)
			return
		_check(root.gui_get_focus_owner() == _button("BackButton"), "Game view focus %d" % cycle)
		await _click(_button("BackButton"))
		_check(root.gui_get_focus_owner() == _button("StartButton"), "Mouse back and restored focus %d" % cycle)
		await _key(KEY_ENTER)
		_check(is_instance_valid(_button("BackButton")), "Enter starts %d" % cycle)
		await _key(KEY_ESCAPE)
		_check(root.gui_get_focus_owner() == _button("StartButton"), "Escape and restored focus %d" % cycle)
	for window_size in [Vector2i(960, 540), Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.mode = Window.MODE_WINDOWED
		root.size = window_size
		await create_timer(0.15).timeout
		var label := "%dx%d" % [window_size.x, window_size.y]
		_layout("menu-" + label)
		await _capture("menu-" + label)
		await _click(_button("StartButton"))
		_layout("game-" + label)
		await _capture("game-" + label)
		await _key(KEY_ESCAPE)
	root.mode = Window.MODE_MAXIMIZED
	await create_timer(0.2).timeout
	_layout("menu-maximized")
	await _capture("menu-maximized")
	await _key(KEY_ENTER)
	_layout("game-maximized")
	await _capture("game-maximized")
	await _key(KEY_SPACE)
	_check(is_instance_valid(_button("StartButton")), "Space activates Back")
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(320, 240)
	await create_timer(0.2).timeout
	_check(root.size.x >= 960 and root.size.y >= 540, "Minimum window size enforced")
	if not failures.is_empty():
		_save_report()
		quit(1)
		return
	var menu := app.get_child(0)
	menu.connect(&"quit_requested", func() -> void:
		_check(true, "Quit button emitted request; App exits normally")
		_save_report()
	)
	await _click(_button("QuitButton"))
	# Reached only if the quit request failed to terminate the application.
	_check(false, "Quit button must terminate application")
	_save_report()
	quit(1)
