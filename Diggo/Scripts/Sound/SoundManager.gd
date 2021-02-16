extends Node

# FIXME : old music keeps playing when changing music as fade in filter was not done
# FIXME : crash when main menu -> whatever game scene with a music change -> save menu -> main menu
# TODO : maybe refactor a bit around here

const FILTER_TIMER = "res://Scenes/Sound/FilterTimer.tscn"

var currentBGMString
var currentBGMInstance
var filterTimerLoad

# Called when the node enters the scene tree for the first time.
func _ready():
	filterTimerLoad = load(FILTER_TIMER)

func _process(_delta):
	AudioServer.set_bus_volume_db(0, linear2db(GlobalParameters.getSoundMaster()/100.0))
	AudioServer.set_bus_volume_db(1, linear2db(GlobalParameters.getSoundMusic()/100.0))
	AudioServer.set_bus_volume_db(2, linear2db(GlobalParameters.getSoundFX()/100.0))


# adds the audio stream (should be in Music bus), then plays it with filter entrance
# bgm as a string to the scene, time in seconds, start/finalFilterVal in Hz
func addBGMWithFilter(bgm,time=8,startFilterVal=1,finalFilterVal=20000):
	var filterTimeInstance = filterTimerLoad.instance()
	filterTimeInstance.audioBusIndex = 1
	filterTimeInstance.effectIndex = 0
	filterTimeInstance.startValue = startFilterVal
	filterTimeInstance.endValue = finalFilterVal
	filterTimeInstance.filterTime = time
	add_child(filterTimeInstance)
	filterTimeInstance.startTimer()
	var bgmInstance = load(bgm).instance()
	add_child(bgmInstance)
	bgmInstance.play()
	currentBGMString = bgm
	currentBGMInstance = bgmInstance

# removes the current BGM playing in the music bus, with filter out
# time in seconds, finalFilterVal in Hertz
func rmBGMWithFilter(time=2,finalFilterVal=10):
	var filterTimeInstance = filterTimerLoad.instance()
	filterTimeInstance.connect("fade_out_done",self,"fadeOutDone")
	filterTimeInstance.audioBusIndex = 1
	filterTimeInstance.effectIndex = 0
	filterTimeInstance.filterTime = time
	if(AudioServer.get_bus_effect(1, 0).cutoff_hz > 10000): # to fade out directly at the moment when a change can be heard
		AudioServer.get_bus_effect(1, 0).cutoff_hz = 10000 
	filterTimeInstance.startValue = AudioServer.get_bus_effect(1, 0).cutoff_hz
	filterTimeInstance.endValue = finalFilterVal
	add_child(filterTimeInstance)
	filterTimeInstance.startTimer()

# plays the bgm if not playing or no bgm with filter, or changes the bgm with filter
func playBGMWithFilter(bgm, fadeOutTime = 2, fadeInTime = 8, finalFilterVal = 20000):
	if(currentBGMString == null): # no BGM currently playing
		addBGMWithFilter(bgm,fadeInTime,1,finalFilterVal)
	else:
		if(currentBGMString != bgm): # the target song is not the one already playing
			rmBGMWithFilter(fadeOutTime)
			yield(GlobalUtils.wait(fadeOutTime + 0.25),"completed") # added 0.25s to be sure the current BGM has faded out and was freed
			addBGMWithFilter(bgm,fadeInTime,10,finalFilterVal)

# fades the current BGM to finalFilterVal in time (in seconds) (used for pause menu for instance)
func BGMFade(time = 2, finalFilterVal = 2000):
	var filterTimeInstance = filterTimerLoad.instance()
	filterTimeInstance.audioBusIndex = 1
	filterTimeInstance.effectIndex = 0
	filterTimeInstance.filterTime = time
	filterTimeInstance.startValue = AudioServer.get_bus_effect(1, 0).cutoff_hz
	filterTimeInstance.endValue = finalFilterVal
	add_child(filterTimeInstance)
	filterTimeInstance.startTimer()

# removes the BGM when fade out is done
func fadeOutDone():
	currentBGMInstance.stop()
	currentBGMInstance.queue_free()
	currentBGMInstance = null
	currentBGMString = null
