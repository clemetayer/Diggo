extends Node

var data = {}

func loadData(parsedJsonData):
	data = parsedJsonData

func eraseFile():
	data = {}

func newFile(saveName):
	data = {
		'name':saveName,
		'location':{
			'locationName':'',
			'locationPath':'res://Scenes/Levels/Mountains1/MainHouse2.tscn'
		},
		'totalTime':{
			'hours':0,
			'minutes':0,
			'seconds':0
		}
	}

func changeName(name):
	data.name = name

func getSaveName():
	return data.name

func loadSave(sceneTree):
	sceneTree.change_scene(data.location.locationPath)

func updateTime(diffTime):
	if(data.totalTime.seconds + diffTime.second >= 60):
		data.totalTime.minutes += 1
		data.totalTime.seconds += diffTime.second - 60
	else:
		data.totalTime.seconds += diffTime.second
	if(data.totalTime.minutes + diffTime.minute >= 60):
		data.totalTime.hours += 1
		data.totalTime.minutes += diffTime.minute - 60
	else:
		data.totalTime.minutes += diffTime.minute
	data.totalTime.hours += diffTime.hour

func isNewFile():
	return (data.empty())

func getCurrentTime():
	var retStr = str(data.totalTime.hours) + " h " + str(data.totalTime.minutes) + " m " + str(data.totalTime.seconds) + " s "
	return retStr

func getLocation():
	return data.location.locationName
