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
	return NAMES.get(id, id.replace("_", " ").capitalize())


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
