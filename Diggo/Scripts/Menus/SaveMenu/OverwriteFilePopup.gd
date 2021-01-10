extends ConfirmationDialog

signal reload_buttons()

var button

func _on_OverwriteFilePopup_confirmed():
	button.overwriteFile($SaveFileName.get_text())
	emit_signal("reload_buttons")
