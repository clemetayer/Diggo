extends Node
# TODO : re-organize functions so it's clearer

var data = {}

func loadData(parsedJsonData):
	data = parsedJsonData.duplicate()

func eraseFile():
	data = {}

func newFile(saveName):
	data = {
		'name':saveName,
		'location':{
			'locationName':'',
			'locationPath':'res://Scenes/Levels/Mountains1/MainHouse2.tscn'
		},
		'totalTime': 0 # in unix timestamp (seconds)
	}

func changeName(name):
	data.name = name

func getSaveName():
	return data.name

func loadSave(sceneTree):
	sceneTree.change_scene(data.location.locationPath)

func updateTime(diffTime):
	data.totalTime += diffTime

func isNewFile():
	return (data.empty())

func getCurrentTime():
	var convertedTime = GlobalUtils.UnixTSToHMS(data.totalTime)
	var retStr = str(convertedTime.hours) + " h " + str(convertedTime.minutes) + " m " + str(convertedTime.seconds) + " s "
	return retStr

func getLocation():
	return data.location.locationName
