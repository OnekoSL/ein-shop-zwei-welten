extends Control
signal new_requested
signal continue_requested
signal restore_requested
signal quit_requested
var can_continue := false
var can_restore := false
var save_status := ""

func _ready() -> void:
	%VersionLabel.text = "Prototyp %s" % ProjectSettings.get_setting("application/config/version")
	%ContinueButton.disabled = not can_continue
	%ContinueButton.pressed.connect(func() -> void: continue_requested.emit())
	%StartButton.pressed.connect(func() -> void: new_requested.emit())
	%QuitButton.pressed.connect(func() -> void: quit_requested.emit())
	%SaveStatus.text = save_status
	%SaveStatus.visible = not save_status.is_empty()
	%RestoreButton.visible = can_restore
	%RestoreButton.pressed.connect(func() -> void: restore_requested.emit())
	UiHelpers.focus_first(self)
