extends Node

var data = {} # data in save

# initializes data to a new file
func newFile(saveName):
	data = {
		'name':saveName,
		'location':{
			'locationName':'Mountain house',
			'locationPath':'res://Scenes/Levels/Mountains1/MainHouse2.tscn'
		},
		'totalTime': 0, # in unix timestamp (seconds)
		'sceneParameters':{
			'tutorialScene':{
				'nbOffCliff':0 # number of times diggo ran out of the cliff
			}
		} # specific parameters for scene
	}

# sets data to the one in parameter (duplicate)
func loadData(parsedJsonData):
	data = parsedJsonData.duplicate()

# clears data
func eraseFile():
	data = {}

# changes the name of the save
func changeName(name):
	data.name = name

# returns the name of the save
func getSaveName():
	return data.name

# loads the scene specified by the save
func loadSave(_sceneTree):
	SwitchSceneWithParam.goto_scene(data.location.locationPath)

# updates the time of the save
func updateTime(diffTime):
	data.totalTime += diffTime

# returns true if is new file UNUSED?
func isNewFile():
	return (data.empty())

# converts and returns the play time as a string
func getCurrentTime():
	var convertedTime = GlobalUtils.UnixTSToHMS(data.totalTime)
	var retStr = str(convertedTime.hours) + " h " + str(convertedTime.minutes) + " m " + str(convertedTime.seconds) + " s "
	return retStr

# returns the name of the save location
func getLocation():
	return data.location.locationName

# sets the location in the save
func setLocation(newLoc):
	data.location = newLoc

# gets a specific scene parameter if exists, or returns null
func getSceneParameter(sceneName): # TODO : Add a printerr
	if(data.sceneParameters.has(sceneName)):
		return data.sceneParameters.get(sceneName)
	return null

# sets the scene parameter if exists
func setSceneParameter(sceneName, newSceneParam): # TODO : Add a printerr
	if(data.sceneParameters.has(sceneName)):
		data.sceneParameters.sceneName = newSceneParam
