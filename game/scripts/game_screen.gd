extends Control
## Views emit commands and only receive a snapshot of the persisted state.
signal world_requested(id: String)
signal visit_requested(id: String)
signal end_requested
signal finish_requested
signal next_requested
signal back_requested
signal trade_requested(action: String, arguments: Array)
signal refresh_requested
var state: GameState
var phase: GameSession.Phase
var world_id := ""
var location_id := ""
var _selected_location := ""
var _enter_button: Button
var _selection_label: Label
var learned_today := false
var notice := ""
var view_memory: Dictionary = {}
var trade_view: TradeView

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
	if view_memory.get("focus", "").is_empty():
		if is_instance_valid(trade_view):
			trade_view.focus_initial()
		else:
			UiHelpers.focus_first(%Content)

func remember_view() -> void:
	if is_instance_valid(trade_view):
		trade_view.remember_view()

func restore_view() -> void:
	if is_instance_valid(trade_view):
		trade_view.restore_view()

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
	var columns := _reading_columns()
	trade_view = TradeView.new()
	trade_view.name = "TradeView"
	trade_view.state = state
	trade_view.world_id = world_id
	trade_view.location_id = location_id
	trade_view.learned_today = learned_today
	trade_view.notice = notice
	trade_view.memory = view_memory
	trade_view.navigation = columns.sidebar
	trade_view.command_requested.connect(func(action: String, arguments: Array) -> void: trade_requested.emit(action, arguments))
	trade_view.refresh_requested.connect(func() -> void: refresh_requested.emit())
	columns.body.add_child(trade_view)
	_sidebar_actions(columns.sidebar, "Runde beenden", "EndRoundButton", func() -> void: end_requested.emit())

func _reading_columns() -> Dictionary:
	var split := HBoxContainer.new()
	split.name = "ReadingColumns"
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split.add_theme_constant_override("separation", 28)
	%Content.add_child(split)
	var sidebar := VBoxContainer.new()
	sidebar.name = "VisitSidebar"
	sidebar.custom_minimum_size.x = 300
	sidebar.add_theme_constant_override("separation", 12)
	split.add_child(sidebar)
	%ProgressLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	%ProgressLabel.reparent(sidebar)
	%Heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	%Heading.reparent(sidebar)
	var body := UiHelpers.column(split, 12)
	body.name = "ReadingBody"
	return {"sidebar": sidebar, "body": body}

func _sidebar_actions(sidebar: VBoxContainer, text: String, button_name: String, action: Callable) -> void:
	var space := Control.new()
	space.custom_minimum_size.y = 12
	space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sidebar.add_child(space)
	UiHelpers.button(sidebar, text, button_name, action)
	var footer := %BackButton.get_parent()
	var hint := footer.get_node("Hint") as Label
	%BackButton.reparent(sidebar)
	hint.reparent(sidebar)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	footer.hide()

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
	var columns := _reading_columns()
	UiHelpers.label(columns.sidebar, UiHelpers.WORLD_NAMES[last.world_id] + "\n" + UiHelpers.LOCATION_NAMES[last.location_id], 18, true)
	var scroll := ScrollContainer.new()
	scroll.name = "ReportScroll"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.follow_focus = true
	# Keyboard users can scroll long reports with the arrow keys.
	UiHelpers.keyboard_scroll(scroll)
	columns.body.add_child(scroll)
	var body := UiHelpers.column(scroll, 12)
	UiHelpers.label(body, UiHelpers.WORLD_NAMES[last.world_id] + " · " + UiHelpers.LOCATION_NAMES[last.location_id], 24)
	UiHelpers.label(body, "Endbestand: %s / %s" % [UiHelpers.money(state.data.money.eur_cent), UiHelpers.money(state.data.money.fantasy_pfennig, true)], 26)
	if last.has("start_money"):
		UiHelpers.label(body, "Tagesbeginn: %s / %s" % [UiHelpers.money(last.start_money.eur_cent), UiHelpers.money(last.start_money.fantasy_pfennig, true)], 18, true)
	for entry in last.get("transactions", []):
		UiHelpers.label(body, entry.label + " · Ausgabe: " + UiHelpers.money(entry.amount, entry.currency == "fantasy_pfennig"), 20)
	for sale in last.get("sales", []):
		var panel := PanelContainer.new()
		panel.theme_type_variation = &"ItemPanel"
		body.add_child(panel)
		var card := UiHelpers.column(panel, 6)
		UiHelpers.label(card, "Platz %d · %s" % [sale.slot, GameCatalog.name_for(sale.recipe_id)], 24)
		UiHelpers.label(card, "Nachfrage: %d · Tageslimit: %d · Vorfinanzierbar: %d" % [sale.demand, sale.limit, sale.affordable], 18)
		UiHelpers.label(card, "Prototyp verkauft – der Platz ist jetzt frei." if sale.prototype_sold else "%d zusätzliche Stücke verkauft · Prototyp bleibt erhalten." % sale.sold, 20)
		UiHelpers.label(card, "Materialkosten: %s + %s · Erlös: %s" % [UiHelpers.money(sale.costs.eur_cent), UiHelpers.money(sale.costs.fantasy_pfennig, true), UiHelpers.money(sale.revenue, last.world_id == "fantasy")], 18)
	if last.location_id != "shop":
		UiHelpers.label(body, "Dein eigener Laden war heute geschlossen.", 18, true)
	elif last.get("sales", []).is_empty():
		UiHelpers.label(body, "Die Auslage war leer. Heute gab es keine Verkäufe.", 20, true)
	UiHelpers.label(columns.sidebar, "Gespeichert\nNächster Tag: Unsere Welt %d / Fantasywelt %d" % [state.data.worlds.real.day, state.data.worlds.fantasy.day], 18, true)
	_sidebar_actions(columns.sidebar, "Nächste Runde", "NextRoundButton", func() -> void: next_requested.emit())
