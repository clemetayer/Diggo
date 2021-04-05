tool
extends Node

export(Array,Resource) var ITEMS setget set_items

var current_active_item = 0 # current active item

# setter for the path finding items
func set_items(item):
	for i in item.size():
		if not item[i]:
			# default value for new items in the dialogs array
			item[i] = {
				"name":"", # name of the item
				"active": false, # true if it is the one set by the user in the menu (the item that should be searched)
				"scene": [""], # array of scenes where the item can be found (size 0 if in every scene)
				"node":null, # instance of the object (null if not in the scene)
				"enabled":false, # true if it can appear in the user search menu
				"buttonPath":"" # path to the button for the path finding menu
			}
	ITEMS = item

# returns the current active item
func getActiveItem():
	return ITEMS[current_active_item]

# sets an item to active (if it exists)
func setActiveItem(name):
	var index = 0
	for item in ITEMS:
		if item.name == name: # item found
			ITEMS[current_active_item].active = false
			item.active = true
			current_active_item = index
			return
		index += 1

# sets the node path of an item (if it exists)
func setNodePath(name,path):
	for item in ITEMS:
		if item.name == name: # item found
			item.node = path
			return

# returns the path of a node
func getCurrentPath():
	return getActiveItem().node

# sets the enabled value of an item (if it exists)
func setEnabled(name,value):
	for item in ITEMS:
		if item.name == name: # item found
			item.enabled = value
			return

# returns a list of enabled button instances
func getButtons():
	var buttonList = []
	for item in ITEMS:
		if item.enabled:
			buttonList.append(load(item.buttonPath).instance())
	return buttonList

# set enabled, get button path, get buttons
