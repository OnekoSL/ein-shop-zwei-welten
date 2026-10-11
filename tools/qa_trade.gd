extends SceneTree
## Domain, migration, transaction and deterministic market acceptance tests.

var passed: Array[String] = []
var failed: Array[String] = []
var directory: String
var counter := 0

class RejectSave extends SaveService:
	var reject := false
	func _replace_file(source: String, destination: String) -> Error:
		return ERR_CANT_CREATE if reject else super._replace_file(source, destination)

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		printerr("Pass an isolated output directory after --")
		quit(1)
		return
	directory = args[0].path_join("run-%d" % Time.get_ticks_usec())
	DirAccess.make_dir_recursive_absolute(directory)
	_run.call_deferred()

func check(condition: bool, label: String) -> void:
	if condition:
		passed.append(label)
	else:
		failed.append(label)
		printerr("FAIL: " + label)

func session() -> GameSession:
	counter += 1
	var result := GameSession.new(SaveService.new(directory.path_join(str(counter))))
	check(result.new_game(), "New test session %d" % counter)
	return result

func visit(s: GameSession, world: String, place: String) -> void:
	check(s.choose_world(world), "Choose " + world)
	check(s.visit(place), "Visit " + place)

func finish(s: GameSession) -> void:
	check(s.end_round(), "End visit")
	check(s.finish_event(), "Commit report")
	check(not s.finish_event(), "Repeated completion rejected")
	check(s.next_round(), "Next round")

func proto(state: GameState, id: String, order: int, world: String = "fantasy", index: int = 0, price: int = 4000) -> void:
	state.data.prototypes[id] = {"recipe_id": "kitchen_chair", "material_ids": ["oak", "magic_nails"], "quality": 20, "created_order": order, "analyzed": false}
	state.data.worlds[world].display[index] = {"prototype_id": id, "price_minor": price}
	state.data.next_prototype_id = maxi(state.data.next_prototype_id, order + 1)

func _run() -> void:
	# The user's complete mixed-currency example through real session commands.
	var s := session()
	visit(s, "real", "sawmill")
	check(s.buy_material("oak", 1), "Buy oak")
	check(s.state.data.money.eur_cent == 9000 and s.state.data.inventory.materials.oak == 1, "Oak debit and stock")
	var snapshot := s.state.data.duplicate(true)
	check(not s.buy_material("magic_nails", 1) and not s.buy_material("oak", -1), "Wrong merchant and negative quantity rejected")
	check(not s.buy_material("oak", 100) and s.state.data == snapshot, "Unaffordable purchase is atomic")
	check(not s.craft("kitchen_chair", ["oak", "magic_nails"]), "Crafting blocked at merchant")
	finish(s)
	check(s.state.data.last_summary.transactions[0].amount == 1000 and s.state.data.last_summary.sales.is_empty(), "Purchase report, no merchant sales")
	visit(s, "fantasy", "smith")
	check(s.buy_material("magic_nails", 1), "Buy magical nails")
	finish(s)
	visit(s, "fantasy", "shop")
	check(not s.craft("kitchen_chair", ["oak", "oak"]), "Wrong material groups rejected")
	check(s.craft("kitchen_chair", ["oak", "magic_nails"]), "Craft from both worlds")
	var id: String = s.state.data.inventory.prototype_ids[0]
	check(s.state.data.prototypes[id].quality == 20 and TradeRules.limit(s.state.data.prototypes[id]) == 5, "Quality 20, limit 5")
	check(TradeRules.value(s.state.data.prototypes[id], "real") == 5000 and TradeRules.value(s.state.data.prototypes[id], "fantasy") == 4000, "Independent values 50 EUR and 40 S")
	check(not s.exhibit(id, 0, 0) and s.exhibit(id, 0, 4000), "Explicit positive display price")
	check(not s.exhibit(id, 1, 4000), "One owner per prototype")
	check(s.state.data.inventory.materials.is_empty() and s.state.data.inventory.prototype_ids.is_empty(), "Construction consumes stock; display moves exemplar")
	check(MarketRules.demand(s.state, "fantasy")[id] == 6, "Example demand six")
	finish(s)
	check(s.state.data.money == {"eur_cent": 4000, "fantasy_pfennig": 24000}, "Example 40 EUR / 240 S")
	check(s.state.data.prototypes.has(id), "Five normal sales retain prototype")
	visit(s, "fantasy", "shop")
	finish(s)
	check(s.state.data.money == {"eur_cent": 0, "fantasy_pfennig": 36000} and s.state.data.prototypes.has(id), "Partial sales: 0 EUR / 360 S, prototype retained")
	visit(s, "fantasy", "shop")
	finish(s)
	check(s.state.data.money == {"eur_cent": 0, "fantasy_pfennig": 40000} and not s.state.data.prototypes.has(id), "Liquidation: 0 EUR / 400 S")
	check(s.state.data.worlds.fantasy.display[0] == null and s.state.data.last_summary.sales[0].prototype_sold, "Liquidation empties exact slot and reports it")
	check(s.continue_game().is_empty() and s.state.data.money.fantasy_pfennig == 40000, "Complete trade survives reload")

	# Every supplier and material; stock is shared, and no seller funds are simulated.
	for world in GameState.WORLDS:
		var buyer := session()
		buyer.state.data.money = {"eur_cent": 100000, "fantasy_pfennig": 100000}
		for merchant in ["sawmill", "smith", "tailor"]:
			visit(buyer, world, merchant)
			var items := GameCatalog.materials_for(world, merchant)
			check(items.size() == 3, "Three goods: " + world + merchant)
			for material in items:
				var before: int = buyer.state.data.money[GameCatalog.currency(world)]
				check(buyer.buy_material(material, 2), "Buy two " + material)
				check(buyer.state.data.inventory.materials[material] == 2 and buyer.state.data.money[GameCatalog.currency(world)] == before - 2 * GameCatalog.material(material).base_price, "Exact debit " + material)
			finish(buyer)
		check(buyer.state.data.inventory.materials.size() == 9, "All local materials stored")

	# Learning, recipes, old quality, analysis and cross-world accessibility.
	var learning := session()
	proto(learning.state, "old", 1, "real")
	learning.state.data.inventory.materials = {"oak": 4, "magic_nails": 4, "cotton": 1}
	visit(learning, "real", "library")
	check(not learning.learn("analysis"), "Analysis only taught in fantasy")
	check(learning.learn("carpentry") and not learning.learn("carpentry"), "Learn once per visit")
	for recipe in ["side_table", "wooden_chest", "padded_chair"]:
		check(learning.buy_recipe(recipe) and not learning.buy_recipe(recipe), "Buy recipe once: " + recipe)
	check(learning.state.data.skills.carpentry == 2 and learning.state.data.prototypes.old.quality == 20, "Learning freezes existing quality")
	finish(learning)
	check(learning.state.data.prototypes.has("old") and learning.state.data.money.eur_cent == 2500, "Library charges recipes only, no shop sales")
	visit(learning, "fantasy", "library")
	check(learning.learn("analysis") and not learning.learn("carpentry"), "Analysis consumes today's learning")
	finish(learning)
	visit(learning, "fantasy", "shop")
	check(not learning.analyze("old"), "Inactive display inaccessible to analysis")
	check(learning.craft("padded_chair", ["oak", "magic_nails", "cotton"]), "Padded chair uses cloth")
	var padded: String = learning.state.data.inventory.prototype_ids[0]
	check(learning.state.data.prototypes[padded].quality == 22 and learning.analyze(padded), "New quality and free analysis")
	check(learning.analyze(padded) and learning.state.data.prototypes[padded].analyzed, "Analysis repeat is harmless")
	check(learning.craft("kitchen_chair", ["oak", "magic_nails"]) and learning.craft("side_table", ["oak", "magic_nails"]), "Multiple builds per visit")
	check(learning.exhibit(padded, 2, 999999), "Use third fixed slot")
	check(learning.withdraw(2) and learning.state.data.worlds.fantasy.display[2] == null, "Return through warehouse preserves empty slot")
	finish(learning)
	visit(learning, "real", "shop")
	check(learning.exhibit(padded, 1, 999999), "World transfer on later visit")
	check(learning.state.data.worlds.real.display[0].prototype_id == "old" and learning.state.data.worlds.real.display[1].prototype_id == padded, "Slots do not shift")
	finish(learning)
	var before_load := learning.state.data.duplicate(true)
	check(learning.continue_game().is_empty() and learning.state.data == before_load, "Rich trade state reloads exactly")
	visit(learning, "real", "library")
	learning.state.data.skills.carpentry = 10
	check(not learning.learn("carpentry"), "Learning cap")
	check(learning.continue_game().is_empty() and learning.state.data == before_load, "Discard restores skills and full boundary")

	# Shared budget, zero demand, dynamic costs and no inventory consumption.
	var multi := GameState.new()
	multi.data.money = {"eur_cent": 2000, "fantasy_pfennig": 2000}
	multi.data.inventory.materials = {"oak": 20, "magic_nails": 20}
	proto(multi, "first", 1)
	proto(multi, "second", 2, "fantasy", 1)
	var settled := TradeRules.settle(multi, "fantasy", {"first": 6, "second": 6})
	check(settled.state.data.money == {"eur_cent": 0, "fantasy_pfennig": 12000}, "Two slots: 0 EUR / 120 S, all revenue deferred")
	check(settled.rows[0].sold == 2 and settled.rows[1].prototype_sold, "Slot priority controls funding")
	check(settled.state.data.inventory == multi.data.inventory and multi.data.money.eur_cent == 2000, "Pure settlement, warehouse unchanged")
	settled = TradeRules.settle(multi, "fantasy", {"first": 6, "second": 0})
	check(settled.state.data.money.fantasy_pfennig == 8000 and settled.state.data.prototypes.has("second"), "Zero demand retains unfunded prototype")
	multi.data.worlds.real.prices.oak = 1200
	settled = TradeRules.settle(multi, "fantasy", {"first": 6, "second": 0})
	check(settled.rows[0].sold == 1 and settled.state.data.money.eur_cent == 800, "Current oak price changes funding")
	check(multi.data.prototypes.first.quality == 20, "Price change preserves quality")
	var no_sales := session()
	no_sales.state = multi.copy()
	visit(no_sales, "fantasy", "tailor")
	finish(no_sales)
	check(no_sales.state.data.money == multi.data.money and no_sales.state.data.prototypes.size() == 2, "Merchant visit does not settle active display")

	# Calibrated, deterministic, shared category demand with stable tie breaking.
	var market := GameState.new()
	proto(market, "a", 1)
	for pair in [[2500, 10], [4000, 6], [6000, 1], [8000, 0]]:
		market.data.worlds.fantasy.display[0].price_minor = pair[0]
		check(MarketRules.demand(market, "fantasy").a == pair[1], "Demand price " + str(pair[0]))
	market.data.worlds.fantasy.display[0].price_minor = 4000
	proto(market, "b", 2, "fantasy", 1)
	var doubled := MarketRules.demand(market, "fantasy")
	check(doubled.a == 3 and doubled.b == 3, "Identical offerings share six customers")
	market.data.worlds.fantasy.display.reverse()
	check(MarketRules.demand(market, "fantasy") == doubled, "Reordering slots does not change demand")
	check(MarketRules.demand(market, "fantasy") == MarketRules.demand(market, "fantasy"), "No demand randomness")
	market.data.worlds.fantasy.display = [market.data.worlds.fantasy.display[2], null, null]
	var previous := 33
	var monotonic := true
	for price in range(10, 10001, 10):
		market.data.worlds.fantasy.display[0].price_minor = price
		var count: int = MarketRules.demand(market, "fantasy").a
		monotonic = monotonic and count <= previous and count <= 32
		previous = count
	check(monotonic, "Price sensitivity and customer bounds across 1000 prices")
	for count in range(33):
		var allocation := MarketRules.allocate(count, [1.0, 1.0, 1.25, 0.0])
		check(allocation.reduce(func(sum: int, amount: int) -> int: return sum + amount, 0) == count and allocation[3] == 0, "Rounding conserves customers %d" % count)

	# Prices freeze during a visit and in the inactive world.
	var prices := session()
	for pair in [[1, 1000], [7, 1000], [8, 1100], [14, 1100], [15, 900], [22, 1000], [29, 1100]]:
		prices.state.data.worlds.real.day = pair[0]
		visit(prices, "real", "sawmill")
		check(prices.state.data.worlds.real.prices.oak == pair[1], "Oak price on day " + str(pair[0]))
		check(prices.state.data.worlds.fantasy.prices.magic_nails == 1000, "Inactive prices frozen")
		finish(prices)
	visit(prices, "fantasy", "shop")
	check(prices.state.data.worlds.real.prices.oak == 1100, "Other world production uses last published source price")
	finish(prices)

	_test_migration()
	_test_retry()
	for text in ["", "0", "-1", "1,234", "1e3", "NaN", "1.2.3", "10000000000,01"]:
		check(TradeView.parse_price(text) == -1, "Invalid price " + text)
	for pair in [["40", 4000], ["0,01", 1], ["5.5", 550], [" 12,34 ", 1234]]:
		check(TradeView.parse_price(pair[0]) == pair[1], "Exact minor units " + pair[0])
	var file := FileAccess.open(directory.path_join("report.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"passed": passed, "failed": failed}, "\t"))
	print("TRADE QA: %d passed, %d failed" % [passed.size(), failed.size()])
	quit(0 if failed.is_empty() else 1)

func _test_migration() -> void:
	var old := GameState.new().data
	old.format_version = 1
	old.erase("next_prototype_id")
	old.skills = {"carpentry": 8, "analysis": 2}
	old.inventory.materials = {"oak": 3, "magic_nails": 7}
	old.inventory.prototype_ids = ["stored"]
	old.prototypes = {"stored": {"recipe_id": "kitchen_chair", "material_ids": ["oak", "magic_nails"], "quality": 3.5}}
	for world in old.worlds.values():
		world.display = []
		world.erase("prices")
		world.erase("price_week")
	var saves := SaveService.new(directory.path_join("migration"))
	DirAccess.make_dir_recursive_absolute(saves.path.get_base_dir())
	var file := FileAccess.open(saves.path, FileAccess.WRITE)
	file.store_string(JSON.stringify(old))
	file.close()
	var bytes := FileAccess.get_file_as_bytes(saves.path)
	var loaded: Dictionary = saves.load_game()
	check(loaded.state != null, "Load format 1")
	if loaded.state != null:
		check(loaded.state.data.format_version == 2 and loaded.state.data.prototypes.stored.quality == 3.5 and loaded.state.data.skills.analysis == 2, "Migration preserves legacy quality and skills")
		check(loaded.state.data.worlds.real.display == [null, null, null] and loaded.state.data.inventory.materials == old.inventory.materials, "Migration adds slots without losing stock")
		check(FileAccess.get_file_as_bytes(saves.path) == bytes, "Loading never rewrites legacy file")
		check(saves.save_game(loaded.state).is_empty() and FileAccess.get_file_as_bytes(saves.path + ".bak") == bytes, "First new save preserves original legacy backup")
	var bad: Dictionary = old.duplicate(true)
	bad.inventory.materials["unknown"] = 1
	check(GameState.decode(bad).state == null, "Incompatible legacy material explained, not discarded")
	bad = old.duplicate(true)
	bad.prototypes.stored.quality = 0
	var zero: Dictionary = GameState.decode(bad)
	check(zero.state != null and TradeRules.limit(zero.state.data.prototypes.stored) == 100, "Legacy zero quality safely preserved")
	bad = GameState.new().data
	bad.worlds.real.erase("prices")
	check(not GameState.validate(bad).is_empty(), "Missing price table rejected")

func _test_retry() -> void:
	var saves := RejectSave.new(directory.path_join("retry"))
	var s := GameSession.new(saves)
	check(s.new_game(), "Retry initial save")
	s.state.data.inventory.materials = {"oak": 1, "magic_nails": 1}
	check(saves.save_game(s.state).is_empty(), "Save test materials")
	visit(s, "fantasy", "shop")
	check(s.craft("kitchen_chair", ["oak", "magic_nails"]) and s.exhibit("p000001", 0, 4000), "Prepare retry trade")
	check(s.end_round(), "Retry event")
	saves.reject = true
	var original := FileAccess.get_file_as_bytes(saves.path)
	check(not s.finish_event() and not s.finish_event(), "Repeated write failures")
	check(s.state.data.money.eur_cent == 10000 and s.state.data.worlds.fantasy.day == 1, "Uncommitted trade untouched by failed settlement")
	check(FileAccess.get_file_as_bytes(saves.path) == original, "Failed save leaves boundary bytes unchanged")
	check(not s.set_price(0, 1) and not s.withdraw(0), "Frozen event blocks trade commands")
	saves.reject = false
	check(s.finish_event(), "Retry saves prepared settlement")
	check(s.state.data.money == {"eur_cent": 5000, "fantasy_pfennig": 25000} and s.state.data.worlds.fantasy.day == 2, "Retry applies sales exactly once")
	check(not s.finish_event(), "No duplicate post-save settlement")
	check(s.next_round(), "Next retry day")
	visit(s, "fantasy", "shop")
	check(s.withdraw(0), "Unsaved withdrawal")
	check(s.continue_game().is_empty() and s.state.data.worlds.fantasy.display[0] != null, "Discard restores display")
