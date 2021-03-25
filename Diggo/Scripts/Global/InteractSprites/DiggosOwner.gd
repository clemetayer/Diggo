extends Area2D

# Intended to work as an object you can interact with (adds buttons in the circle select menu)
# Complementary to CircleSelect.gd

var Buttons # buttons that should be loaded in the menu when interacting
var diggoOwnerButton # load of the save button

# at start of scene
func _ready():
	diggoOwnerButton = load("res://Scenes/UI/Menus/CircleButtons/DiggosOwnerButton.tscn")
	var diggoOwnerButtonInstance = diggoOwnerButton.instance()
	Buttons = [diggoOwnerButtonInstance]

# refreshes the array of buttons
func reloadButtonsArray(): # Note : Previous instances should have been freed by CircleSelect
	Buttons = []
	var diggoOwnerButtonInstance = diggoOwnerButton.instance()
	Buttons = [diggoOwnerButtonInstance]

# gets the array of buttons
func getButtons():
	reloadButtonsArray()
	return Buttons
