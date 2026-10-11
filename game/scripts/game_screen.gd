extends Control

signal back_requested


func _ready() -> void:
	%BackButton.pressed.connect(func() -> void: back_requested.emit())
	%BackButton.grab_focus.call_deferred()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel") and not event.is_echo():
		get_viewport().set_input_as_handled()
		back_requested.emit()
