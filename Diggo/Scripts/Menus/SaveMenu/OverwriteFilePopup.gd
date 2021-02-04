extends ConfirmationDialog

var button

func _on_OverwriteFilePopup_confirmed():
	button.overwriteFile($SaveFileName.get_text())
	button.showElements()
