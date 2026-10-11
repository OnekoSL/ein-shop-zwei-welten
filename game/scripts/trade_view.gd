class_name TradeView
extends VBoxContainer
## Presentation only. All mutations are requested through GameSession commands.

signal command_requested(action: String, arguments: Array)
signal refresh_requested

var state: GameState
var world_id := ""
var location_id := ""
var learned_today := false
var notice := ""
var memory: Dictionary = {}
var _scroll: ScrollContainer
var _body: VBoxContainer

func _ready() -> void:
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 10)
	var subtitle := "Unsere Welt · Handwerk & Alltag" if world_id == "real" else "Fantasywelt · Magie & Möglichkeiten"
	UiHelpers.label(self, subtitle + " · Tag %d" % state.data.worlds[world_id].day, 18, true)
	if location_id == "shop":
		var tabs := HBoxContainer.new()
		tabs.add_theme_constant_override("separation", 8)
		add_child(tabs)
		for tab in ["Herstellen", "Lager", "Auslage", "Markt"]:
			var button := UiHelpers.button(tabs, tab, "Tab_" + tab, func() -> void:
				memory.tab = tab
				memory.scroll = 0
				memory.reset_scroll = true
				memory.focus = "Tab_" + tab
				refresh_requested.emit(), memory.get("tab", "Herstellen") != tab)
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if not notice.is_empty():
		var status := UiHelpers.label(self, notice, 18)
		status.name = "TradeNotice"
	_scroll = ScrollContainer.new()
	_scroll.name = "TradeScroll"
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.follow_focus = true
	UiHelpers.keyboard_scroll(_scroll)
	add_child(_scroll)
	_body = UiHelpers.column(_scroll, 12)
	_body.name = "TradeBody"
	match location_id:
		"library": _library()
		"shop":
			match memory.get("tab", "Herstellen"):
				"Herstellen": _crafting()
				"Lager": _warehouse()
				"Auslage": _display()
				"Markt": _market()
		_: _merchant()
	restore_view.call_deferred()

func remember_view() -> void:
	if is_instance_valid(_scroll):
		memory.scroll = 0 if memory.get("reset_scroll", false) else _scroll.scroll_vertical
		memory.erase("reset_scroll")
	var focus := get_viewport().gui_get_focus_owner()
	if focus != null and is_ancestor_of(focus):
		memory.focus = str(focus.get_parent().name) if focus.get_parent() is SpinBox else str(focus.name)

func restore_view() -> void:
	_scroll.scroll_vertical = int(memory.get("scroll", 0))
	var focus_name: String = memory.get("focus", "")
	if focus_name.is_empty():
		return
	var target := find_child(focus_name, true, false) as Control
	if target is SpinBox:
		target.get_line_edit().grab_focus()
	elif target != null and target.is_visible_in_tree() and not (target is BaseButton and target.disabled):
		target.grab_focus()
	else:
		var tab := find_child("Tab_" + str(memory.get("tab", "Herstellen")), true, false) as Button
		if tab != null:
			tab.grab_focus()
		else:
			UiHelpers.focus_first(self)

func _card(title: String) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.theme_type_variation = &"ItemPanel"
	_body.add_child(panel)
	if world_id == "fantasy":
		var style := panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
		style.bg_color = Color(0.978, 0.962, 0.99)
		style.border_color = Color(0.49, 0.40, 0.65)
		panel.add_theme_stylebox_override("panel", style)
	var body := UiHelpers.column(panel, 8)
	UiHelpers.label(body, title, 24)
	return body

func _row(parent: Node) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	parent.add_child(row)
	return row

func _price_text(amount: int) -> String:
	return "%d,%02d" % [amount / 100, amount % 100]

func _price_input(parent: Node, key: String, initial: String = "") -> LineEdit:
	var edit := LineEdit.new()
	edit.name = key
	var currency := "€" if world_id == "real" else "S"
	edit.placeholder_text = "Preis in " + currency
	edit.custom_minimum_size = Vector2(180, 48)
	edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	edit.max_length = 16
	edit.text = memory.get(key, initial)
	edit.text_changed.connect(func(value: String) -> void: memory[key] = value)
	parent.add_child(edit)
	var unit := UiHelpers.label(parent, currency)
	unit.autowrap_mode = TextServer.AUTOWRAP_OFF
	unit.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return edit

static func parse_price(text: String) -> int:
	var expression := RegEx.new()
	expression.compile("^[0-9]+([,.][0-9]{1,2})?$")
	var clean := text.strip_edges()
	if expression.search(clean) == null:
		return -1
	var parts := clean.replace(",", ".").split(".")
	if parts[0].length() > 11:
		return -1
	var amount := int(parts[0]) * 100
	if parts.size() == 2:
		amount += int(parts[1].rpad(2, "0"))
	return amount if amount >= 1 and amount <= GameState.MAX_VALUE else -1

func _select(parent: Node, key: String, choices: Array, labels: Array) -> OptionButton:
	var selector := OptionButton.new()
	selector.name = key
	selector.custom_minimum_size.y = 48
	selector.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	selector.fit_to_longest_item = false
	parent.add_child(selector)
	for index in choices.size():
		selector.add_item(labels[index])
		selector.set_item_metadata(index, choices[index])
		if memory.get(key) == choices[index]:
			selector.select(index)
	if choices.is_empty():
		selector.add_item("Nichts verfügbar")
		selector.disabled = true
	else:
		memory[key] = selector.get_selected_metadata()
	selector.item_selected.connect(func(_index: int) -> void: memory[key] = selector.get_selected_metadata())
	return selector

func _merchant() -> void:
	var greetings := {"sawmill": "Frisch zugeschnitten und bereit für deine Werkstatt.", "smith": "Gute Verbindungen beginnen mit dem richtigen Metall.", "tailor": "Ein schöner Bezug macht aus Holz einen Lieblingsplatz."}
	UiHelpers.label(_body, greetings[location_id], 20, true)
	for id in GameCatalog.materials_for(world_id, location_id):
		var item := GameCatalog.material(id)
		var price: int = state.data.worlds[world_id].prices[id]
		var card := _card(item.name)
		UiHelpers.label(card, item.description, 18, true)
		UiHelpers.label(card, "%s je Posten · Lager: %d · Unbegrenzt lieferbar" % [UiHelpers.money(price, world_id == "fantasy"), state.data.inventory.materials.get(id, 0)], 20)
		var row := _row(card)
		var quantity_label := UiHelpers.label(row, "Menge", 18)
		quantity_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		var quantity := SpinBox.new()
		quantity.name = "Quantity_" + id
		quantity.min_value = 1
		quantity.max_value = 1_000_000
		quantity.step = 1
		quantity.custom_minimum_size = Vector2(150, 48)
		quantity.value = memory.get(quantity.name, 1)
		row.add_child(quantity)
		quantity.value_changed.connect(func(value: float) -> void: memory[quantity.name] = int(value))
		var total := UiHelpers.label(row, UiHelpers.money(price * int(quantity.value), world_id == "fantasy"), 20)
		total.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		quantity.value_changed.connect(func(value: float) -> void: total.text = UiHelpers.money(price * int(value), world_id == "fantasy"))
		UiHelpers.button(row, "Kaufen", "Buy_" + id, func() -> void:
			quantity.apply()
			command_requested.emit("buy_material", [id, int(quantity.value)]))
	UiHelpers.label(_body, "Einkäufe gehen ins gemeinsame Lager. Heute bleibt dein eigener Laden geschlossen.", 18, true)

func _library() -> void:
	var learning := _card("Wissen für beide Welten")
	UiHelpers.label(learning, "Tischlern: Stufe %d / 10 · Analyse: %s" % [state.data.skills.carpentry, "bekannt" if state.data.skills.analysis > 0 else "noch unbekannt"], 20)
	UiHelpers.label(learning, "Heute bereits gelernt. Rezeptkäufe sind weiterhin möglich." if learned_today else "Einmal kostenlos lernen – zusätzlich beliebig viele neue Rezepte kaufen.", 18, true)
	var row := _row(learning)
	var carpentry := UiHelpers.button(row, "Tischlern verbessern", "LearnCarpentry", func() -> void: command_requested.emit("learn", ["carpentry"]))
	carpentry.disabled = learned_today or state.data.skills.carpentry >= 10
	if world_id == "fantasy":
		var analysis := UiHelpers.button(row, "Analyse erlernen", "LearnAnalysis", func() -> void: command_requested.emit("learn", ["analysis"]), true)
		analysis.disabled = learned_today or state.data.skills.analysis > 0
	else:
		UiHelpers.label(learning, "Die Magie Analyse wird in der Fantasybibliothek gelehrt.", 18, true)
	for id in ["side_table", "wooden_chest", "padded_chair"]:
		var recipe: Dictionary = GameCatalog.RECIPES[id]
		var card := _card(recipe.name)
		var groups: Array[String] = []
		for group in recipe.groups:
			groups.append(GameCatalog.GROUP_NAMES[group])
		UiHelpers.label(card, " + ".join(groups) + " · " + UiHelpers.money(recipe[world_id + "_price"], world_id == "fantasy"), 20)
		var known: bool = id in state.data.recipes
		var buy := UiHelpers.button(card, "In beiden Welten bekannt" if known else "Rezept kaufen", "Recipe_" + id, func() -> void: command_requested.emit("buy_recipe", [id]))
		buy.disabled = known

func _crafting() -> void:
	UiHelpers.label(_body, "Tischlern: Stufe %d · Jeder Bau verbraucht deine gewählten Materialposten." % state.data.skills.carpentry, 20, true)
	var card := _card("Ein neues Exemplar bauen")
	var ids: Array = state.data.recipes
	var labels: Array = []
	for id in ids:
		labels.append(GameCatalog.name_for(id))
	var recipe_selector := _select(card, "CraftRecipe", ids, labels)
	if ids.is_empty():
		UiHelpers.label(card, "Lerne zuerst ein Rezept in der Bibliothek.", 20)
		return
	recipe_selector.item_selected.connect(func(_index: int) -> void:
		memory.focus = "CraftRecipe"
		refresh_requested.emit())
	var recipe_id: String = recipe_selector.get_selected_metadata()
	var selectors: Array[OptionButton] = []
	var possible := true
	for group in GameCatalog.RECIPES[recipe_id].groups:
		UiHelpers.label(card, GameCatalog.GROUP_NAMES[group] + " · ein Posten", 18, true)
		var choices: Array = []
		var names: Array = []
		for material_row in GameCatalog.MATERIAL_ROWS:
			var id: String = material_row[0]
			if material_row[4] == group and state.data.inventory.materials.get(id, 0) > 0:
				choices.append(id)
				names.append("%s · %s · Lager: %d" % [material_row[1], UiHelpers.WORLD_NAMES[material_row[2]], state.data.inventory.materials[id]])
		selectors.append(_select(card, "Material_" + group, choices, names))
		possible = possible and not choices.is_empty()
	var build := UiHelpers.button(card, "Herstellen und einlagern", "CraftButton", func() -> void:
		var chosen: Array = []
		for selector in selectors:
			chosen.append(selector.get_selected_metadata())
		command_requested.emit("craft", [recipe_id, chosen]))
	build.disabled = not possible
	if not possible:
		UiHelpers.label(card, "Es fehlen passende Materialien. Sägewerk, Schmied und Schneider liefern ins gemeinsame Lager.", 18, true)
	else:
		UiHelpers.label(card, "Keine zusätzliche Geldgebühr. Das fertige Exemplar findest du unter Lager und Auslage.", 18, true)

func _prototype_details(parent: Node, id: String) -> void:
	var prototype: Dictionary = state.data.prototypes[id]
	var materials: Array[String] = []
	for material_id in prototype.material_ids:
		materials.append(GameCatalog.name_for(material_id))
	UiHelpers.label(parent, id + " · " + " + ".join(materials), 18, true)
	var costs := TradeRules.costs(prototype, state)
	UiHelpers.label(parent, "Je zusätzlichem Verkauf: %s + %s · Tageslimit: %d" % [UiHelpers.money(costs.eur_cent), UiHelpers.money(costs.fantasy_pfennig, true), TradeRules.limit(prototype)], 18)
	if prototype.analyzed:
		UiHelpers.label(parent, "Analyse · Wert: %s / %s" % [UiHelpers.money(TradeRules.value(prototype, "real")), UiHelpers.goldmark(TradeRules.value(prototype, "fantasy"))], 20)
	else:
		var analyze_button := UiHelpers.button(parent, "Exemplar analysieren", "Analyze_" + id, func() -> void: command_requested.emit("analyze", [id]), true)
		analyze_button.disabled = state.data.skills.analysis < 1
		if analyze_button.disabled:
			analyze_button.tooltip_text = "Analyse in der Fantasybibliothek erlernen."

func _warehouse() -> void:
	var materials := _card("Gemeinsamer Materialbestand")
	var lines: Array[String] = []
	for row in GameCatalog.MATERIAL_ROWS:
		if state.data.inventory.materials.has(row[0]):
			lines.append("%s × %d · %s" % [row[1], state.data.inventory.materials[row[0]], UiHelpers.WORLD_NAMES[row[2]]])
	UiHelpers.label(materials, "Noch keine Materialien eingelagert." if lines.is_empty() else "\n".join(lines), 20)
	for recipe_id in GameCatalog.RECIPES:
		var ids: Array = state.data.inventory.prototype_ids.filter(func(id: String) -> bool: return state.data.prototypes[id].recipe_id == recipe_id)
		if ids.is_empty():
			continue
		UiHelpers.label(_body, "%s · %d Exemplare" % [GameCatalog.name_for(recipe_id), ids.size()], 22)
		for id in ids:
			var card := _card(GameCatalog.name_for(recipe_id))
			_prototype_details(card, id)
	if state.data.inventory.prototype_ids.is_empty():
		UiHelpers.label(_body, "Keine gebauten Exemplare im Lager. Unter Herstellen kannst du eines bauen.", 20, true)
	UiHelpers.label(_body, "Zum Ausstellen öffne die Auslage und wähle einen freien Platz.", 18, true)

func _display() -> void:
	UiHelpers.label(_body, "Platz 1 erhält zuerst Produktionsgeld. Einnahmen werden erst nach allen Plätzen gutgeschrieben.", 18, true)
	for index in range(3):
		var slot: Variant = state.data.worlds[world_id].display[index]
		var card := _card("Platz %d · %s" % [index + 1, "Frei" if slot == null else GameCatalog.name_for(state.data.prototypes[slot.prototype_id].recipe_id)])
		if slot == null:
			var choices: Array = state.data.inventory.prototype_ids
			var labels: Array = []
			for id in choices:
				labels.append(GameCatalog.name_for(state.data.prototypes[id].recipe_id) + " · " + id)
			var selector := _select(card, "SlotChoice_%d" % index, choices, labels)
			var row := _row(card)
			var price := _price_input(row, "SlotPrice_%d" % index)
			var exhibit_button := UiHelpers.button(row, "Ausstellen", "Exhibit_%d" % index, func() -> void: command_requested.emit("exhibit", [selector.get_selected_metadata(), index, parse_price(price.text)]))
			exhibit_button.disabled = choices.is_empty()
		else:
			_prototype_details(card, slot.prototype_id)
			var row := _row(card)
			var price := _price_input(row, "OfferPrice_%d" % index, _price_text(slot.price_minor))
			UiHelpers.button(row, "Preis setzen", "Price_%d" % index, func() -> void: command_requested.emit("set_price", [index, parse_price(price.text)]))
			UiHelpers.button(row, "Ins Lager", "Withdraw_%d" % index, func() -> void: command_requested.emit("withdraw", [index]), true)
	UiHelpers.label(_body, "Ohne Geld für ein weiteres Stück kann bei Nachfrage der Prototyp selbst verkauft werden. Die Nachfrage erfährst du im Tagesabschluss.", 18, true)

func _market() -> void:
	UiHelpers.label(_body, "Drei Kundengruppen vergleichen deine Waren mit diesen Angeboten. Stühle und Polsterstühle teilen denselben Bedarf.", 20, true)
	for category in GameCatalog.MARKET:
		var card := _card(GameCatalog.CATEGORY_NAMES[category])
		for rival in MarketRules.competitors(world_id, category):
			UiHelpers.label(card, "%s · %s · %s" % [rival.name, GameCatalog.name_for(rival.recipe_id), UiHelpers.money(rival.price, world_id == "fantasy")], 20)
	UiHelpers.label(_body, "Diese Geschäfte halten ihr Sortiment und ihre Preise im ersten Handelstest fest.", 18, true)
