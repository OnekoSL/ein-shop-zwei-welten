class_name GameState
extends RefCounted
## Serializable domain data. UI nodes and the unfinished day never enter a save.

const FORMAT_VERSION := 2
const WORLDS := ["real", "fantasy"]
const LOCATIONS := ["shop", "smith", "sawmill", "tailor", "library"]
const MAX_VALUE := 1_000_000_000_000

var data: Dictionary


func _init() -> void:
	data = {
		"format_version": FORMAT_VERSION,
		"money": {"eur_cent": 10000, "fantasy_pfennig": 10000},
		"inventory": {"materials": {}, "prototype_ids": []},
		"prototypes": {},
		"skills": {"carpentry": 1, "analysis": 0},
		"next_prototype_id": 1,
		"recipes": ["kitchen_chair"],
		"worlds": {
			"real": {"day": 1, "display": [null, null, null], "price_week": 0, "prices": GameCatalog.prices("real", 0)},
			"fantasy": {"day": 1, "display": [null, null, null], "price_week": 0, "prices": GameCatalog.prices("fantasy", 0)}
		},
		"last_summary": {}
	}


func copy() -> GameState:
	var result := GameState.new()
	result.data = data.duplicate(true)
	return result


static func is_integer(value: Variant, minimum: int = 0) -> bool:
	return (value is int or value is float) and is_finite(float(value)) \
		and float(value) == floor(float(value)) and value >= minimum and value <= MAX_VALUE


static func _id(value: Variant) -> bool:
	return value is String and not value.strip_edges().is_empty()


static func _id_list(value: Variant) -> bool:
	if not value is Array:
		return false
	var seen: Dictionary = {}
	for entry in value:
		if not _id(entry) or seen.has(entry):
			return false
		seen[entry] = true
	return true


static func validate(value: Variant, legacy: bool = false) -> String:
	if not value is Dictionary:
		return "Der Spielstand enthält kein gültiges Zustandsobjekt."
	if not is_integer(value.get("format_version"), 1) or value.format_version != (1 if legacy else FORMAT_VERSION):
		return "Diese Spielstandversion wird nicht unterstützt (lesbar: 1 und 2)."
	for field in ["money", "inventory", "prototypes", "skills", "worlds", "last_summary"]:
		if not value.get(field) is Dictionary:
			return "Im Spielstand fehlt ein gültiger Bereich: " + field
	for currency in ["eur_cent", "fantasy_pfennig"]:
		if not is_integer(value.money.get(currency)):
			return "Der Spielstand enthält einen ungültigen Geldbestand."
	if not value.inventory.get("materials") is Dictionary or not _id_list(value.inventory.get("prototype_ids")):
		return "Der Lagerbestand ist ungültig."
	for material in value.inventory.materials:
		if not _id(material) or not is_integer(value.inventory.materials[material], 1):
			return "Der Materialbestand ist ungültig."
		if GameCatalog.material(material).is_empty():
			return "Unbekanntes Material im Spielstand: " + material
	if not _id_list(value.get("recipes")):
		return "Die bekannten Rezepte sind ungültig."
	for recipe in value.recipes:
		if not GameCatalog.RECIPES.has(recipe):
			return "Unbekanntes Rezept im Spielstand: " + recipe
	if not is_integer(value.skills.get("carpentry"), 1):
		return "Die Tischlerfähigkeit ist ungültig."
	if not legacy and (not is_integer(value.skills.get("analysis")) or not is_integer(value.get("next_prototype_id"), 1)):
		return "Analysefähigkeit oder Exemplar-Zähler fehlt."
	for skill in value.skills:
		if not _id(skill) or not is_integer(value.skills[skill]):
			return "Der Fähigkeitsstand ist ungültig."
	var creation_orders: Dictionary = {}
	for prototype_id in value.prototypes:
		var prototype: Variant = value.prototypes[prototype_id]
		if not _id(prototype_id) or not prototype is Dictionary:
			return "Ein gebautes Exemplar ist ungültig."
		if not _id(prototype.get("recipe_id")) or not _id_list(prototype.get("material_ids")):
			return "Rezept oder Materialien eines Exemplars sind ungültig."
		if not GameCatalog.materials_match(prototype.recipe_id, prototype.material_ids):
			return "Rezept und Materialien eines Exemplars sind nicht kompatibel."
		var quality: Variant = prototype.get("quality")
		if not (quality is int or quality is float) or not is_finite(float(quality)) or quality < 0 or quality > MAX_VALUE:
			return "Die gespeicherte Qualität eines Exemplars ist ungültig."
		if not legacy:
			if not prototype.get("analyzed") is bool or not is_integer(prototype.get("created_order"), 1):
				return "Analysefreigabe oder Erstellreihenfolge eines Exemplars fehlt."
			if creation_orders.has(prototype.created_order) or prototype.created_order >= value.next_prototype_id:
				return "Die Erstellreihenfolge der Exemplare ist ungültig."
			creation_orders[prototype.created_order] = true
	if value.worlds.size() != WORLDS.size():
		return "Der Spielstand muss genau zwei Welten enthalten."
	var owners: Dictionary = {}
	for prototype_id in value.inventory.prototype_ids:
		owners[prototype_id] = true
	for world_id in WORLDS:
		var world: Variant = value.worlds.get(world_id)
		if not world is Dictionary or not is_integer(world.get("day"), 1) or not world.get("display") is Array:
			return "Welttag oder Auslage ist ungültig: " + world_id
		if world.display.size() > 3 or (not legacy and world.display.size() != 3):
			return "Die Auslage benötigt drei Plätze; bestehende zusätzliche Plätze werden nicht gelöscht."
		if not legacy:
			if not is_integer(world.get("price_week")) or not world.get("prices") is Dictionary:
				return "Die Materialpreise der Welt fehlen: " + world_id
			var expected := GameCatalog.prices(world_id, 0)
			if world.prices.size() != expected.size():
				return "Die Materialpreisliste ist unvollständig."
			for material_id in expected:
				if not is_integer(world.prices.get(material_id), 1):
					return "Ungültiger Materialpreis: " + material_id
		for slot in world.display:
			if slot == null and not legacy:
				continue
			if not slot is Dictionary or not _id(slot.get("prototype_id")) or not is_integer(slot.get("price_minor")):
				return "Ein Auslagenplatz ist ungültig."
			if owners.has(slot.prototype_id):
				return "Ein Exemplar befindet sich an mehreren Orten."
			owners[slot.prototype_id] = true
	if owners.size() != value.prototypes.size():
		return "Die Zuordnung der gebauten Exemplare ist unvollständig."
	for prototype_id in owners:
		if not value.prototypes.has(prototype_id):
			return "Ein zugeordnetes Exemplar fehlt im Spielstand."
	var summary: Dictionary = value.last_summary
	if not summary.is_empty():
		if not summary.get("world_id") in WORLDS or not summary.get("location_id") in LOCATIONS or not is_integer(summary.get("day"), 1):
			return "Der letzte Tagesabschluss ist ungültig."
		if summary.day != value.worlds[summary.world_id].day - 1:
			return "Tageszähler und letzter Tagesabschluss stimmen nicht überein."
		if summary.has("transactions"):
			var report_error := _validate_report(summary)
			if not report_error.is_empty():
				return report_error
	return ""


static func _money_valid(value: Variant) -> bool:
	return value is Dictionary and is_integer(value.get("eur_cent")) and is_integer(value.get("fantasy_pfennig"))


static func _validate_report(report: Dictionary) -> String:
	for key in ["start_money", "end_money", "costs", "income"]:
		if not _money_valid(report.get(key)):
			return "Ungültige Geldbeträge im Handelsbericht."
	if not report.transactions is Array or not report.get("sales") is Array:
		return "Der Handelsbericht ist unvollständig."
	for entry in report.transactions:
		if not entry is Dictionary or not entry.get("label") is String or not entry.get("currency") in ["eur_cent", "fantasy_pfennig"] or not is_integer(entry.get("amount")):
			return "Eine Ausgabe im Handelsbericht ist ungültig."
	for entry in report.sales:
		if not entry is Dictionary:
			return "Ein Verkauf im Handelsbericht ist ungültig."
		for key in ["slot", "demand", "limit", "affordable", "sold", "revenue", "price_minor"]:
			if not is_integer(entry.get(key)):
				return "Eine Verkaufszahl im Handelsbericht ist ungültig."
		if not GameCatalog.RECIPES.has(entry.get("recipe_id")) or not entry.get("prototype_sold") is bool or not _money_valid(entry.get("costs")):
			return "Ein Verkauf im Handelsbericht ist unvollständig."
	return ""


static func decode(value: Variant) -> Dictionary:
	if not value is Dictionary:
		return {"state": null, "error": "Der Spielstand enthält kein gültiges Zustandsobjekt."}
	var legacy: bool = value.get("format_version") == 1
	var error := validate(value, legacy)
	if not error.is_empty():
		return {"state": null, "error": error}
	var migrated: Dictionary = value.duplicate(true)
	if legacy:
		migrated.format_version = FORMAT_VERSION
		migrated.skills["analysis"] = migrated.skills.get("analysis", 0)
		var order := 1
		for prototype in migrated.prototypes.values():
			prototype["created_order"] = order
			prototype["analyzed"] = false
			order += 1
		migrated["next_prototype_id"] = order
		for world_id in WORLDS:
			var world: Dictionary = migrated.worlds[world_id]
			while world.display.size() < 3:
				world.display.append(null)
			world["price_week"] = 0
			world["prices"] = GameCatalog.prices(world_id, 0)
		error = validate(migrated)
		if not error.is_empty():
			return {"state": null, "error": error}
	return {"state": from_data(migrated), "error": ""}


static func from_data(value: Dictionary) -> GameState:
	assert(validate(value).is_empty())
	var result := GameState.new()
	result.data = _normalize_numbers(value)
	# JSON represents numbers without distinguishing integers and floats.
	for key in result.data.money:
		result.data.money[key] = int(result.data.money[key])
	for key in result.data.inventory.materials:
		result.data.inventory.materials[key] = int(result.data.inventory.materials[key])
	for key in result.data.skills:
		result.data.skills[key] = int(result.data.skills[key])
	for world in result.data.worlds.values():
		world.day = int(world.day)
		world.price_week = int(world.price_week)
		for material_id in world.prices:
			world.prices[material_id] = int(world.prices[material_id])
		for slot in world.display:
			if slot != null:
				slot.price_minor = int(slot.price_minor)
	result.data.next_prototype_id = int(result.data.next_prototype_id)
	for prototype in result.data.prototypes.values():
		prototype.created_order = int(prototype.created_order)
	if not result.data.last_summary.is_empty():
		result.data.last_summary.day = int(result.data.last_summary.day)
	result.data.format_version = FORMAT_VERSION
	return result


static func _normalize_numbers(value: Variant) -> Variant:
	if value is Dictionary:
		var result: Dictionary = {}
		for key in value:
			result[key] = _normalize_numbers(value[key])
		return result
	if value is Array:
		var result: Array = []
		for entry in value:
			result.append(_normalize_numbers(entry))
		return result
	return int(value) if (value is float and is_integer(value)) else value
