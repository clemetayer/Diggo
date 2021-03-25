extends Area2D

# Intended to work as an object you can interact with (adds buttons in the circle select menu)
# Complementary to CircleSelect.gd

# TODO : find a way to merge with other buttons
# TODO OPTIMIZATION : Re-Implement the way it works, definitely.

var Buttons # buttons that should be loaded in the menu when interacting
var ballButton # load of the save button

# at start of scene
func _ready():
	ballButton = load("res://Scenes/UI/Menus/CircleButtons/BallButton.tscn")
	var ballButtonInstance = ballButton.instance()
	Buttons = [ballButtonInstance]

# refreshes the array of buttons
func reloadButtonsArray(): # Note : Previous instances should have been freed by CircleSelect
	Buttons = []
	var ballButtonInstance = ballButton.instance()
	Buttons = [ballButtonInstance]

# gets the array of buttons
func getButtons():
	reloadButtonsArray()
	return Buttons
