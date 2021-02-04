extends ConfirmationDialog

func _on_SaveFileNamePopup_confirmed():
	SaveFile.changeCurrentFileName($SaveFileName.get_text())
	var save = SaveFile.newFile()
	get_parent().createButton(save,1)
