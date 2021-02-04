extends ConfirmationDialog

var button # instance of the button where the save is stored

# calls the function to overwrite the save in the button
func _on_OverwriteFilePopup_confirmed():
	button.overwriteFile($SaveFileName.get_text())
	button.showElements()
