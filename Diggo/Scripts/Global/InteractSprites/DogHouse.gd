extends Area2D

# Intended to work as an object you can interact with (adds buttons in the circle select menu)
# Complementary to CircleSelect.gd

var Buttons # buttons that should be loaded in the menu when interacting
var saveButton # load of the save button

# at start of scene
func _ready():
	saveButton = load("res://Scenes/UI/Menus/CircleButtons/SaveButton.tscn")
	var saveButtonInstance = saveButton.instance()
	Buttons = [saveButtonInstance]

# refreshes the array of buttons
func reloadButtonsArray(): # Note : Previous instances should have been freed by CircleSelect
	Buttons = []
	var saveButtonInstance = saveButton.instance()
	Buttons = [saveButtonInstance]

# gets the array of buttons
func getButtons():
	reloadButtonsArray()
	return Buttons

