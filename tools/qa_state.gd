extends SceneTree
## Headless domain and disk tests. Always uses a fresh isolated directory.

var passed: Array[String] = []
var failed: Array[String] = []
var directory: String

class RejectReplace extends SaveService:
	var reject := false
	func _replace_file(source: String, destination: String) -> Error:
		if reject and destination == path:
			return ERR_FILE_CANT_WRITE
		return super._replace_file(source, destination)


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, label: String) -> void:
	(passed if condition else failed).append(label)
	if not condition:
		printerr("FAIL: " + label)


func fixture() -> GameState:
	var state := GameState.new()
	state.data.money = {"eur_cent": 12345, "fantasy_pfennig": 7654321}
	state.data.inventory.materials = {"oak": 3, "magic_nails": 7}
	state.data.skills = {"carpentry": 8, "analysis": 2}
	state.data.recipes.append("padded_chair")
	for id in ["stored", "real_chair", "fantasy_chair"]:
		state.data.prototypes[id] = {"recipe_id": "kitchen_chair", "material_ids": ["oak", "magic_nails"], "quality": 3.5}
	state.data.inventory.prototype_ids = ["stored"]
	state.data.worlds.real.display = [{"prototype_id": "real_chair", "price_minor": 4000}]
	state.data.worlds.fantasy.display = [{"prototype_id": "fantasy_chair", "price_minor": 5678}]
	return state


func write_text(path: String, text: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(text)
	file.close()


func complete_day(session: GameSession, world: String, location: String) -> void:
	check(session.choose_world(world), "Choose " + world)
	check(not session.choose_world("fantasy" if world == "real" else "real"), "World switch blocked")
	check(session.visit(location), "Visit " + location)
	check(not session.visit("shop"), "Second visit blocked")
	check(session.end_round(), "End visit")
	check(not session.end_round(), "Repeated end blocked")
	check(session.finish_event(), "Commit day")
	check(not session.finish_event(), "Duplicate completion blocked")
	check(session.next_round(), "Next round")


func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		printerr("Pass an output directory after --")
		quit(1)
		return
	directory = args[0].path_join("run-%d" % Time.get_ticks_usec())
	DirAccess.make_dir_recursive_absolute(directory)
	var saves := SaveService.new(directory)
	check(saves.load_game().missing, "Missing save is explicit")
	var session := GameSession.new(saves)
	check(not session.choose_world("real"), "No world before new/load")
	check(session.new_game(), "Initial save")
	check(session.state.data.money.eur_cent == 10000 and session.state.data.money.fantasy_pfennig == 10000, "Initial money")
	check(session.state.data.inventory.prototype_ids.is_empty(), "Initial warehouse empty")
	check(not session.visit("shop") and not session.finish_event(), "Invalid phase commands rejected")
	check(not session.choose_world("unknown"), "Unknown world rejected")
	complete_day(session, "real", "shop")
	complete_day(session, "real", "smith")
	complete_day(session, "fantasy", "library")
	check(session.state.data.worlds.real.day == 3 and session.state.data.worlds.fantasy.day == 2, "Two real days and one fantasy day yield 3 / 2")
	check(session.state.data.last_summary.day == 1 and session.state.data.last_summary.world_id == "fantasy", "Summary uses completed day")
	check(session.state.data.money.eur_cent == 10000, "No economic effects")
	var resumed := GameSession.new(SaveService.new(directory))
	check(resumed.continue_game().is_empty(), "Fresh session loads disk")
	check(resumed.phase == GameSession.Phase.WORLD_SELECTION and resumed.world_id.is_empty(), "Resume at free world selection")
	check(resumed.state.data == session.state.data, "All round data restored")
	for world in GameState.WORLDS:
		for location in GameState.LOCATIONS:
			complete_day(resumed, world, location)
	var rich := fixture()
	check(GameState.validate(rich.data).is_empty(), "Rich fixture valid")
	check(saves.save_game(rich).is_empty(), "Save nonempty inventory and displays")
	var loaded: GameState = saves.load_game().state
	check(loaded.data == rich.data, "Full data round trip")
	check(loaded.data.money.eur_cent is int and loaded.data.worlds.real.day is int, "JSON integers restored")
	loaded.data.skills.carpentry = 9
	check(loaded.data.prototypes.real_chair.quality == 3.5, "Skill update does not mutate prototype snapshot")
	for invalid in [-1, 1.5, "100", true, null, INF, 1e15]:
		var bad := rich.copy()
		bad.data.money.eur_cent = invalid
		check(not GameState.validate(bad.data).is_empty(), "Invalid money rejected: " + str(invalid))
	for field in rich.data.keys():
		var bad := rich.copy()
		bad.data.erase(field)
		check(not GameState.validate(bad.data).is_empty(), "Missing field rejected: " + field)
	var duplicate := rich.copy()
	duplicate.data.inventory.prototype_ids.append("real_chair")
	check(not GameState.validate(duplicate.data).is_empty(), "Prototype cannot belong to inventory and display")
	duplicate = rich.copy()
	duplicate.data.worlds.fantasy.display[0].prototype_id = "real_chair"
	check(not GameState.validate(duplicate.data).is_empty(), "Prototype cannot belong to both worlds")
	duplicate = rich.copy()
	duplicate.data.inventory.prototype_ids = ["absent"]
	check(not GameState.validate(duplicate.data).is_empty(), "Missing prototype rejected")
	duplicate = rich.copy()
	duplicate.data.worlds.real.day = 0
	check(not GameState.validate(duplicate.data).is_empty(), "Zero day rejected")
	duplicate = rich.copy()
	duplicate.data.worlds.real.display[0].price_minor = -1
	check(not GameState.validate(duplicate.data).is_empty(), "Negative price rejected")
	duplicate = rich.copy()
	duplicate.data.format_version = 99
	write_text(saves.path, JSON.stringify(duplicate.data))
	check(saves.load_game().state == null and saves.load_game().error.contains("version"), "Unsupported format explained")
	write_text(saves.path, "{broken")
	check(saves.load_game().state == null, "Corrupt JSON rejected without reset")
	check(saves.load_backup().state != null, "Previous valid save retained")
	var backup: Dictionary = saves.load_backup().state.data.duplicate(true)
	check(saves.restore_backup().is_empty(), "Explicit backup restoration")
	check(saves.load_game().state.data == backup, "Restored exact backup")
	check(saves.load_backup().state.data == backup, "Recovery preserves backup")
	var reject := RejectReplace.new(directory.path_join("fail-replace"))
	var transaction := GameSession.new(reject)
	transaction.new_game()
	transaction.choose_world("real")
	transaction.visit("smith")
	transaction.end_round()
	var original_bytes := FileAccess.get_file_as_bytes(reject.path)
	reject.reject = true
	check(not transaction.finish_event(), "Replace failure stops completion")
	check(transaction.phase == GameSession.Phase.EVENT and transaction.state.data.worlds.real.day == 1, "Failure leaves day uncommitted")
	check(FileAccess.get_file_as_bytes(reject.path) == original_bytes, "Failure retains original save bytes")
	check(not transaction.new_game(), "Failed new game retains old state")
	check(transaction.phase == GameSession.Phase.EVENT, "Failed new game keeps current phase")
	reject.reject = false
	check(transaction.finish_event(), "Retry completes")
	check(not transaction.finish_event() and transaction.state.data.worlds.real.day == 2, "Retry commits only once")
	# A directory at the temporary-file path is a real filesystem write failure.
	var blocked := SaveService.new(directory.path_join("blocked"))
	blocked.save_game(rich)
	DirAccess.make_dir_absolute(blocked.path + ".tmp")
	check(not blocked.save_game(GameState.new()).is_empty(), "Unwritable temporary file explained")
	check(blocked.load_game().state.data == rich.data, "Write failure preserves rich state")
	write_text(directory.path_join("not-a-directory"), "file")
	var no_directory := SaveService.new(directory.path_join("not-a-directory/child"))
	check(not no_directory.save_game(rich).is_empty(), "Directory creation error explained")
	var report := {"passed": passed, "failed": failed}
	write_text(directory.path_join("report.json"), JSON.stringify(report, "\t"))
	print("STATE QA: %d passed, %d failed; %s" % [passed.size(), failed.size(), directory])
	quit(0 if failed.is_empty() else 1)
