extends Node

####### Global script where some functions not needing to be in a specific class are stored #######

# Called when the node enters the scene tree for the first time.
func _ready():
	##### Logger parameters (using https://gitlab.com/godot-stuff/gs-logger) #####
	Logger.set_logger_level(Logger.LOG_LEVEL_ALL)
	Logger.set_logger_format(Logger.LOG_FORMAT_FULL)

##### Logger utils #####
# stack trace to string
func stack2String(stack : Array) -> String:
	var ret = "\n"
	if(stack.size() > 0):
		for i in range(0,stack.size()):
			ret += stack[i].source + ":" + stack[0].function + ",l" + str(stack[0].line) + "\n"
	return ret
	

##### Enums #####
# mouse input custom enum (because can't get global mouse enum as string)
# ARCHITECTURE : Actually, that's not an enum
var MouseInputEnum = {
	"LeftClick" : 1,
	"RightClick" : 2,
	"MiddleClick" : 3,
	"ExtraButton1" : 8,
	"ExtraButton2" : 9,
	"MouseWheelUp" : 4,
	"MouseWheelDown" : 5,
	"MouseWheelLeft" : 6,
	"MouseWheelRight" : 7
}

# animation global enums (to have common values for each character)
enum AnimationEnum {
	Idle,
	Run,
	Jump,
	Eat
}

##### Input functions #####
# gets the enum mouse input value as a string
func getMouseInputAsString(code) -> String:
	if(code <= 9 and code > 0):
		for mouseButton in MouseInputEnum: # kind of a dirty way to do this, but it works, and it's only 9 codes that should not move that much
			if(MouseInputEnum[mouseButton] == code):
				return mouseButton
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

# checks if the node has a signal named signal_name
func checkIfHasSignal(node,signal_name):
	for el in node.get_signal_list():
		if(el["name"] == signal_name):
			return true
	return false

##### Effects #####
### Shake screen functions ###
var screen_shake_param = {
	TRANS = Tween.TRANS_SINE,
	EASE = Tween.EASE_IN_OUT,
	camera = null,
	priority = 0,
	amplitude = 16,
	duration_node = null,
	frequency_node = null,
	tween_node = null,
}

# shakes the screen
func shakeScreen(camera, duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if (priority >= screen_shake_param.priority):
		screen_shake_param.priority = priority
		screen_shake_param.amplitude = amplitude
		screen_shake_param.camera = camera
		# set duration node
		if(screen_shake_param.duration_node != null and screen_shake_param.duration_node.is_instance_valid()): # duration_node not freed
			screen_shake_param.duration_node.queue_free()
		screen_shake_param.duration_node = Timer.new()
		screen_shake_param.duration_node.connect("timeout",self,"_reset")
		screen_shake_param.duration_node.set_wait_time(duration)
		add_child(screen_shake_param.duration_node)
		# set frequency node
		if(screen_shake_param.frequency_node != null and screen_shake_param.frequency_node.is_instance_valid()): # frequency_node not freed
			screen_shake_param.frequency_node.queue_free()
		screen_shake_param.frequency_node = Timer.new()
		screen_shake_param.frequency_node.connect("timeout",self,"_new_shake")
		screen_shake_param.frequency_node.set_wait_time(1/float(frequency))
		add_child(screen_shake_param.frequency_node)
		# set tween node
		if(screen_shake_param.tween_node != null and screen_shake_param.tween_node.is_instance_valid()): # tween_node not freed
			screen_shake_param.tween_node.queue_free()
		screen_shake_param.tween_node = Tween.new()
		add_child(screen_shake_param.tween_node)
		screen_shake_param.duration_node.start()
		screen_shake_param.frequency_node.start()

		_new_shake()

func _new_shake():
	var rand = Vector2()
	var amp = screen_shake_param.amplitude
	rand.x = rand_range(-amp, amp)
	rand.y = rand_range(-amp, amp)
	
	screen_shake_param.tween_node.interpolate_property(
		screen_shake_param.camera,
		"offset", 
		screen_shake_param.camera.offset, 
		rand, 
		screen_shake_param.frequency_node.wait_time, 
		screen_shake_param.TRANS, 
		screen_shake_param.EASE)
	screen_shake_param.tween_node.start()

func _reset():
	screen_shake_param.frequency_node.stop()
	screen_shake_param.frequency_node.queue_free()
	screen_shake_param.duration_node.stop()
	screen_shake_param.duration_node.queue_free()
	screen_shake_param.tween_node.interpolate_property(
		screen_shake_param.camera,
		"offset", 
		screen_shake_param.camera.offset, 
		Vector2(), 
		screen_shake_param.frequency_node.wait_time, 
		screen_shake_param.TRANS, 
		screen_shake_param.EASE)
	screen_shake_param.tween_node.start()
	screen_shake_param.tween_node.connect("tween_all_completed",self,"freeTween")
	screen_shake_param.priority = 0

func freeTween():
	screen_shake_param.tween_node.queue_free()
