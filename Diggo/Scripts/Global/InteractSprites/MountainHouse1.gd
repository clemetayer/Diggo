extends Area2D

var Buttons
var enterButton

func _ready():
	enterButton = load("res://Scenes/UI/Menus/CircleButtons/EnterButton.tscn")
	var enterButtonInstance = enterButton.instance()
	enterButtonInstance.SCENE_PATH = "res://Scenes/Levels/Mountains1/MainHouse2.tscn"
	Buttons = [enterButtonInstance]

func reloadButtonsArray(): # Note : Previous instances should have been freed by CircleSelect
	Buttons = []
	var enterButtonInstance = enterButton.instance()
	enterButtonInstance.SCENE_PATH = "res://Scenes/Levels/Mountains1/MainHouse2.tscn"
	Buttons = [enterButtonInstance]

func getButtons():
	reloadButtonsArray()
	return Buttons

