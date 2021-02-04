extends Node

####### Global script where some functions not needing to be in a specific class are stored #######

##### DATE - TIME functions #####
# waits for a specific amount of time
# should be used this way : yield(GlobalUtils.wait(<time>),"completed")
func wait(time):
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()

# Converts a time difference as a unix timestamp to a time dictionnary
func UnixTSToHMS(timestamp):
	var hours = int(timestamp/(60*60))
	var minutes = int((timestamp/60) - (hours*60))
	var seconds = int(timestamp - (hours*60*60) - (minutes*60))
	return {
		"hours":hours,
		"minutes":minutes,
		"seconds":seconds
	}
