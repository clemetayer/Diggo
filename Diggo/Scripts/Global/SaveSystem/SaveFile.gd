extends Node

const SAVE_PATH = "user://diggo-save-data.json"
const SAVE_DATA_LOAD = preload("res://Scripts/Global/SaveSystem/SaveData.gd")

var saves = []
var currentData
var startPlayTime

func _ready():
	initStartPlayTime()
	loadSaves()
	currentData = SAVE_DATA_LOAD.new()
	currentData.newFile("current")

func initStartPlayTime():
	startPlayTime = OS.get_unix_time()

func updateSaveTime():
	var currentTime = OS.get_unix_time()
	var diffTime = currentTime - startPlayTime
	currentData.updateTime(diffTime)
	startPlayTime = currentTime

func newFile():
	updateSaveTime()
	var saveDataInstance = SAVE_DATA_LOAD.new()
	saveDataInstance.loadData(currentData.data);
	saves.push_front(saveDataInstance)
	save()
	return saveDataInstance

func overwriteFile(save):
	updateSaveTime()
	save.loadData(currentData.data)
	save()

func deleteFile(save):
	save.queue_free()
	yield(GlobalUtils.wait(0.1),"completed")
	save()

func loadCurrentSave(sceneTree):
	currentData.loadSave(sceneTree)

func changeCurrentFileName(name):
	currentData.changeName(name)

func save():
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	var saveJson = {"saves":[]}
	for save in saves:
		if(is_instance_valid(save)):
			saveJson.saves.append(save.data)
	file.store_string(to_json(saveJson))
	file.close()

func loadSaves():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		file.open(SAVE_PATH, File.READ)
		var saveData = parse_json(file.get_as_text())
		file.close()
		if typeof(saveData) == TYPE_DICTIONARY:
			for saveDataIndex in range(saveData.saves.size()):
				var saveDataInstance = SAVE_DATA_LOAD.new()
				saveDataInstance.data = saveData.saves[saveDataIndex]
				saves.push_front(saveDataInstance)
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

func getSaves():
	return saves
