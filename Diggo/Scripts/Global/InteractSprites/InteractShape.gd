extends Area2D

# IDEA : if this is annoying for the player, just show the possible buttons, but enable these by pressing a specific

export(Array,String,FILE) var BUTTONS # buttons that should be loaded in the menu when interacting

var buttonInstanceArray = [] # array of button instances

# at start of scene
func _ready():
	for nodePath in BUTTONS:
		buttonInstanceArray.append(load(nodePath).instance())

# gets the array of buttons
func getButtons():
	return buttonInstanceArray

func _on_InteractShape_area_entered(area):
	if(area.has_method("addButtons")):
		area.addButtons(getButtons())

func _on_InteractShape_area_exited(area):
	if(area.has_method("removeButtons")):
		area.removeButtons(getButtons())
