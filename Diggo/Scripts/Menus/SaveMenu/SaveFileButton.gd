extends Button

export(bool) var IS_SAVE_BUTTON = true # true if it is a save button (false if load)

var save # save of the button (NOTE : is the save in saves in SaveFile, so both will be modified)

signal overwrite_save(buttonInstance) # signal to overwrite save in save menu
signal ask_delete(buttonInstance) # signal to ask for file deletion in save menu

# show the elements in button in save
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

# true if the save name matches the text
func matchesText(text):
	return save.getSaveName().match("*" + str(text) + "*")

# returns the save name
func getSaveName():
	return save.getSaveName()

# overwrites the save with new name 
func overwriteFile(fileName):
	SaveFile.changeCurrentFileName(fileName)
	SaveFile.overwriteFile(save)

# deletes the save
func deleteFile():
	SaveFile.deleteFile(save)
	hide()
	queue_free() # visually "deletes" the file

# when delete button pressed, send signal ask_delete to save menu
func _on_DeleteButton_pressed():
	emit_signal("ask_delete",self)

# when button pressed, either saves or loads the save
func _on_ExistingFile_pressed():
	if(IS_SAVE_BUTTON):
		emit_signal("overwrite_save", self)
	else:
		SaveFile.currentData.loadData(save.data)
		save.loadSave(get_tree())
