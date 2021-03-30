extends Control

export(float) var textSpeed = 0.05
export(String) var dialog = "" # dialog string
export(Array,String) var CHOICES = [] # options to show

export(NodePath) var RTL_PATH # path to the rich text label
export(NodePath) var OPTIONS_PATH = null# path to the choices HBox

signal dialog_done()
signal choice_made(choice)

var dialogStarted = false # true if dialog has started
var dialogPages = [] # pages of dialog if the whole dialog doesn't fit in one page
var page = 0 # current dialog page

onready var RTL = get_node(RTL_PATH) # Rich text label access shortcut because it is accessed a lot

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(dialogStarted):
		if(Input.is_action_just_pressed("next_dialog")):
			if (RTL.get_visible_characters() > RTL.get_total_character_count()): 
				if page < len(dialogPages)-1:
					page += 1
					RTL.set_visible_characters(0)
					RTL.set_bbcode(dialogPages[page])
				else:
					if(CHOICES.size() == 0):
						RTL.set_visible_characters(0)
						page = 0
						dialogPages = []
						dialogStarted = false
						self.hide()
						emit_signal("dialog_done")
			else: # shows the whole text at once
				RTL.set_visible_characters(RTL.get_total_character_count())

# Starts the dialog 
func startDialog():
	self.show()
	dialogPages = []
	computeDialogPages()
	setChoices()
	$RTLCharTimer.wait_time = textSpeed
	page = 0
	RTL.set_visible_characters(0)
	RTL.set_bbcode(dialogPages[page])
	dialogStarted = true

# force to end the dialog
func endDialog():
	RTL.set_visible_characters(0)
	page = 0
	dialogPages = []
	dialogStarted = false
	self.hide()

# sets the choices in the dialog box 
func setChoices():
	if(OPTIONS_PATH != null and get_node_or_null(OPTIONS_PATH)):
		for child in get_node(OPTIONS_PATH).get_children(): # clears the current buttons
			child.queue_free()
		for choice in CHOICES:
			var button = Button.new()
			button.text = choice.label
			button.set_h_size_flags(SIZE_EXPAND_FILL)
			button.connect("pressed",self,"choiceMade",[choice.signalName])
			get_node(OPTIONS_PATH).add_child(button)

# divides the dialog in dialogPages
func computeDialogPages():
	var rectTextSize = RTL.get_font("normal_font").get_string_size(dialog) # get the text rectangle size
	var RTLSize = RTL.rect_size
	var nbOfLines = rectTextSize.x/RTLSize.x
	var nbOfLinesInPage = RTLSize.y/rectTextSize.y - 1 # -1 just to be sure everything will fit
	var nbOfPages = nbOfLines/nbOfLinesInPage
	var avgNumberLettersInPage = dialog.length()/nbOfPages
	var lStringIndex = 0
	for pageIndex in range(1, int(nbOfPages) + 1): # starting at beginning of page 1 for rStringIndex
		var rStringIndex = pageIndex * int(avgNumberLettersInPage)
		if(rStringIndex <= dialog.length()):
			while(rStringIndex > lStringIndex and dialog[rStringIndex] != ' '):
				rStringIndex -= 1
			if(rStringIndex == lStringIndex): # the last word (alone) doesn't fit in one page
				dialogPages.append(dialog.substr(lStringIndex,pageIndex * int(avgNumberLettersInPage))) # FIXME : sometimes, text goes out of the dialog box, but that's a very specific case so ¯\_(ツ)_/¯
				rStringIndex = pageIndex * int(avgNumberLettersInPage)
			else:
				dialogPages.append(dialog.substr(lStringIndex,rStringIndex))
		lStringIndex = rStringIndex
	if(lStringIndex < dialog.length()):
		dialogPages.append(dialog.substr(lStringIndex,dialog.length()))

# shows another character
func _on_RTLCharTimer_timeout():
	RTL.set_visible_characters(RTL.get_visible_characters()+1)

# emits the choice made by the player
func choiceMade(choice):
	emit_signal("choice_made",choice)
