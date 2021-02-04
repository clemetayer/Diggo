extends Control

export(Array) var BUTTONS # array containing the buttons for the circle select menu
export(int) var RADIUS = 1000 # radius of the circle select menu
export(float) var START_ANGLE = -PI/2 - PI/15 # start angle position for the first button

# TODO : Remove buttons when exiting the interact zone
# TODO : Click on buttons on hover with specific angle

# Called when the node enters the scene tree for the first time.
func _ready():
	addButtonChildren()

# removes a button from the circle menu
func removeChildren():
	for children in get_children():
		remove_child(children)
		children.queue_free()

# adds the BUTTONS in the circle menu
func addButtonChildren():
	if(BUTTONS.size() > 0):
		var angleAdd = (2*PI)/BUTTONS.size()
		var angle = START_ANGLE 
		for button in BUTTONS:
			if(button is Button or button is TextureButton):
				add_child(button)
				button.set_position(Vector2(cos(angle)*RADIUS, sin(angle)*RADIUS))
				angle = fmod(angle+angleAdd,2*PI)

# refreshes the buttons in the menu
func refreshButtons():
	removeChildren()
	addButtonChildren()
