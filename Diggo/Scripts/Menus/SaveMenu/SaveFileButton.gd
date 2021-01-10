extends Control

export(bool) var IS_SAVE_MENU = true

var save
var index

signal overwrite_save(buttonInstance)
signal new_file()
signal ask_delete(buttonInstance)

func showElements():
	if(save.isNewFile()):
		if(IS_SAVE_MENU):
			get_node("ExistingFile").hide()
			get_node("NewFile").show()
		else:
			queue_free()
	else:
		get_node("NewFile").hide()
		get_node("ExistingFile").show()
		get_node("ExistingFile/SaveFileName").set_bbcode(BBCodeWave(BBCodeCenter(BBCodeColor("Save file : ", "yellow") + BBCodeColor(save.getSaveName(), "white"))))
		get_node("ExistingFile/Location").set_bbcode(BBCodeWave(BBCodeCenter(BBCodeColor("Location : ", "yellow") + BBCodeColor(save.getLocation(), "white"))))
		get_node("ExistingFile/Time").set_bbcode(BBCodeWave(BBCodeCenter(BBCodeColor("Time : ", "yellow") + BBCodeColor(save.getCurrentTime(), "white"))))

func isNewFileButton():
	return(save.isNewFile())

func matchesText(text):
	return save.getSaveName().match("*" + str(text) + "*")

func BBCodeColor(string, color):
	return("[color=" + color + "]" + string + "[/color]")

func BBCodeCenter(string):
	return("[center]" + string + "[/center]")

func BBCodeWave(string,amp=50,freq=2):
	return("[wave amp=" + str(amp) + " freq=" + str(freq) + "]" + string + "[/wave]")

func getSaveName():
	return save.getSaveName()

func overwriteFile(fileName):
	SaveFile.changeCurrentFileName(fileName)
	SaveFile.overwriteFile(index)
	SaveFile.save()
	hide()
	queue_free() # visually "deletes" the file

func deleteFile():
	SaveFile.deleteFile(index)
	SaveFile.save()
	hide()
	queue_free() # visually "deletes" the file

func _on_NewFile_pressed():
	emit_signal("new_file")

func _on_DeleteButton_pressed():
	emit_signal("ask_delete",self)

func _on_ExistingFile_pressed():
	if(IS_SAVE_MENU):
		emit_signal("overwrite_save", self)
	else:
		SaveFile.loadSave(get_tree(),index)
