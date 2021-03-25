extends Node2D

export(NodePath) var CIRCLE_SELECT_MENU # Circle select menu where to put buttons
										# Note : get_node() needed to actually access the node

# adds buttons in the circle select menu
func addButtons(buttons:Array):
	var circle_select = get_node(CIRCLE_SELECT_MENU)
	circle_select.BUTTONS += buttons
	circle_select.refreshButtons()

# removes the buttons in the circle select menu
func removeButtons(buttons:Array):
	var circle_select = get_node(CIRCLE_SELECT_MENU)
	for button in buttons:
		var index = circle_select.BUTTONS.find(button)
		if(index != -1): # the button is in the menu
			circle_select.BUTTONS.remove(index)
	circle_select.refreshButtons()
