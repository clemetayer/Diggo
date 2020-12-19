extends Area2D

var Buttons

func _ready():
	var enterButton = load("res://Scenes/UI/Menus/CircleButtons/EnterButton.tscn")
	var enterButtonInstance = enterButton.instance()
	enterButtonInstance.SCENE_PATH = "res://Scenes/Levels/Mountains1/MainHouse2.tscn"
	Buttons = [enterButtonInstance]

func getButtons():
	return Buttons

