extends Node

const SAVE_PATH = "user://diggo-save-data.json"
const SAVE_DATA_LOAD = preload("res://Scripts/Global/SaveSystem/SaveData.gd")

var saves = []
var lastSave
var currentData
var startPlayTime

func _ready():
	initStartPlayTime()
	currentData = SAVE_DATA_LOAD.new()
	currentData.newFile("current")
	lastSave = currentData

func initStartPlayTime():
	startPlayTime = OS.get_time()

func updateSaveTime(): # Note : Inaccurate if the players spends more than an entire day into the game without saving (which is unlikely)
	var currentTime = OS.get_time()
	var secondDiff = fmod((currentTime.second - startPlayTime.second),24)
	var minuteDiff = 0
	var hourDiff = 0
	if((currentTime.second - startPlayTime.second) < 0): # i.e played one minute less; example : 23h58:58 -> 1h02:02 = 1h04:04 
		minuteDiff = fmod((currentTime.minute - startPlayTime.minute -1), 60)
		if((currentTime.minute - startPlayTime.minute - 1) < 0): # i.e played one hour less; example : 23h00:58 -> 1h00:02 = 0h59:04 
			hourDiff = fmod((currentTime.hour - startPlayTime.hour - 1),24)
		else:
			hourDiff = fmod((currentTime.hour - startPlayTime.hour),24)
	else:
		minuteDiff = fmod((currentTime.minute - startPlayTime.minute), 60)
		if((currentTime.minute - startPlayTime.minute) < 0): # i.e played one hour less; example : 23h00:58 -> 1h00:02 = 0h59:04 
			hourDiff = fmod((currentTime.hour - startPlayTime.hour - 1),24)
		else:
			hourDiff = fmod((currentTime.hour - startPlayTime.hour),24)
	var diffTime = {
		"hour" : hourDiff,
		"minute" : minuteDiff,
		"second" : secondDiff
	}
	currentData.updateTime(diffTime)

func loadCurrentSave(sceneTree):
	currentData.loadSave(sceneTree)

func loadSave(sceneTree,index):
	currentData = saves[index]
	saves[index].loadSave(sceneTree)

func newFile():
	updateSaveTime()
	var saveDataInstance = SAVE_DATA_LOAD.new()
	saveDataInstance.loadData(currentData.data);
	saves.push_front(saveDataInstance)
	lastSave = saveDataInstance

func overwriteFile(index):
	updateSaveTime()
	saves[index].loadData(currentData.data)
	lastSave = saves[index]

func deleteFile(index):
	var saveInstance = saves[index]
	saves[index] = null # sets the save at null to avoid an update of every button in the save menu
	saveInstance.queue_free()

func changeCurrentFileName(name):
	currentData.changeName(name)

func save():
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	var saveJson = {"saves":[]}
	for save in saves:
		if(save != null and not save.isNewFile()):
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
	saves.push_front(SAVE_DATA_LOAD.new())

func getSaves():
	return saves
