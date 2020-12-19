extends Control

export(Array) var BUTTONS
export(int) var RADIUS = 1000
export(float) var START_ANGLE = -PI/2 - PI/15

func addButtonChildren():
	if(BUTTONS.size() > 0):
		var angleAdd = (2*PI)/BUTTONS.size()
		var angle = START_ANGLE 
		for button in BUTTONS:
			if(button is Button or button is TextureButton):
				add_child(button)
				button.set_position(Vector2(cos(angle)*RADIUS, sin(angle)*RADIUS))
				angle = fmod(angle+angleAdd,2*PI)

# Called when the node enters the scene tree for the first time.
func _ready():
	addButtonChildren()

func removeChildren():
	for children in get_children():
		remove_child(children)
		children.queue_free()

func refreshButtons():
	removeChildren()
	addButtonChildren()
