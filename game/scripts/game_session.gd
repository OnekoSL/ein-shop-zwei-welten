class_name GameSession
extends RefCounted
## The only entry point for day progression. Nothing commits before saving.

signal changed
signal save_failed(message: String)
signal action_failed(message: String)

enum Phase { WORLD_SELECTION, CITY_MAP, VISIT, EVENT, SUMMARY }

var state: GameState
var phase := Phase.WORLD_SELECTION
var world_id := ""
var location_id := ""
var saves: SaveService
var _busy := false
var learned_today := false
var notice := ""
var _day_start_money: Dictionary = {}
var _transactions: Array = []
var _pending: GameState


func _init(service: SaveService) -> void:
	saves = service


func _adopt(next_state: GameState) -> void:
	state = next_state
	phase = Phase.WORLD_SELECTION
	world_id = ""
	location_id = ""
	_reset_day()
	changed.emit()


func _reset_day() -> void:
	learned_today = false
	notice = ""
	_transactions = []
	_day_start_money = state.data.money.duplicate()
	_pending = null


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
	var week: int = (int(state.data.worlds[id].day) - 1) / 7
	state.data.worlds[id].price_week = week
	state.data.worlds[id].prices = GameCatalog.prices(id, week)
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
	if _pending == null:
		var settled := {"state": state.copy(), "rows": [], "costs": {"eur_cent": 0, "fantasy_pfennig": 0}, "income": {"eur_cent": 0, "fantasy_pfennig": 0}}
		if location_id == "shop":
			settled = TradeRules.settle(state, world_id)
		_pending = settled.state
		_pending.data.last_summary = {"world_id": world_id, "location_id": location_id, "day": state.data.worlds[world_id].day,
			"start_money": _day_start_money.duplicate(), "end_money": _pending.data.money.duplicate(),
			"transactions": _transactions.duplicate(true), "sales": settled.rows, "costs": settled.costs, "income": settled.income}
		_pending.data.worlds[world_id].day += 1
	var error := saves.save_game(_pending)
	_busy = false
	if not error.is_empty():
		save_failed.emit(error)
		return false
	state = _pending
	_pending = null
	phase = Phase.SUMMARY
	changed.emit()
	return true


func next_round() -> bool:
	if phase != Phase.SUMMARY:
		return false
	phase = Phase.WORLD_SELECTION
	world_id = ""
	location_id = ""
	_reset_day()
	changed.emit()
	return true


func has_unfinished_day() -> bool:
	return phase in [Phase.CITY_MAP, Phase.VISIT, Phase.EVENT]


func _reject(message: String) -> bool:
	action_failed.emit(message)
	return false


func _at(place: String) -> bool:
	return state != null and phase == Phase.VISIT and location_id == place and not _busy


func _accept(message: String) -> bool:
	notice = message
	changed.emit()
	return true


func buy_material(id: String, quantity: int) -> bool:
	var item := GameCatalog.material(id)
	if item.is_empty() or not _at(item.merchant) or item.world != world_id:
		return _reject("Dieses Material kannst du hier nicht kaufen.")
	if quantity < 1 or quantity > 1_000_000:
		return _reject("Wähle eine ganze Menge zwischen 1 und 1.000.000.")
	var currency := GameCatalog.currency(world_id)
	var amount: int = quantity * state.data.worlds[world_id].prices[id]
	if state.data.money[currency] < amount:
		return _reject("Für diesen Einkauf fehlen " + UiHelpers.money(amount - state.data.money[currency], world_id == "fantasy") + ".")
	var stock: int = state.data.inventory.materials.get(id, 0)
	if stock + quantity > GameState.MAX_VALUE:
		return _reject("Der Materialbestand ist zu groß.")
	state.data.money[currency] -= amount
	state.data.inventory.materials[id] = stock + quantity
	_transactions.append({"label": "%d × %s" % [quantity, item.name], "currency": currency, "amount": amount})
	return _accept("%d × %s liegt jetzt im gemeinsamen Lager." % [quantity, item.name])


func learn(skill: String) -> bool:
	if not _at("library") or learned_today:
		return _reject("Du kannst einmal pro Bibliotheksbesuch lernen.")
	if skill == "carpentry":
		if state.data.skills.carpentry >= 10:
			return _reject("Tischlern hat für diesen Prototyp bereits die höchste Stufe erreicht.")
		state.data.skills.carpentry += 1
	elif skill == "analysis":
		if world_id != "fantasy" or state.data.skills.analysis > 0:
			return _reject("Analyse ist hier nicht mehr erlernbar.")
		state.data.skills.analysis = 1
	else:
		return _reject("Diese Fähigkeit ist nicht verfügbar.")
	learned_today = true
	return _accept("Analyse erlernt. Du kannst eigene Exemplare in beiden Läden untersuchen." if skill == "analysis" else "Tischlern verbessert. Neue Exemplare verwenden deine neue Stufe.")


func buy_recipe(id: String) -> bool:
	if not _at("library") or not GameCatalog.RECIPES.has(id):
		return _reject("Dieses Rezept kannst du hier nicht erwerben.")
	if id in state.data.recipes:
		return _reject("Dieses Rezept kennst du bereits in beiden Welten.")
	var currency := GameCatalog.currency(world_id)
	var price: int = GameCatalog.RECIPES[id][world_id + "_price"]
	if state.data.money[currency] < price:
		return _reject("Für das Rezept fehlen " + UiHelpers.money(price - state.data.money[currency], world_id == "fantasy") + ".")
	state.data.money[currency] -= price
	state.data.recipes.append(id)
	_transactions.append({"label": "Rezept: " + GameCatalog.name_for(id), "currency": currency, "amount": price})
	return _accept("Das Rezept ist jetzt in beiden Welten bekannt.")


func craft(recipe_id: String, material_ids: Array) -> bool:
	if not _at("shop") or not recipe_id in state.data.recipes or not GameCatalog.materials_match(recipe_id, material_ids):
		return _reject("Wähle ein bekanntes Rezept und ein passendes Material je Gruppe.")
	for id in material_ids:
		if state.data.inventory.materials.get(id, 0) < 1:
			return _reject("Im Lager fehlt: " + GameCatalog.name_for(id))
	var order: int = state.data.next_prototype_id
	while state.data.prototypes.has("p%06d" % order):
		order += 1
	if order >= GameState.MAX_VALUE:
		return _reject("Der Exemplar-Zähler ist ausgeschöpft.")
	var id := "p%06d" % order
	for material_id in material_ids:
		state.data.inventory.materials[material_id] -= 1
		if state.data.inventory.materials[material_id] == 0:
			state.data.inventory.materials.erase(material_id)
	state.data.prototypes[id] = {"recipe_id": recipe_id, "material_ids": material_ids.duplicate(),
		"quality": TradeRules.quality(material_ids, state.data.skills.carpentry), "created_order": order, "analyzed": false}
	state.data.inventory.prototype_ids.append(id)
	state.data.next_prototype_id = order + 1
	return _accept(GameCatalog.name_for(recipe_id) + " · " + id + " wurde hergestellt und eingelagert.")


func exhibit(id: String, index: int, price: int) -> bool:
	if not _at("shop") or not id in state.data.inventory.prototype_ids or index < 0 or index >= 3:
		return _reject("Wähle ein Exemplar aus dem Lager und einen freien Platz.")
	if state.data.worlds[world_id].display[index] != null:
		return _reject("Dieser Platz ist belegt. Nimm das Exemplar zuerst ins Lager zurück.")
	if price < 1 or price > GameState.MAX_VALUE:
		return _reject("Gib einen positiven Preis mit höchstens zwei Nachkommastellen ein.")
	state.data.inventory.prototype_ids.erase(id)
	state.data.worlds[world_id].display[index] = {"prototype_id": id, "price_minor": price}
	return _accept("Exemplar auf Platz %d ausgestellt." % (index + 1))


func withdraw(index: int) -> bool:
	if not _at("shop") or index < 0 or index >= 3 or state.data.worlds[world_id].display[index] == null:
		return _reject("Dieser Auslagenplatz ist nicht verfügbar.")
	state.data.inventory.prototype_ids.append(state.data.worlds[world_id].display[index].prototype_id)
	state.data.worlds[world_id].display[index] = null
	return _accept("Das Exemplar liegt wieder im gemeinsamen Lager.")


func set_price(index: int, price: int) -> bool:
	if not _at("shop") or index < 0 or index >= 3 or state.data.worlds[world_id].display[index] == null:
		return _reject("Dieser Auslagenplatz ist nicht verfügbar.")
	if price < 1 or price > GameState.MAX_VALUE:
		return _reject("Gib einen positiven Preis mit höchstens zwei Nachkommastellen ein.")
	state.data.worlds[world_id].display[index].price_minor = price
	return _accept("Verkaufspreis aktualisiert.")


func analyze(id: String) -> bool:
	if not _at("shop") or state.data.skills.analysis < 1:
		return _reject("Lerne Analyse in der Fantasybibliothek.")
	var accessible: bool = id in state.data.inventory.prototype_ids
	for slot in state.data.worlds[world_id].display:
		if slot != null and slot.prototype_id == id:
			accessible = true
	if not accessible:
		return _reject("Dieses Exemplar ist in diesem Laden nicht zugänglich.")
	state.data.prototypes[id].analyzed = true
	return _accept("Die Werte dieses Exemplars sind jetzt sichtbar.")
