class_name DecisionDialog
extends Control
## An in-window modal, including on exported builds. Cancel always gets focus.

var _accept: Callable
var _cancel: Callable
var _previous_focus: Control


func setup(message: String, accept_text: String, accept: Callable, cancel_text: String = "Abbrechen", cancel: Callable = Callable()) -> void:
	_accept = accept
	_cancel = cancel
	_previous_focus = get_viewport().gui_get_focus_owner()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var shade := ColorRect.new()
	shade.color = Color(0.06, 0.12, 0.11, 0.72)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(650, 0)
	center.add_child(panel)
	var body := UiHelpers.column(panel, 24)
	var description := UiHelpers.label(body, message, 24)
	description.custom_minimum_size.x = 570
	var buttons := HBoxContainer.new()
	body.add_child(buttons)
	var cancel_button := UiHelpers.button(buttons, cancel_text, "DialogCancel", _on_cancel, true)
	var accept_button := UiHelpers.button(buttons, accept_text, "DialogAccept", _on_accept)
	cancel_button.focus_next = cancel_button.get_path_to(accept_button)
	cancel_button.focus_previous = cancel_button.get_path_to(accept_button)
	accept_button.focus_next = accept_button.get_path_to(cancel_button)
	accept_button.focus_previous = accept_button.get_path_to(cancel_button)
	cancel_button.grab_focus.call_deferred()


func _dismiss() -> void:
	get_parent().remove_child(self)
	queue_free()
	if is_instance_valid(_previous_focus) and _previous_focus.is_inside_tree():
		_previous_focus.grab_focus()


func _on_cancel() -> void:
	_dismiss()
	if _cancel.is_valid():
		_cancel.call()


func _on_accept() -> void:
	_dismiss()
	if _accept.is_valid():
		_accept.call()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_cancel()
