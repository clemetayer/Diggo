extends Node

const SAVE_PATH = "user://diggo-save-data.json" # path to where the saves are stored
const SAVE_DATA_LOAD = preload("res://Scripts/Global/SaveSystem/SaveData.gd") # load the scene describing a save

var saves = [] # array of stored saves
var currentData # current save
var startPlayTime # start time in unix timestamp (used to compute the play time)

# at start
func _ready():
	initStartPlayTime()
	loadSaves()
	currentData = SAVE_DATA_LOAD.new()
	currentData.newFile("current")

# initializes startPlayTime
func initStartPlayTime():
	startPlayTime = OS.get_unix_time()

# updates the play time in current data
func updateSaveTime():
	var currentTime = OS.get_unix_time()
	var diffTime = currentTime - startPlayTime
	currentData.updateTime(diffTime)
	startPlayTime = currentTime

# creates a new save in the array (then saves and returns it)
func newFile():
	updateSaveTime()
	var saveDataInstance = SAVE_DATA_LOAD.new()
	saveDataInstance.loadData(currentData.data);
	saves.push_front(saveDataInstance)
	save()
	return saveDataInstance

# overwrites the save (then saves)
func overwriteFile(save):
	updateSaveTime()
	save.loadData(currentData.data)
	save()

# deletes the save (then saves after a small wait) 
func deleteFile(save):
	save.queue_free()
	yield(GlobalUtils.wait(0.1),"completed")
	save()

# loads the current save scene
func loadCurrentSave(sceneTree):
	currentData.loadSave(sceneTree)

# returns the array of saves
func getSaves():
	return saves

# changes the current save name
func changeCurrentFileName(name):
	currentData.changeName(name)

# saves the data in saves to the file at path SAVE_PATH
func save():
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	var saveJson = {"saves":[]}
	for save in saves:
		if(is_instance_valid(save)):
			saveJson.saves.append(save.data)
	file.store_string(to_json(saveJson))
	file.close()

# loads the save at path SAVE_PATH into saves
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
