extends ConfirmationDialog

signal reload_buttons()

func _on_SaveFileNamePopup_confirmed():
	SaveFile.changeCurrentFileName($SaveFileName.get_text())
	SaveFile.newFile()
	SaveFile.save()
	emit_signal("reload_buttons")
