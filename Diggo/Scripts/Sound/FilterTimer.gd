extends Timer

signal fade_out_done()

export(int) var audioBusIndex = 0 # index of the audio bus where the filter is located
export(int) var effectIndex = 0 # index of the filter in the bus
export(float) var endValue = 20000 # end value of the filter
export(float) var startValue = 0 # start value of the filter
export(float) var filterTime = 8 # time for the filter to apply
export(float) var timeStep = 0.1 # timer timeout time

var timeElapsed = 0.0 # time elapsed since the beginning of the timer
var fadeIn # true if it is a fade in (false if fade out)

func startTimer():
	fadeIn = (endValue >= startValue)
	AudioServer.get_bus_effect(audioBusIndex, effectIndex).cutoff_hz = startValue
	start(timeStep)

func _on_FilterTimer_timeout():
	var filter = AudioServer.get_bus_effect(audioBusIndex, effectIndex)
	if(timeElapsed >= filterTime and fadeIn): # filter reached end value
		queue_free()
	elif(timeElapsed >= filterTime and not fadeIn):
		emit_signal("fade_out_done")
		queue_free()
	else:
		var sliderVal = timeElapsed / filterTime
		filter.cutoff_hz = startValue + pow(10,(linear2db(sliderVal)/10)) * (endValue - startValue)
		start(timeStep)
		timeElapsed += timeStep
