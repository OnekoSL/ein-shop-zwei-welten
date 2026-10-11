class_name GameState
extends RefCounted
## Serializable domain data. UI nodes and the unfinished day never enter a save.

const FORMAT_VERSION := 1
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
		"skills": {"carpentry": 1},
		"recipes": ["kitchen_chair"],
		"worlds": {
			"real": {"day": 1, "display": []},
			"fantasy": {"day": 1, "display": []}
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


static func validate(value: Variant) -> String:
	if not value is Dictionary:
		return "Der Spielstand enthält kein gültiges Zustandsobjekt."
	if not is_integer(value.get("format_version"), 1) or value.format_version != FORMAT_VERSION:
		return "Diese Spielstandversion wird nicht unterstützt (benötigt: 1)."
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
	if not _id_list(value.get("recipes")):
		return "Die bekannten Rezepte sind ungültig."
	for skill in value.skills:
		if not _id(skill) or not is_integer(value.skills[skill]):
			return "Der Fähigkeitsstand ist ungültig."
	for prototype_id in value.prototypes:
		var prototype: Variant = value.prototypes[prototype_id]
		if not _id(prototype_id) or not prototype is Dictionary:
			return "Ein gebautes Exemplar ist ungültig."
		if not _id(prototype.get("recipe_id")) or not _id_list(prototype.get("material_ids")):
			return "Rezept oder Materialien eines Exemplars sind ungültig."
		var quality: Variant = prototype.get("quality")
		if not (quality is int or quality is float) or not is_finite(float(quality)) or quality < 0 or quality > MAX_VALUE:
			return "Die gespeicherte Qualität eines Exemplars ist ungültig."
	if value.worlds.size() != WORLDS.size():
		return "Der Spielstand muss genau zwei Welten enthalten."
	var owners: Dictionary = {}
	for prototype_id in value.inventory.prototype_ids:
		owners[prototype_id] = true
	for world_id in WORLDS:
		var world: Variant = value.worlds.get(world_id)
		if not world is Dictionary or not is_integer(world.get("day"), 1) or not world.get("display") is Array:
			return "Welttag oder Auslage ist ungültig: " + world_id
		for slot in world.display:
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
	return ""


static func from_data(value: Dictionary) -> GameState:
	assert(validate(value).is_empty())
	var result := GameState.new()
	result.data = value.duplicate(true)
	# JSON represents numbers without distinguishing integers and floats.
	for key in result.data.money:
		result.data.money[key] = int(result.data.money[key])
	for key in result.data.inventory.materials:
		result.data.inventory.materials[key] = int(result.data.inventory.materials[key])
	for key in result.data.skills:
		result.data.skills[key] = int(result.data.skills[key])
	for world in result.data.worlds.values():
		world.day = int(world.day)
		for slot in world.display:
			slot.price_minor = int(slot.price_minor)
	if not result.data.last_summary.is_empty():
		result.data.last_summary.day = int(result.data.last_summary.day)
	result.data.format_version = FORMAT_VERSION
	return result
