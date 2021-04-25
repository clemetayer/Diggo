extends Control

export(Array) var BUTTONS # array containing the buttons for the circle select menu
export(int) var RADIUS = 1000 # radius of the circle select menu
export(float) var START_ANGLE = -PI/2 - PI/15 # start angle position for the first button

# TODO : Click on buttons on hover with specific angle (like the circle select menus in most games)

# Called when the node enters the scene tree for the first time.
func _ready():
	if(SignalManager.connect("enable_interactions",self,"showCircleMenu") != OK):
		Logger.error("Error connecting signal \"enable_interactions\" to method \"showCircleMenu\"" + GlobalUtils.stack2String(get_stack()))
	addButtonChildren()

# removes a button from the circle menu
func removeChildren():
	for children in get_children():
		remove_child(children)

# adds the BUTTONS in the circle menu
func addButtonChildren():
	if(BUTTONS.size() > 0):
		var angleAdd = (2*PI)/BUTTONS.size()
		var angle = START_ANGLE 
		for button in BUTTONS:
			if(button is Button or button is TextureButton):
				add_child(button)
				button.set_position(Vector2(cos(angle)*RADIUS + button.rect_size.x/2, sin(angle)*RADIUS - button.rect_size.y/2))
				angle = fmod(angle+angleAdd,2*PI)

# refreshes the buttons in the menu
func refreshButtons():
	removeChildren()
	addButtonChildren()
	
# shows or hides the circle menu
func showCircleMenu(value):
	visible = value
