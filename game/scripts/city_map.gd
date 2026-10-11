class_name CityMap
extends Control

signal location_selected(id: String)

const POINTS := [Vector2(0.17, 0.32), Vector2(0.5, 0.32), Vector2(0.83, 0.32), Vector2(0.33, 0.81), Vector2(0.67, 0.81)]
var fantasy := false
var selected := ""
var _buttons: Array[Button] = []


func _ready() -> void:
	custom_minimum_size = Vector2(0, 280)
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	resized.connect(_layout)
	for id in GameState.LOCATIONS:
		var button := UiHelpers.button(self, UiHelpers.LOCATION_NAMES[id], "Map_" + id, _select.bind(id), true)
		button.add_theme_font_size_override("font_size", 20)
		_buttons.append(button)
	_layout.call_deferred()


func _select(id: String) -> void:
	selected = id
	for index in _buttons.size():
		_buttons[index].theme_type_variation = &"Button" if GameState.LOCATIONS[index] == id else &"SecondaryButton"
	queue_redraw()
	location_selected.emit(id)


func _layout() -> void:
	for index in _buttons.size():
		_buttons[index].size = Vector2(184, 52)
		_buttons[index].position = POINTS[index] * size - Vector2(92, 0)
	queue_redraw()


func _draw() -> void:
	var ground := Color("dedbcf") if not fantasy else Color("e0dce8")
	var road := Color("faf4df") if not fantasy else Color("f0e5ca")
	var roof := Color("426d5d") if not fantasy else Color("70658a")
	draw_style_box(_background(ground), Rect2(Vector2.ZERO, size))
	var junction := size * Vector2(0.5, 0.6)
	for point in POINTS:
		draw_line(junction, point * size, road, 18, true)
	# River and small groves give the map spatial structure without external assets.
	draw_polyline(PackedVector2Array([Vector2(0, size.y * 0.63), size * Vector2(0.2, 0.58), size * Vector2(0.42, 0.64), size * Vector2(0.73, 0.57), Vector2(size.x, size.y * 0.64)]), Color("92b4ac") if not fantasy else Color("afa0c5"), 10, true)
	draw_line(junction - Vector2(22, 0), junction + Vector2(22, 0), road, 28, true)
	for index in POINTS.size():
		var center: Vector2 = POINTS[index] * size - Vector2(0, 38)
		draw_rect(Rect2(center - Vector2(30, 10), Vector2(60, 44)), Color("fff8e7"))
		draw_colored_polygon(PackedVector2Array([center + Vector2(-40, -10), center + Vector2(0, -42), center + Vector2(40, -10)]), roof)
		draw_rect(Rect2(center + Vector2(-7, 10), Vector2(14, 24)), roof)
		if GameState.LOCATIONS[index] == selected:
			draw_circle(center + Vector2(39, -32), 8, Color("c7903d"))
	for point in [Vector2(0.06, 0.7), Vector2(0.93, 0.8), Vector2(0.33, 0.15), Vector2(0.67, 0.15)]:
		draw_circle(point * size, 14, roof.lightened(0.25))


func _background(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(18)
	return style
