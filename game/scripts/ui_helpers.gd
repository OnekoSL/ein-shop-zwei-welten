class_name UiHelpers
extends RefCounted

const WORLD_NAMES := {"real": "Unsere Welt", "fantasy": "Fantasywelt"}
const LOCATION_NAMES := {"shop": "Eigener Laden", "smith": "Schmied", "sawmill": "Sägewerk", "tailor": "Schneider", "library": "Bibliothek"}
const NAMES := {"kitchen_chair": "Küchenstuhl", "carpentry": "Tischlerei", "oak": "Eichenholz", "magic_nails": "Magische Nägel"}


static func label(parent: Node, text: String, size: int = 22, muted: bool = false) -> Label:
	var result := Label.new()
	result.text = text
	result.add_theme_font_size_override("font_size", size)
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if muted:
		result.theme_type_variation = &"MutedLabel"
	parent.add_child(result)
	return result


static func button(parent: Node, text: String, node_name: String, callback: Callable, secondary: bool = false) -> Button:
	var result := Button.new()
	result.name = node_name
	result.text = text
	result.custom_minimum_size.y = 52
	if secondary:
		result.theme_type_variation = &"SecondaryButton"
	result.pressed.connect(callback)
	parent.add_child(result)
	return result


static func column(parent: Node, spacing: int = 16) -> VBoxContainer:
	var result := VBoxContainer.new()
	result.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result.add_theme_constant_override("separation", spacing)
	parent.add_child(result)
	return result


static func panel(parent: Node) -> VBoxContainer:
	var background := PanelContainer.new()
	background.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	background.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(background)
	return column(background)


static func display_name(id: String) -> String:
	return NAMES.get(id, GameCatalog.name_for(id))


static func goldmark(value: int) -> String:
	return "%d,%04d Goldmark (%s)" % [value / 10000, value % 10000, money(value, true)]


static func money(value: int, fantasy: bool = false) -> String:
	if fantasy:
		@warning_ignore("integer_division")
		var silver := value / 100
		return "%d S · %02d Pf" % [silver, value % 100]
	@warning_ignore("integer_division")
	var euros := value / 100
	return "%d,%02d €" % [euros, value % 100]


static func focus_first(root: Node) -> void:
	for node in root.find_children("*", "Button", true, false):
		if node.is_visible_in_tree() and not node.disabled:
			node.grab_focus.call_deferred()
			return


static func keyboard_scroll(scroll: ScrollContainer) -> void:
	scroll.focus_mode = Control.FOCUS_ALL
	scroll.focus_entered.connect(scroll.queue_redraw)
	scroll.focus_exited.connect(scroll.queue_redraw)
	scroll.draw.connect(func() -> void:
		if scroll.has_focus():
			scroll.draw_rect(Rect2(Vector2(3, 3), scroll.size - Vector2(6, 6)), Color(0.73, 0.46, 0.15), false, 3.0))
	scroll.gui_input.connect(func(event: InputEvent) -> void:
		if not scroll.has_focus() or not event is InputEventKey or not event.pressed:
			return
		match event.keycode:
			KEY_DOWN: scroll.scroll_vertical += 64
			KEY_UP: scroll.scroll_vertical -= 64
			KEY_PAGEDOWN: scroll.scroll_vertical += int(scroll.size.y)
			KEY_PAGEUP: scroll.scroll_vertical -= int(scroll.size.y)
			KEY_HOME: scroll.scroll_vertical = 0
			KEY_END: scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
			_: return
		scroll.accept_event())
