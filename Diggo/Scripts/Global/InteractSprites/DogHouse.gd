extends Area2D

var Buttons
var saveButton

func _ready():
	saveButton = load("res://Scenes/UI/Menus/CircleButtons/SaveButton.tscn")
	var saveButtonInstance = saveButton.instance()
	Buttons = [saveButtonInstance]

func reloadButtonsArray(): # Note : Previous instances should have been freed by CircleSelect
	Buttons = []
	var saveButtonInstance = saveButton.instance()
	Buttons = [saveButtonInstance]

func getButtons():
	reloadButtonsArray()
	return Buttons

