extends SceneTree
## Editor-binary integration check using viewport input events and rendered frames.
## Release templates ignore --script; check the packaged application separately.
## Usage: Godot --path game --script <absolute path>/tools/qa_ui.gd -- <output dir>

var app: Control
var output_dir: String
var checks: Array[String] = []
var failures: Array[String] = []
var session: GameSession
var saves: SaveService


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
	var ancestor := button.get_parent()
	while ancestor != null:
		if ancestor is ScrollContainer:
			ancestor.ensure_control_visible(button)
		ancestor = ancestor.get_parent()
	await _settle()
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
		if control.is_visible_in_tree() and (control is Button or control is Label or control is TextureRect or control is LineEdit):
			var scrolling := false
			var ancestor := control.get_parent()
			while ancestor != null:
				if ancestor is ScrollContainer:
					scrolling = true
				ancestor = ancestor.get_parent()
			var rect := control.get_global_rect()
			_check(rect.position.x >= -1 and rect.end.x <= viewport_rect.end.x + 1 if scrolling else viewport_rect.grow(1.0).encloses(rect), label + ": reachable " + control.name)


func _capture(label: String) -> void:
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(output_dir.path_join(label + ".png"))
	_check(error == OK, "Screenshot " + label)


func _save_report() -> void:
	var file := FileAccess.open(output_dir.path_join("report.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"passed": checks, "failed": failures}, "\t"))
	print("QA RESULT: %d passed, %d failed" % [checks.size(), failures.size()])


func _press(name: String) -> void:
	var button := _button(name)
	if not _check(is_instance_valid(button), "Button exists: " + name):
		_save_report()
		quit(1)
		await process_frame
		return
	await _click(button)


func _run() -> void:
	# A watchdog turns unexpected hangs into a failing test process.
	create_timer(180).timeout.connect(func() -> void: printerr("UI QA timeout"); quit(1))
	app = load("res://scenes/app.tscn").instantiate() as Control
	saves = SaveService.new(output_dir.path_join("saves-%d" % Time.get_ticks_usec()))
	app.set("saves", saves)
	root.add_child(app)
	session = app.get("session")
	await _settle()
	_check(_button("ContinueButton").disabled, "Continue disabled without save")
	_check(root.gui_get_focus_owner() == _button("StartButton"), "New game gets initial focus")
	await _key(KEY_TAB)
	_check(root.gui_get_focus_owner() == _button("QuitButton"), "Tab skips disabled Continue")
	await _key(KEY_TAB, true)
	_check(root.gui_get_focus_owner() == _button("StartButton"), "Shift+Tab returns")
	await _capture("menu")
	await _key(KEY_ENTER)
	_check(session.phase == GameSession.Phase.WORLD_SELECTION, "Enter creates game")
	_check(saves.load_game().state != null, "New game saved")
	_check(root.gui_get_focus_owner() == _button("RealWorldButton"), "World choice focus")
	await _press("RealWorldButton")
	_check(_button("EnterButton").disabled, "Cannot enter before selection")
	await _press("Map_smith")
	_check(session.phase == GameSession.Phase.CITY_MAP, "Map selection does not visit yet")
	await _press("EnterButton")
	_check(session.location_id == "smith", "Explicit visit confirmed")
	await _key(KEY_ESCAPE)
	_check(root.gui_get_focus_owner() == _button("DialogCancel"), "Discard dialog focuses Cancel")
	await _key(KEY_TAB)
	_check(root.gui_get_focus_owner() == _button("DialogAccept"), "Dialog Tab to accept")
	await _key(KEY_TAB)
	_check(root.gui_get_focus_owner() == _button("DialogCancel"), "Dialog focus remains modal")
	await _key(KEY_ESCAPE)
	_check(session.phase == GameSession.Phase.VISIT, "Escape cancels discard")
	await _press("BackButton")
	await _press("DialogAccept")
	_check(is_instance_valid(_button("ContinueButton")), "Discard returns to menu")
	await _press("ContinueButton")
	_check(session.phase == GameSession.Phase.WORLD_SELECTION and session.state.data.worlds.real.day == 1, "Continue discards unfinished day")
	# Complete every location in each world with actual viewport mouse events.
	for world in GameState.WORLDS:
		for location in GameState.LOCATIONS:
			await _press("RealWorldButton" if world == "real" else "FantasyWorldButton")
			if world == "fantasy" and location == "shop":
				await _capture("fantasy-map")
			await _press("Map_" + location)
			await _press("EnterButton")
			_check(session.world_id == world and session.location_id == location, "UI visit " + world + "/" + location)
			await _press("EndRoundButton")
			_check(session.phase == GameSession.Phase.EVENT, "Event shown")
			await _press("FinishEventButton")
			_check(session.phase == GameSession.Phase.SUMMARY, "Summary shown after save")
			await _press("NextRoundButton")
	_check(session.state.data.worlds.real.day == 6 and session.state.data.worlds.fantasy.day == 6, "Ten visits advance correct worlds")
	# Each phase at each required window size; focus and input work throughout.
	for window_size in [Vector2i(960, 540), Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i.ZERO]:
		var label := "%dx%d" % [window_size.x, window_size.y]
		if window_size == Vector2i.ZERO:
			root.mode = Window.MODE_MAXIMIZED
			label = "maximized"
		else:
			root.mode = Window.MODE_WINDOWED
			root.size = window_size
		await create_timer(0.2).timeout
		_layout("worlds-" + label)
		await _capture("worlds-" + label)
		await _key(KEY_ENTER)
		_layout("map-" + label)
		await _capture("map-" + label)
		await _press("Map_shop")
		await _press("EnterButton")
		_layout("shop-" + label)
		await _capture("shop-" + label)
		await _press("EndRoundButton")
		_layout("event-" + label)
		await _capture("event-" + label)
		await _key(KEY_ENTER)
		_layout("summary-" + label)
		await _capture("summary-" + label)
		await _key(KEY_ESCAPE)
		_check(is_instance_valid(_button("ContinueButton")), "Saved boundary exits without dialog")
		_layout("menu-" + label)
		await _capture("menu-" + label)
		await _press("StartButton")
		_layout("dialog-" + label)
		await _capture("dialog-" + label)
		await _key(KEY_ESCAPE)
		await _press("ContinueButton")
	# Failed completion keeps the event; retry commits exactly once.
	await _press("FantasyWorldButton")
	await _press("Map_library")
	await _press("EnterButton")
	await _press("EndRoundButton")
	var before: int = session.state.data.worlds.fantasy.day
	DirAccess.make_dir_absolute(saves.path + ".tmp")
	await _press("FinishEventButton")
	_check(session.phase == GameSession.Phase.EVENT, "Write failure leaves event open")
	_check(root.gui_get_focus_owner() == _button("DialogCancel"), "Error dialog safe focus")
	await _capture("save-error")
	DirAccess.remove_absolute(saves.path + ".tmp")
	await _press("DialogAccept")
	_check(session.phase == GameSession.Phase.SUMMARY and session.state.data.worlds.fantasy.day == before + 1, "Retry advances one day")
	await _press("BackButton")
	await _press("StartButton")
	await _press("DialogCancel")
	_check(saves.load_game().state.data.worlds.fantasy.day == before + 1, "Cancel new game preserves save")
	await _capture("after-cancel-new")
	await _press("StartButton")
	await _capture("before-confirm-new")
	await _press("DialogAccept")
	_check(session.state.data.worlds.real.day == 1 and session.state.data.worlds.fantasy.day == 1, "Confirmed new game resets both worlds")
	await _press("RealWorldButton")
	root.close_requested.emit()
	await _settle()
	_check(root.gui_get_focus_owner() == _button("DialogCancel"), "Window-close request asks before discard")
	await _press("DialogCancel")
	_check(session.phase == GameSession.Phase.CITY_MAP, "Cancel window-close continues day")
	await _press("BackButton")
	await _press("DialogAccept")
	# Recovery is offered explicitly and only activates after confirmation.
	var file := FileAccess.open(saves.path, FileAccess.WRITE)
	file.store_string("{broken")
	file.close()
	app.call("_show_main_menu")
	await _settle()
	_check(_button("ContinueButton").disabled and _button("RestoreButton").visible, "Corruption offers explicit recovery")
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(960, 540)
	await create_timer(0.2).timeout
	_layout("recovery-menu")
	await _capture("recovery-menu")
	await _press("RestoreButton")
	await _press("DialogCancel")
	_check(saves.load_game().state == null, "Cancel recovery does not overwrite")
	await _press("RestoreButton")
	await _press("DialogAccept")
	_check(saves.load_game().state != null and not _button("ContinueButton").disabled, "Confirmed recovery re-enables Continue")
	await _trade_flow()
	# Prepared nonempty data checks warehouse and isolated displays in the actual UI.
	var rich := GameState.new()
	rich.data.inventory.materials = {"oak": 3}
	rich.data.skills.carpentry = 8
	rich.data.recipes.append("padded_chair")
	rich.data.prototypes = {
		"a": {"recipe_id": "kitchen_chair", "material_ids": ["oak", "magic_nails"], "quality": 20, "created_order": 1, "analyzed": false},
		"b": {"recipe_id": "padded_chair", "material_ids": ["oak", "magic_nails", "cotton"], "quality": 20, "created_order": 2, "analyzed": false}
	}
	rich.data.next_prototype_id = 3
	rich.data.worlds.real.display = [{"prototype_id": "a", "price_minor": 999999}, null, null]
	rich.data.worlds.fantasy.display = [{"prototype_id": "b", "price_minor": 999999}, null, null]
	saves.save_game(rich)
	app.call("_show_main_menu")
	await _settle()
	await _press("ContinueButton")
	for world in GameState.WORLDS:
		await _press("RealWorldButton" if world == "real" else "FantasyWorldButton")
		await _press("Map_shop")
		await _press("EnterButton")
		_check(_texts().contains("Tischlern: Stufe 8"), "Shared skill in " + world)
		await _press("Tab_Lager")
		_check(_texts().contains("Eichenholz × 3"), "Shared materials in " + world)
		await _press("Tab_Auslage")
		_check(_texts().contains("a · Eichenholz") == (world == "real"), "Real display accessible only in real world")
		_check(_texts().contains("b · Eichenholz") == (world == "fantasy"), "Fantasy display accessible only in fantasy world")
		await _capture("populated-shop-" + world)
		await _press("EndRoundButton")
		await _press("FinishEventButton")
		await _press("NextRoundButton")
	await _press("BackButton")
	root.size = Vector2i(320, 240)
	await create_timer(0.2).timeout
	_check(root.size.x >= 960 and root.size.y >= 540, "Minimum size enforced")
	_save_report()
	if not failures.is_empty():
		quit(1)
		return
	await _press("QuitButton")
	printerr("Quit button failed to exit")
	quit(1)


func _texts() -> String:
	var text := ""
	for node in app.find_children("*", "Label", true, false):
		text += node.text + "\n"
	return text


func _enter(world: String, place: String) -> void:
	await _press("RealWorldButton" if world == "real" else "FantasyWorldButton")
	await _press("Map_" + place)
	await _press("EnterButton")


func _finish_day() -> void:
	await _press("EndRoundButton")
	await _press("FinishEventButton")
	await _press("NextRoundButton")


func _set_text(node_name: String, text: String) -> void:
	var edit := app.find_child(node_name, true, false) as LineEdit
	edit.grab_focus()
	await _settle()
	for pressed in [true, false]:
		var event := InputEventKey.new()
		event.keycode = KEY_A
		event.ctrl_pressed = true
		event.pressed = pressed
		root.push_input(event, true)
	for character in text:
		for pressed in [true, false]:
			var event := InputEventKey.new()
			event.keycode = character.unicode_at(0)
			event.unicode = character.unicode_at(0)
			event.pressed = pressed
			root.push_input(event, true)
	await _settle()


func _trade_flow() -> void:
	await _press("StartButton")
	await _press("DialogAccept")
	await _enter("real", "sawmill")
	var scroll := app.find_child("TradeScroll", true, false) as ScrollContainer
	scroll.grab_focus()
	await _key(KEY_DOWN)
	_check(scroll.scroll_vertical > 0, "Keyboard can scroll merchant information")
	scroll.scroll_vertical = 0
	await _capture("merchant-minimum")
	await _press("Buy_oak")
	_check(session.state.data.money.eur_cent == 9000 and session.state.data.inventory.materials.oak == 1, "UI material purchase")
	_check(root.gui_get_focus_owner() == _button("Buy_oak"), "Purchase retains useful focus")
	var quantity := app.find_child("Quantity_oak", true, false) as SpinBox
	quantity.value = 100
	await _press("Buy_oak")
	_check(_texts().contains("fehlen") and session.state.data.money.eur_cent == 9000, "UI purchase error is clear and atomic")
	_check((app.find_child("Quantity_oak", true, false) as SpinBox).value == 100, "Quantity survives failed purchase")
	await _finish_day()
	await _enter("fantasy", "smith")
	await _press("Buy_magic_nails")
	await _finish_day()
	await _enter("fantasy", "shop")
	_check(not _button("CraftButton").disabled, "Materials enable crafting")
	await _capture("craft-ready-minimum")
	await _press("CraftButton")
	_check(session.state.data.inventory.prototype_ids.size() == 1 and session.state.data.inventory.materials.is_empty(), "UI craft consumes materials")
	await _press("Tab_Lager")
	_check(_texts().contains("p000001") and not _texts().contains("Wert:"), "Warehouse shows unique exemplar without hidden value")
	await _press("Tab_Auslage")
	await _set_text("SlotPrice_0", "1,234")
	await _press("Exhibit_0")
	_check(session.state.data.worlds.fantasy.display[0] == null, "Invalid price rejected")
	_check((app.find_child("SlotPrice_0", true, false) as LineEdit).text == "1,234", "Invalid price input preserved")
	await _set_text("SlotPrice_0", "40")
	await _press("Exhibit_0")
	_check(session.state.data.worlds.fantasy.display[0].price_minor == 4000, "UI exhibit at 40 S")
	_check(not _texts().contains("Nachfrage: 6") and not _texts().contains("Qualität"), "No numerical quality or demand preview")
	await _capture("display-minimum")
	await _press("Tab_Markt")
	_check(_texts().contains("Alltagsmöbel") and _texts().contains("Feine Möbel"), "Competition visible")
	await _capture("market-minimum")
	await _press("EndRoundButton")
	await _press("FinishEventButton")
	_check(session.state.data.money == {"eur_cent": 4000, "fantasy_pfennig": 24000}, "UI full example exact balances")
	_check(_texts().contains("Nachfrage: 6") and _texts().contains("5 zusätzliche"), "Report separates demand and actual sales")
	await _capture("trade-report-minimum")
	await _press("NextRoundButton")
	await _enter("fantasy", "library")
	await _press("LearnAnalysis")
	_check(_button("LearnCarpentry").disabled and session.learned_today, "UI analysis consumes learning")
	await _press("Recipe_padded_chair")
	_check("padded_chair" in session.state.data.recipes and _button("Recipe_padded_chair").disabled, "UI recipe purchase after learning")
	await _capture("library-minimum")
	await _finish_day()
	await _enter("fantasy", "shop")
	await _press("Tab_Auslage")
	await _press("Analyze_p000001")
	_check(_texts().contains("50,00 €") and _texts().contains("0,4000 Goldmark"), "UI analysis reveals both values")
	_check(not _texts().contains("Qualität"), "Analysis never reveals quality number")
	await _capture("analysis-minimum")
	await _press("Withdraw_0")
	_check(session.state.data.worlds.fantasy.display[0] == null and session.state.data.inventory.prototype_ids.size() == 1, "UI withdrawal through warehouse")
	# Discard must restore both the location and analysis state of the saved exemplar.
	await _key(KEY_ESCAPE)
	await _press("DialogCancel")
	_check(session.state.data.worlds.fantasy.display[0] == null, "Cancel discard keeps withdrawal")
	await _press("BackButton")
	await _press("DialogAccept")
	await _press("ContinueButton")
	_check(session.state.data.worlds.fantasy.display[0] != null and not session.state.data.prototypes.p000001.analyzed, "Discard restores display and unperformed analysis")
	# Each new functional view at start size, minimum and maximized, with keyboard scrolling.
	for window_size in [Vector2i(960, 540), Vector2i(1280, 720), Vector2i.ZERO]:
		root.mode = Window.MODE_MAXIMIZED if window_size == Vector2i.ZERO else Window.MODE_WINDOWED
		if window_size != Vector2i.ZERO:
			root.size = window_size
		await create_timer(0.2).timeout
		var label := "maximized" if window_size == Vector2i.ZERO else "%dx%d" % [window_size.x, window_size.y]
		await _enter("fantasy", "shop")
		for tab in ["Herstellen", "Lager", "Auslage", "Markt"]:
			await _press("Tab_" + tab)
			_layout(tab + label)
			await _capture(tab + label)
			await _key(KEY_TAB)
			_check(root.gui_get_focus_owner() != null, "Keyboard focus in " + tab + label)
		await _press("BackButton")
		await _press("DialogAccept")
		await _press("ContinueButton")
		for place in ["sawmill", "smith", "tailor", "library"]:
			await _enter("real", place)
			_layout(place + label)
			await _capture(place + label)
			await _press("BackButton")
			await _press("DialogAccept")
			await _press("ContinueButton")
	await _press("BackButton")
