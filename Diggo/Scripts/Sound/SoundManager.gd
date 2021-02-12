extends Node

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
	if(bgm != currentBGMString):
		var filterTimeInstance = filterTimerLoad.instance()
		filterTimeInstance.audioBusIndex = 1
		filterTimeInstance.effectIndex = 0
		filterTimeInstance.startValue = startFilterVal
		filterTimeInstance.endValue = finalFilterVal
		add_child(filterTimeInstance)
		filterTimeInstance.startTimer()
		var bgmInstance = load(bgm).instance()
		bgmInstance.connect("fade_out_done",self,"fadeOutDone")
		add_child(bgmInstance)
		bgmInstance.play()
		currentBGMString = bgm
		currentBGMInstance = bgmInstance

# removes the current BGM playing in the music bus, with filter out
# time in seconds, finalFilterVal in Hertz
# TODO : remove immediately before loading the scene
func rmBGMWithFilter(time=2,finalFilterVal=10):
	var filterTimeInstance = filterTimerLoad.instance()
	filterTimeInstance.audioBusIndex = 1
	filterTimeInstance.effectIndex = 0
	filterTimeInstance.startValue = AudioServer.get_bus_effect(1, 0).cutoff_hz
	print(filterTimeInstance.startValue)
	filterTimeInstance.endValue = finalFilterVal
	add_child(filterTimeInstance)
	filterTimeInstance.startTimer()

func fadeOutDone():
	currentBGMInstance.stop()
	currentBGMInstance.queue_free()
