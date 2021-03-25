extends Control

export(String) var dialog = "" # dialog string
export(NodePath) var RTL_PATH # path to the rich text label

# FIXME : <<<<<<<<< Weird things happening here >>>>>>>>>>
# maybe this is because the dialogs are not in an array in dialog scene ?
# FIXME : When digging, the dialogBox rotates too
# FIXME : this blocks the mouse for buttons in circle menu

signal dialog_done()

onready var RTL = get_node(RTL_PATH) # Rich text label access shortcut because it is accessed a lot

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()

# Starts the dialog 
func startDialog():
	self.show()
	RTL.set_visible_characters(RTL.get_total_character_count())
	RTL.set_bbcode(dialog)
