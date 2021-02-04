extends ConfirmationDialog

var button # Instance of the button containing the save

# executes the deleteFile function in button
func _on_EraseSavePopup_confirmed():
	button.deleteFile()
