extends Node

####### Global script where some functions not needing to be in a specific class are stored #######

##### DATE - TIME functions #####
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
