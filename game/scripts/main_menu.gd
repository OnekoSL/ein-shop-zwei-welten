extends Control

signal start_requested
signal quit_requested

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	%VersionLabel.text = "Prototyp %s" % ProjectSettings.get_setting("application/config/version")
	start_button.pressed.connect(func() -> void: start_requested.emit())
	quit_button.pressed.connect(func() -> void: quit_requested.emit())
	start_button.grab_focus.call_deferred()
