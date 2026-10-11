extends Control
## Views emit commands and only receive a snapshot of the persisted state.
signal world_requested(id: String)
signal visit_requested(id: String)
signal end_requested
signal finish_requested
signal next_requested
signal back_requested
var state: GameState
var phase: GameSession.Phase
var world_id := ""
var location_id := ""
var _selected_location := ""
var _enter_button: Button
var _selection_label: Label

func _ready() -> void:
	%MoneyLabel.text = "%s   /   %s" % [UiHelpers.money(state.data.money.eur_cent), UiHelpers.money(state.data.money.fantasy_pfennig, true)]
	%BackButton.pressed.connect(func() -> void: back_requested.emit())
	var phase_names := ["Weltwahl", "Stadtkarte", "Besuch", "Ereignis", "Tagesabschluss"]
	%ProgressLabel.text = "  ›  ".join(phase_names.slice(0, phase + 1))
	match phase:
		GameSession.Phase.WORLD_SELECTION: _world_selection()
		GameSession.Phase.CITY_MAP: _city_map()
		GameSession.Phase.VISIT: _visit()
		GameSession.Phase.EVENT: _event()
		GameSession.Phase.SUMMARY: _summary()
	UiHelpers.focus_first(%Content)

func _world_selection() -> void:
	%Heading.text = "Wo beginnt dein nächster Tag?"
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	%Content.add_child(row)
	for id in GameState.WORLDS:
		var card := UiHelpers.panel(row)
		UiHelpers.label(card, "ALLTAG & HANDWERK" if id == "real" else "MAGIE & MÖGLICHKEITEN", 16, true)
		UiHelpers.label(card, UiHelpers.WORLD_NAMES[id], 32)
		UiHelpers.label(card, "Tag %d" % state.data.worlds[id].day, 48)
		var space := Control.new()
		space.size_flags_vertical = Control.SIZE_EXPAND_FILL
		card.add_child(space)
		UiHelpers.label(card, "Ein neuer Tag für deinen Laden.\nDie andere Welt wartet auf dich.", 20, true)
		UiHelpers.button(card, "Welt wählen", "RealWorldButton" if id == "real" else "FantasyWorldButton", func() -> void: world_requested.emit(id))
	if not state.data.last_summary.is_empty():
		var last: Dictionary = state.data.last_summary
		UiHelpers.label(%Content, "Zuletzt: %s · Tag %d · %s" % [UiHelpers.WORLD_NAMES[last.world_id], last.day, UiHelpers.LOCATION_NAMES[last.location_id]], 18, true)

func _world_heading() -> String:
	return "%s · Tag %d" % [UiHelpers.WORLD_NAMES[world_id], state.data.worlds[world_id].day]

func _city_map() -> void:
	%Heading.text = _world_heading()
	var map := CityMap.new()
	map.name = "CityMap"
	map.fantasy = world_id == "fantasy"
	map.location_selected.connect(_select_location)
	%Content.add_child(map)
	var row := HBoxContainer.new()
	%Content.add_child(row)
	_selection_label = UiHelpers.label(row, "Wähle einen Ort für deinen heutigen Besuch.", 20, true)
	_selection_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_enter_button = UiHelpers.button(row, "Betreten", "EnterButton", func() -> void: visit_requested.emit(_selected_location))
	_enter_button.disabled = true

func _select_location(id: String) -> void:
	_selected_location = id
	_selection_label.text = UiHelpers.LOCATION_NAMES[id] + " · Dein einziger Ortsbesuch heute"
	_enter_button.disabled = false

func _visit() -> void:
	%Heading.text = UiHelpers.LOCATION_NAMES[location_id]
	var body := UiHelpers.panel(%Content)
	UiHelpers.label(body, _world_heading(), 18, true)
	var descriptions := {
		"shop": "Dein Laden verbindet zwei Welten. Hier behältst du deine Bestände im Blick.",
		"smith": "Aus der Schmiede klingt das Hämmern auf Metall. Hier findest du bald Nägel und Beschläge.",
		"sawmill": "Es duftet nach frischem Holz. Hier findest du bald die Grundlage für deine Möbel.",
		"tailor": "Stoffe und Muster füllen die Regale. Hier findest du bald Bezüge für gepolsterte Möbel.",
		"library": "Zwischen den Bücherregalen wartet neues Wissen. Hier kannst du bald lernen und Rezepte erwerben."
	}
	UiHelpers.label(body, descriptions[location_id], 24)
	if location_id == "shop":
		_inventory(body)
	else:
		var space := Control.new()
		space.size_flags_vertical = Control.SIZE_EXPAND_FILL
		body.add_child(space)
		UiHelpers.label(body, "Die Angebote dieses Ortes folgen im nächsten Ausbau.", 20, true)
	UiHelpers.button(%Content, "Runde beenden", "EndRoundButton", func() -> void: end_requested.emit())

func _inventory(parent: Node) -> void:
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 32)
	grid.add_theme_constant_override("v_separation", 16)
	scroll.add_child(grid)
	var warehouse: Array[String] = []
	for material in state.data.inventory.materials:
		warehouse.append("%s × %d" % [UiHelpers.display_name(material), state.data.inventory.materials[material]])
	for id in state.data.inventory.prototype_ids:
		warehouse.append(UiHelpers.display_name(state.data.prototypes[id].recipe_id))
	_inventory_section(grid, "Gemeinsames Lager", "Leer" if warehouse.is_empty() else "\n".join(warehouse))
	var display: Array[String] = []
	for slot in state.data.worlds[world_id].display:
		display.append("%d. %s · %s" % [display.size() + 1, UiHelpers.display_name(state.data.prototypes[slot.prototype_id].recipe_id), UiHelpers.money(slot.price_minor, world_id == "fantasy")])
	_inventory_section(grid, "Auslage · " + UiHelpers.WORLD_NAMES[world_id], "Leer" if display.is_empty() else "\n".join(display))
	var skills: Array[String] = []
	for id in state.data.skills:
		skills.append("%s: %d" % [UiHelpers.display_name(id), state.data.skills[id]])
	_inventory_section(grid, "Gemeinsame Fähigkeiten", "Keine" if skills.is_empty() else "\n".join(skills))
	var recipes: Array[String] = []
	for id in state.data.recipes:
		recipes.append(UiHelpers.display_name(id))
	_inventory_section(grid, "Bekannte Rezepte", "Keine" if recipes.is_empty() else "\n".join(recipes))

func _inventory_section(parent: Node, title: String, text: String) -> void:
	var section := UiHelpers.column(parent, 4)
	UiHelpers.label(section, title, 18, true)
	UiHelpers.label(section, text, 20)

func _event() -> void:
	%Heading.text = "Der Tag klingt aus"
	var body := UiHelpers.panel(%Content)
	UiHelpers.label(body, _world_heading(), 18, true)
	body.alignment = BoxContainer.ALIGNMENT_CENTER
	UiHelpers.label(body, "Ein ruhiger Abend", 36)
	UiHelpers.label(body, "Die Straßen werden still. Heute gibt es keine außergewöhnlichen Vorkommnisse.", 24, true)
	UiHelpers.button(%Content, "Weiter zum Tagesabschluss", "FinishEventButton", func() -> void: finish_requested.emit())

func _summary() -> void:
	var last: Dictionary = state.data.last_summary
	%Heading.text = "Tag %d abgeschlossen" % last.day
	var body := UiHelpers.panel(%Content)
	UiHelpers.label(body, UiHelpers.WORLD_NAMES[last.world_id], 32)
	UiHelpers.label(body, "Heute besucht: " + UiHelpers.LOCATION_NAMES[last.location_id], 24)
	UiHelpers.label(body, "Deine Geldbestände sind unverändert.\n%s   /   %s" % [UiHelpers.money(state.data.money.eur_cent), UiHelpers.money(state.data.money.fantasy_pfennig, true)], 22, true)
	var space := Control.new()
	space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(space)
	UiHelpers.label(body, "Gespeichert · Nächster Tag: Unsere Welt %d / Fantasywelt %d" % [state.data.worlds.real.day, state.data.worlds.fantasy.day], 18, true)
	UiHelpers.button(%Content, "Nächste Runde", "NextRoundButton", func() -> void: next_requested.emit())
