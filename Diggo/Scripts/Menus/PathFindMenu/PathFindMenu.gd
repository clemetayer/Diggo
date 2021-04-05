extends CenterContainer

export(Array) var BUTTONS = [] # button instances to set in the grid
export(int) var BUTTONS_PER_LINE = 5 # number of buttons per line of grid

func _ready():
	BUTTONS = PathFindingItems.getButtons()
	get_tree().paused = false
	if(SignalManager.connect("path_finding_item_chosen",self,"hideMenu") != OK):
		printerr("Error in PathFindMenu -> _ready -> SignalManager -> connect (path_finding_item_chosen)") # LOGGER
	hide()

func _input(event):
	if(event.is_action_pressed("find menu")):
		get_tree().paused = true
		set_buttons()
		show()

# sets the buttons in the grid
func set_buttons():
	refreshButtons()
	for button in BUTTONS:
		if(not button in $VBoxContainer/MarginContainer/PathFindGrid.get_children()):
			$VBoxContainer/MarginContainer/PathFindGrid.add_child(button)

# refreshes the buttons array
# OPTIMIZATION : do not create and free buttons if already exists
func refreshButtons():
	var newButtons = PathFindingItems.getButtons()
	for button in BUTTONS: # frees each instance in BUTTONS
		button.queue_free()
	BUTTONS = newButtons

# hides the path find menu
func hideMenu():
	hide()
	get_tree().paused = false
