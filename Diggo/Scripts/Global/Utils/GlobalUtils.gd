extends Node

####### Global script where some functions not needing to be in a specific class are stored #######

##### Input functions #####
# mouse input custom enum (because can't get global mouse enum as string)

# FIXME : Enum values not correct somehow
enum MouseInputEnum {
	LeftClick = 1,
	RightClick = 2,
	MiddleClick = 3,
	ExtraButton1 = 8,
	ExtraButton2 = 9,
	MouseWheelUp = 4,
	MouseWheelDown = 5,
	MouseWheelLeft = 6,
	MouseWheelRight = 7
}

# gets the enum mouse input value as a string
func getMouseInputAsString(code) -> String:
	if(code <= 9 and code > 0):
		return MouseInputEnum.keys()[code]
	return ""

# gets the name of the input code as a string
func getInputAsString(code) -> String:
	if(getMouseInputAsString(code) != ""): # if input is from mouse
		return getMouseInputAsString(code)
	return OS.get_scancode_string(code) # else, it's from keyboard (joystick not supported) #TODO ?

##### DATE - TIME functions #####
# waits for a specific amount of time
# should be used this way : yield(GlobalUtils.wait(<time>),"completed")
# TODO : Godot has actually a create_timer method that does the same, so replacing that woud be cool
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

##### Node management #####
# removes all the children of node
func removeAllChildren(node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
