extends Node2D

export (String,FILE) var KEY_COMMAND = "res://Scenes/Menus/KeyCommand.tscn"

# IDEA : After managing presets, check that every command is implemented before updating with preset (or put "UNASSIGNED_KEY" ?)

var commands = { # base commands, see https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-keylist
	"up": KEY_Z,
	"down": KEY_S,
	"left": KEY_Q,
	"right": KEY_D,
	"action": BUTTON_LEFT,
	"jump": KEY_SPACE,
	"find path": KEY_F,
	"interact": KEY_I
}

var keyCommandLoad # instance of key command scene

# Called when the node enters the scene tree for the first time.
func _ready():
	keyCommandLoad = load(KEY_COMMAND)
	addKeys()

# adds the keys in the controls panel
func addKeys():
	for command in commands.keys():
		addKey(command,commands[command])

# adds the key with command in controls panel
func addKey(command,key):
	var keyCommandInstance = keyCommandLoad.instance()
	keyCommandInstance.COMMAND = command
	keyCommandInstance.KEY = key
	keyCommandInstance.connect("change_key",self,"changeKey")
	$MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsScroll/ControlsOptions.add_child(keyCommandInstance)

func changeKey(keyInstance):
	$MarginContainer/KeyChangePopup.currentCode = keyInstance.KEY
	$MarginContainer/KeyChangePopup.keyCommandInstance = keyInstance
	$MarginContainer/KeyChangePopup.setText()
	$MarginContainer/KeyChangePopup.popup_centered_ratio(0.25)
