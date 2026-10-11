class_name GameCatalog
extends RefCounted
## Test balance in minor currency units. IDs and source currencies are stable.

const MATERIAL_ROWS := [
	["pine", "Kiefernholz", "real", "sawmill", "wood", 500, 10, "Leichtes Holz für einfache Alltagsmöbel."],
	["oak", "Eichenholz", "real", "sawmill", "wood", 1000, 20, "Kräftige Maserung und ein vertrauter Werkstoff."],
	["beech", "Buchenholz", "real", "sawmill", "wood", 1500, 30, "Feines, festes Holz für sorgfältige Arbeiten."],
	["real_iron_nails", "Eisennägel", "real", "smith", "nails", 300, 10, "Einfache Verbindungen für deine Werkstatt."],
	["steel_nails", "Stahlnägel", "real", "smith", "nails", 600, 20, "Zuverlässige Nägel aus gehärtetem Stahl."],
	["stainless_nails", "Edelstahlnägel", "real", "smith", "nails", 1200, 30, "Beständige Verbindungen mit sauberer Oberfläche."],
	["linen", "Leinen", "real", "tailor", "fabric", 400, 10, "Ein schlichter, griffiger Möbelbezug."],
	["cotton", "Baumwollstoff", "real", "tailor", "fabric", 700, 20, "Weicher Stoff für behagliche Sitzplätze."],
	["velvet", "Samt", "real", "tailor", "fabric", 1500, 30, "Satter Glanz für besondere Möbelstücke."],
	["spruce", "Fichtenholz", "fantasy", "sawmill", "wood", 400, 10, "Helles Holz aus den nahen Wäldern."],
	["ironwood", "Eisenholz", "fantasy", "sawmill", "wood", 1400, 20, "Schweres Holz, das dem Werkzeug einiges abverlangt."],
	["moonwood", "Mondholz", "fantasy", "sawmill", "wood", 2400, 30, "Seine feine Maserung schimmert im Abendlicht."],
	["fantasy_iron_nails", "Eisennägel", "fantasy", "smith", "nails", 400, 10, "Solide Nägel aus der örtlichen Schmiede."],
	["magic_nails", "Magische Nägel", "fantasy", "smith", "nails", 1000, 20, "Ein leises Summen begleitet jeden Hammerschlag."],
	["rune_nails", "Runennägel", "fantasy", "smith", "nails", 1800, 30, "Winzige Runen ziehen sich über das Metall."],
	["wool", "Wollstoff", "fantasy", "tailor", "fabric", 300, 10, "Ein warmer und robuster Bezug."],
	["spider_silk", "Spinnenseide", "fantasy", "tailor", "fabric", 900, 20, "Erstaunlich feste Fäden, sorgsam verwebt."],
	["fairy_silk", "Feenseide", "fantasy", "tailor", "fabric", 2200, 30, "Ein Stoff, der beinahe schwerelos erscheint."]
]
const RECIPES := {
	"kitchen_chair": {"name": "Küchenstuhl", "groups": ["wood", "nails"], "category": "chairs", "basis": 100, "real_value": 200, "fantasy_value": 150, "real_price": 0, "fantasy_price": 0},
	"side_table": {"name": "Beistelltisch", "groups": ["wood", "nails"], "category": "tables", "basis": 80, "real_value": 250, "fantasy_value": 200, "real_price": 1500, "fantasy_price": 1200},
	"wooden_chest": {"name": "Holztruhe", "groups": ["wood", "nails"], "category": "chests", "basis": 60, "real_value": 300, "fantasy_value": 250, "real_price": 2500, "fantasy_price": 2000},
	"padded_chair": {"name": "Polsterstuhl", "groups": ["wood", "nails", "fabric"], "category": "chairs", "basis": 80, "real_value": 350, "fantasy_value": 300, "real_price": 3500, "fantasy_price": 3000}
}
const GROUP_NAMES := {"wood": "Holz", "nails": "Nägel", "fabric": "Stoff"}
const CATEGORY_NAMES := {"chairs": "Stühle", "tables": "Tische", "chests": "Truhen"}
const MARKET := {
	"chairs": {"buyers": [12, 12, 8], "real": [2500, 6000, 16000], "fantasy": [2000, 5000, 12000], "recipe": "kitchen_chair"},
	"tables": {"buyers": [8, 8, 4], "real": [3000, 8000, 20000], "fantasy": [2500, 7000, 16000], "recipe": "side_table"},
	"chests": {"buyers": [6, 6, 4], "real": [4000, 10000, 24000], "fantasy": [3000, 9000, 20000], "recipe": "wooden_chest"}
}
const PRICE_CYCLES := {"sawmill": [110, 90, 100], "smith": [90, 100, 110], "tailor": [100, 110, 90]}

static func material(id: String) -> Dictionary:
	for row in MATERIAL_ROWS:
		if row[0] == id:
			return {"id": row[0], "name": row[1], "world": row[2], "merchant": row[3], "group": row[4], "base_price": row[5], "quality": row[6], "description": row[7]}
	return {}

static func materials_for(world: String, merchant: String) -> Array[String]:
	var result: Array[String] = []
	for row in MATERIAL_ROWS:
		if row[2] == world and row[3] == merchant:
			result.append(row[0])
	return result

static func currency(world: String) -> String:
	return "eur_cent" if world == "real" else "fantasy_pfennig"

static func prices(world: String, week: int) -> Dictionary:
	var result: Dictionary = {}
	for row in MATERIAL_ROWS:
		if row[2] == world:
			var factor: int = 100 if week == 0 else PRICE_CYCLES[row[3]][(week - 1) % 3]
			result[row[0]] = roundi(row[5] * factor / 100.0)
	return result

static func name_for(id: String) -> String:
	if RECIPES.has(id):
		return RECIPES[id].name
	var item := material(id)
	return item.name if not item.is_empty() else id

static func materials_match(recipe_id: String, ids: Array) -> bool:
	if not RECIPES.has(recipe_id) or ids.size() != RECIPES[recipe_id].groups.size():
		return false
	var groups: Array = []
	for id in ids:
		var item := material(str(id))
		if item.is_empty() or item.group in groups:
			return false
		groups.append(item.group)
	for group in RECIPES[recipe_id].groups:
		if not group in groups:
			return false
	return true
