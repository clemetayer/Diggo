extends ConfirmationDialog

var button

func _on_EraseSavePopup_confirmed():
	button.deleteFile()
