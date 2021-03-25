tool
extends Control

export(Array, Resource) var DIALOGS setget set_dialog# NOTE : Array of Dictionnaries with structure : 
						  # {
						  #  'targets':<Array of NodePath> Path to the dialog box of the target, 
						  #  'dialog':<String>, 
						  # }

signal dialogs_done()
signal choice_made(signal_name)

var isStarted = false
var indexDialog = 0

# setter for the dialog 
func set_dialog(dialog):
	var path = NodePath() # default example path
	for i in dialog.size():
		if not dialog[i]:
			# default value for new items in the dialogs array
			dialog[i] = {
				"targets": [path],
				"dialog": "",
				"choices":false
			}
		dialog[i] = checkChoices(dialog[i])
	DIALOGS = dialog

# function to check which action to take with the choices option
func checkChoices(dialog):
	var ret_dialog = dialog
	if(dialog.choices): # i.e dialog.choices != false
		if(dialog.choices is bool): # just went from false to true
			ret_dialog.choices = []
		else:
			if(dialog.choices.size() == 0): # i.e removed choices
				ret_dialog.choices = false
			else:
				for i in dialog.choices.size():
					if not dialog.choices[i]:
						# default value for new items in the dialogs array
						ret_dialog.choices[i] = {
							"label":"", # Label of the button
							"signalName":"" # signal name that will be put as a parameter in choice_made signal
						}
	return ret_dialog

# start the dialog
func startDialog():
	isStarted = true
	indexDialog = 0
	for target in DIALOGS[indexDialog].targets:
		if target is NodePath:
			var node = get_node(target)
			if(not node.is_connected("dialog_done", self, "nextDialog")): # to avoid useless connections
				node.connect("dialog_done",self,"nextDialog")
			if(DIALOGS[indexDialog].choices and DIALOGS[indexDialog].choices.size() > 0):
				node.CHOICES = DIALOGS[indexDialog].choices
				if(not node.is_connected("choice_made",self,"choiceMade")):
					node.connect("choice_made",self,"choiceMade")
			node.dialog = DIALOGS[indexDialog].dialog
			node.startDialog()

# go to the next dialog if it is not done
func nextDialog():
	if(isStarted):
		if(indexDialog < DIALOGS.size() - 1):
			indexDialog += 1
			for target in DIALOGS[indexDialog].targets:
				if target is NodePath:
					var node = get_node(target)
					if(DIALOGS[indexDialog].choices and DIALOGS[indexDialog].choices > 0):
						node.CHOICES = DIALOGS[indexDialog]
						if(not node.is_connected("choice_made",self,"choiceMade")):
							node.connect("choice_made",self,"choiceMade")
					node.dialog = DIALOGS[indexDialog].dialog
					node.startDialog()
		else:
			isStarted = false
			emit_signal("dialogs_done")

func choiceMade(choice):
	print("Choice made : ", choice)
	emit_signal("choice_made",choice)
