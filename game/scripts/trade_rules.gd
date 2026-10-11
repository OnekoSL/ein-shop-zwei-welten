class_name TradeRules
extends RefCounted
## Pure calculations. Settlement works on a copy, never on the live session.

static func quality(material_ids: Array, skill: int) -> int:
	var sum := 0
	for id in material_ids:
		sum += GameCatalog.material(id).quality
	return roundi(float(sum) / material_ids.size()) + 2 * (skill - 1)

static func limit(prototype: Dictionary) -> int:
	return maxi(1, floori(GameCatalog.RECIPES[prototype.recipe_id].basis / maxf(1.0, prototype.quality)))

static func value(prototype: Dictionary, world: String) -> int:
	var amount: float = prototype.quality * GameCatalog.RECIPES[prototype.recipe_id][world + "_value"]
	for id in prototype.material_ids:
		var item := GameCatalog.material(id)
		if item.world != world:
			var tier: int = int(item.quality) / 10
			amount += tier * 500 if world == "fantasy" else (tier - 1) * 1000
	return roundi(amount)

static func costs(prototype: Dictionary, state: GameState) -> Dictionary:
	var result := {"eur_cent": 0, "fantasy_pfennig": 0}
	for id in prototype.material_ids:
		var item := GameCatalog.material(id)
		result[GameCatalog.currency(item.world)] += state.data.worlds[item.world].prices[id]
	return result

static func settle(state: GameState, world: String, demand_override: Dictionary = {}) -> Dictionary:
	var next := state.copy()
	var demand := MarketRules.demand(state, world) if demand_override.is_empty() else demand_override
	var budget: Dictionary = state.data.money.duplicate()
	var expense := {"eur_cent": 0, "fantasy_pfennig": 0}
	var income := {"eur_cent": 0, "fantasy_pfennig": 0}
	var rows: Array = []
	var currency := GameCatalog.currency(world)
	for index in range(3):
		var slot: Variant = state.data.worlds[world].display[index]
		if slot == null:
			continue
		var prototype: Dictionary = state.data.prototypes[slot.prototype_id]
		var unit_cost := costs(prototype, state)
		var affordable: int = GameState.MAX_VALUE
		for key in budget:
			if unit_cost[key] > 0:
				affordable = mini(affordable, int(budget[key]) / int(unit_cost[key]))
		var interested: int = demand.get(slot.prototype_id, 0)
		var maximum := limit(prototype)
		var count := mini(interested, mini(maximum, affordable))
		var sold_prototype := interested > 0 and affordable == 0
		var paid := {"eur_cent": 0, "fantasy_pfennig": 0}
		for key in budget:
			paid[key] = count * unit_cost[key]
			budget[key] -= paid[key]
			expense[key] += paid[key]
		var revenue: int = (1 if sold_prototype else count) * slot.price_minor
		income[currency] += revenue
		rows.append({"slot": index + 1, "prototype_id": slot.prototype_id, "recipe_id": prototype.recipe_id,
			"demand": interested, "limit": maximum, "affordable": affordable, "sold": count,
			"prototype_sold": sold_prototype, "costs": paid, "revenue": revenue, "price_minor": slot.price_minor})
		if sold_prototype:
			next.data.prototypes.erase(slot.prototype_id)
			next.data.worlds[world].display[index] = null
	# Receipts from every slot, including prototypes, become available only here.
	for key in budget:
		next.data.money[key] = budget[key] + income[key]
	return {"state": next, "rows": rows, "costs": expense, "income": income}
