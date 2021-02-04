extends TextureButton

export(bool) var IS_SAVE_BUTTON = true

var save

signal overwrite_save(buttonInstance)
signal ask_delete(buttonInstance)

func showElements():
	$SaveFileName.set_bbcode(
		BBCodeGenerator.BBCodeWave(
			BBCodeGenerator.BBCodeCenter(
				BBCodeGenerator.BBCodeColor("Save file : ", "yellow") + 
				BBCodeGenerator.BBCodeColor(save.getSaveName(), "white"))))
	$Location.set_bbcode(
		BBCodeGenerator.BBCodeWave(
			BBCodeGenerator.BBCodeCenter(
				BBCodeGenerator.BBCodeColor("Location : ", "yellow") + 
				BBCodeGenerator.BBCodeColor(save.getLocation(), "white"))))
	$Time.set_bbcode(
		BBCodeGenerator.BBCodeWave(
			BBCodeGenerator.BBCodeCenter(
				BBCodeGenerator.BBCodeColor("Time : ", "yellow") + 
				BBCodeGenerator.BBCodeColor(save.getCurrentTime(), "white"))))

func matchesText(text):
	return save.getSaveName().match("*" + str(text) + "*")

func getSaveName():
	return save.getSaveName()

func overwriteFile(fileName):
	SaveFile.changeCurrentFileName(fileName)
	SaveFile.overwriteFile(save)

func deleteFile():
	SaveFile.deleteFile(save)
	hide()
	queue_free() # visually "deletes" the file

func _on_DeleteButton_pressed():
	emit_signal("ask_delete",self)

func _on_ExistingFile_pressed():
	if(IS_SAVE_BUTTON):
		emit_signal("overwrite_save", self)
	else:
		SaveFile.currentData.loadData(save.data)
		save.loadSave(get_tree())
