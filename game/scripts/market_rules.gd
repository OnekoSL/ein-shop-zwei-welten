class_name MarketRules
extends RefCounted
## Deterministic customer allocation. Display position never breaks demand ties.

static func competitors(world: String, category: String) -> Array:
	var recipe_id: String = GameCatalog.MARKET[category].recipe
	var base: int = GameCatalog.RECIPES[recipe_id][world + "_value"]
	return [
		{"name": "Alltagsmöbel", "recipe_id": recipe_id, "quality": 10, "value": 10 * base, "price": 10 * base},
		{"name": "Feine Möbel", "recipe_id": recipe_id, "quality": 30, "value": 30 * base, "price": 40 * base}
	]

static func attractiveness(offer: Dictionary, group: int, budget: int) -> float:
	if offer.price <= 0 or offer.price > budget:
		return 0.0
	var perceived: float = offer.value
	if group == 2:
		perceived *= offer.quality / 20.0
	var score := maxf(0.0, 2.0 * perceived / offer.price - 1.0)
	return score * score if group == 0 else score

static func allocate(count: int, weights: Array) -> Array[int]:
	var total := 0.0
	for weight in weights:
		total += weight
	var result: Array[int] = []
	var fractions: Array = []
	var remaining := count
	for index in weights.size():
		var expected: float = 0.0 if total == 0.0 else count * weights[index] / total
		result.append(floori(expected))
		remaining -= result[index]
		fractions.append({"index": index, "part": expected - result[index]})
	if total == 0.0:
		return result
	# Stable input order is the explicit tie breaker, with a tolerance for float noise.
	fractions.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.index < b.index if absf(a.part - b.part) < 0.000000001 else a.part > b.part)
	for index in remaining:
		result[fractions[index].index] += 1
	return result

static func demand(state: GameState, world: String) -> Dictionary:
	var result: Dictionary = {}
	var offers: Array = []
	for slot in state.data.worlds[world].display:
		if slot == null:
			continue
		var prototype: Dictionary = state.data.prototypes[slot.prototype_id]
		result[slot.prototype_id] = 0
		offers.append({"id": slot.prototype_id, "order": prototype.created_order,
			"category": GameCatalog.RECIPES[prototype.recipe_id].category, "quality": prototype.quality,
			"value": TradeRules.value(prototype, world), "price": slot.price_minor})
	offers.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.order < b.order)
	for category in GameCatalog.MARKET:
		var own: Array = offers.filter(func(offer: Dictionary) -> bool: return offer.category == category)
		if own.is_empty():
			continue
		var market: Dictionary = GameCatalog.MARKET[category]
		var rivals := competitors(world, category)
		for group in range(3):
			var weights: Array = []
			var best := 0.0
			for offer in own:
				var score := attractiveness(offer, group, market[world][group])
				weights.append(score)
				best = maxf(best, score)
			var stores := allocate(market.buyers[group], [1.0,
				attractiveness(rivals[0], group, market[world][group]),
				attractiveness(rivals[1], group, market[world][group]), best])
			var distribution := allocate(stores[3], weights)
			for index in own.size():
				result[own[index].id] += distribution[index]
	return result
