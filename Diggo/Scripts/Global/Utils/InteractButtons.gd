extends Node2D

export(NodePath) var INTERACT_AREA # Area2D that detects interactable Areas
export(NodePath) var CIRCLE_SELECT_MENU # Circle select menu where to put buttons
										# Note : get_node() needed to actually access the node

# set the possible interaction buttons, depending on the overlapping area
func setInteractButtons():
	var collidingAreas = get_node(INTERACT_AREA).get_overlapping_areas()
	for collidingArea in collidingAreas:
		if(collidingArea.has_method("getButtons")):
			var ButtonsArea = collidingArea.getButtons()
			get_node(CIRCLE_SELECT_MENU).BUTTONS = ButtonsArea
			get_node(CIRCLE_SELECT_MENU).refreshButtons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inputManager()

# input manager for interact buttons script
func inputManager():
	if(Input.is_action_just_pressed("interact")):
		setInteractButtons()
