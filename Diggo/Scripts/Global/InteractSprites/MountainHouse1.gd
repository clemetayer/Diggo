extends Area2D
# Intended to work as an object you can interact with (adds buttons in the circle select menu)
# Complementary to CircleSelect.gd

var Buttons # buttons that should be loaded in the menu when interacting
var enterButton # instance of the door enter button

# at start of scene
func _ready():
	enterButton = load("res://Scenes/UI/Menus/CircleButtons/EnterButton.tscn")
	var enterButtonInstance = enterButton.instance()
	enterButtonInstance.SCENE_PATH = "res://Scenes/Levels/Mountains1/MainHouse2.tscn"
	Buttons = [enterButtonInstance]

# refreshes the array of buttons
func reloadButtonsArray(): # Note : Previous instances should have been freed by CircleSelect
	Buttons = []
	var enterButtonInstance = enterButton.instance()
	enterButtonInstance.SCENE_PATH = "res://Scenes/Levels/Mountains1/MainHouse2.tscn"
	Buttons = [enterButtonInstance]

# gets the array of buttons
func getButtons():
	reloadButtonsArray()
	return Buttons

