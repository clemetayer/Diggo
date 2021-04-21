extends Node

# TODO -NOW : loop chains are not perfectly accurate
# TODO -NOW : HouseTheme - some elements are waaay too loud (like chorus for instance)
# TODO -NOW : HouseTheme - re-export it as a loop
# TODO -NOW : add sound FX
# TODO : if song is shorter than the loop end value, then set loop end at the end of the track

var filterBGMIndex = 0 # index of the filter in the BGM bus

var filterTimerLoad
var BGMQueue = []

func _process(_delta):
	setAudioServerVolume()
	handleQueue()

# sets the volume in AudioServer according to the parameters
func setAudioServerVolume():
	AudioServer.set_bus_volume_db(0, linear2db(GlobalParameters.getSoundMaster()/100.0))
	AudioServer.set_bus_volume_db(1, linear2db(GlobalParameters.getSoundMusic()/100.0))
	AudioServer.set_bus_volume_db(2, linear2db(GlobalParameters.getSoundFX()/100.0))

# handles the song queue
func handleQueue():
	if(BGMQueue.size() > 0 and not BGMQueue[0].playing): # plays the next song
		playBGM()
	if(BGMQueue.size() > 1): # should switch to another song
		if(BGMQueue.size() > 2): # remove all the element between the next song and the last in queue
			for i in range(1,BGMQueue.size()-1):
				BGMQueue.remove(i)
		if(BGMQueue[1].bgm == BGMQueue[0].bgm): # sameBGM -> Don't stop, but set next loop
			BGMQueue[0].loop.enabled = BGMQueue[1].loop.enabled
			BGMQueue[0].loop.values.start = BGMQueue[1].loop.values.start
			BGMQueue[0].loop.values.end = BGMQueue[1].loop.values.end
			setStreamLoop()
			BGMQueue.remove(1)
		elif(BGMQueue[1].overrideCurrent and not $FilterTweens/RemoveFilterTween.is_active()): # Skips directly to the next song
			rmBGM()

# adds the BGM to queue, parameters should be the one created by createParameters function
func addBGMToQueue(parameters):
	BGMQueue.append(parameters)

# sets the stream loop of the current BGM to the specified values
func setStreamLoop():
	if(BGMQueue[0].loop.enabled and $LoopTimer.is_stopped()): # setup the loop timer again
		var beginTime # both in second
		var endTime
		if(BGMQueue[0].loop.values.start == null): # sets the begin loop to the start
			beginTime = 0
		else:# sets the begin loop to the specified value
			beginTime = BGMQueue[0].loop.values.start
		if(BGMQueue[0].loop.values.end == null): # sets the end loop to the end of the track
			endTime = BGMQueue[0].instance.stream.get_length()
		else:# sets the end loop to the specified value
			endTime = BGMQueue[0].loop.values.end
		$LoopTimer.wait_time = abs(endTime - beginTime) # just to avoid accidental mix ups between begin and end
														# IDEA : Actually if end < begin, play backward ?
		$LoopTimer.start()

# creates the parameters mandatory to the queue
# bgm : path to the bgm
# fadeInEnabled : true if the song should fade in at start
# fadeInTime : time for the fade in to complete
# fadeOutEnabled : true if the song should fade out when disappearing
# fadeOutTime : time for the fade out to complete
# loop : true if the song should loop
# loopStartValue : If null, loop starts at the beginning of the song (time in seconds)
# loopEndValue : If null, loop ends at the (time in seconds)
# overrideCurrent : when switching BGM, waits for the song to end if false, switches immediately otherwise
func createParameters(bgm,
	fadeInEnabled=false,fadeInTime=4,
	fadeOutEnabled=false,fadeOutTime=4,
	loop=true,loopStartValue=null,loopEndValue=null,
	overrideCurrent=true):
	return {
		"bgm":bgm,
		"playing":false,
		"instance":null,
		"fade":{
			"fadeIn":{
				"enabled":fadeInEnabled,
				"time":fadeInTime
			},
			"fadeOut":{
				"enabled":fadeOutEnabled,
				"time":fadeOutTime
			}
		},
		"loop":{
			"enabled":loop,
			"values":{
				"start":loopStartValue,
				"end":loopEndValue
			}
		},
		"overrideCurrent":overrideCurrent
	}


# removes the current BGM from the queue
func rmBGM():
	$FilterTweens/AddFilterTween.remove_all()
	var currentSong = BGMQueue[0]
	if(currentSong.fade.fadeOut.enabled):
		rmBGMWithFilter(currentSong.fade.fadeOut.time)
	else:
		var currentBGM = BGMQueue.pop_front()
		currentBGM.instance.stop()
		currentBGM.instance.queue_free()
		yield(currentBGM.instance,"tree_exited")
		currentBGM.instance = null
		currentBGM.instance = null

# removes the current BGM playing in the music bus, with filter out
# time in seconds, finalFilterVal in Hertz
func rmBGMWithFilter(time,finalFilterVal=10):
	$FilterTweens/RemoveFilterTween.interpolate_property(
		AudioServer.get_bus_effect(1, filterBGMIndex),
		"cutoff_hz",
		AudioServer.get_bus_effect(1, filterBGMIndex).cutoff_hz,
		finalFilterVal,
		time)
	$FilterTweens/RemoveFilterTween.start()

# removes the currentBGM when fade out done
func _on_RemoveFilterTween_tween_all_completed():
	var currentBGM = BGMQueue.pop_front()
	currentBGM.instance.stop()
	currentBGM.instance.queue_free()
	yield(currentBGM.instance,"tree_exited")
	currentBGM.instance = null
	currentBGM.instance = null

# plays the BGM at position 0
func playBGM():
	BGMQueue[0].playing = true
	BGMQueue[0].instance = load(BGMQueue[0].bgm).instance()
	add_child(BGMQueue[0].instance)
	if(BGMQueue[0].fade.fadeIn.enabled): # play with fade in
		addBGMWithFilter(BGMQueue[0].fade.fadeIn.time)
	$LoopTimer.stop()
	setStreamLoop()
	BGMQueue[0].instance.play()

# adds the audio stream (should be in Music bus), then plays it with filter entrance
# bgm as a string to the scene, time in seconds, start/finalFilterVal in Hz
func addBGMWithFilter(time,startFilterVal=1,finalFilterVal=20000):
	$FilterTweens/AddFilterTween.interpolate_property(
		AudioServer.get_bus_effect(1, filterBGMIndex),
		"cutoff_hz",
		startFilterVal,
		finalFilterVal,
		time)
	$FilterTweens/AddFilterTween.start()

# fades the current BGM to finalFilterVal in time (in seconds) (used for pause menu for instance)
func BGMFade(time = 2, finalFilterVal = 2000):
	$FilterTweens/FadeFilterTween.interpolate_property(
		AudioServer.get_bus_effect(1, filterBGMIndex),
		"cutoff_hz",
		AudioServer.get_bus_effect(1, filterBGMIndex).cutoff_hz,
		finalFilterVal,
		time)
	$FilterTweens/FadeFilterTween.start()

# handle what to do when the loop is done
# yup, i have to do this with a timer, which kind of sucks (unless there is a better solution)
func _on_LoopTimer_timeout():
	if(BGMQueue[0].loop.enabled): # can loop
		var beginTime # both in second
		var endTime
		if(BGMQueue[0].loop.values.start == null): # sets the begin loop to the start
			beginTime = 0
		else:# sets the begin loop to the specified value
			beginTime = BGMQueue[0].loop.values.start
		if(BGMQueue[0].loop.values.end == null): # sets the end loop to the end of the track
			endTime = BGMQueue[0].instance.stream.get_length()
		else:# sets the end loop to the specified value
			endTime = BGMQueue[0].loop.values.end
		$LoopTimer.wait_time = abs(endTime - beginTime) # just to avoid accidental mix ups between begin and end
														# IDEA : Actually if end < begin, play backward ?
		$LoopTimer.start()
		BGMQueue[0].instance.play(beginTime)
	else: # disable loop
		$LoopTimer.stop()
