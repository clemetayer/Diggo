extends ConfirmationDialog

# FIXME : options des boutons de la souris non affichés
# TODO : mettre un margin container pour contenir les touches (pour que ça soit plus centré)
# FIXME : le popup ne spawn pas au bon endroit

export var currentCode = 0 # last key pressed as an int

var keyCommandInstance # KeyCommand instance where the button has been pressed

# Called when a new input is detected
func _input(event):
	if keyCommandInstance != null: # Not updating if keyCommandInstance not set
		if event is InputEventKey: # Keyboard input
			if event.scancode != currentCode : # to avoid updating the text at each key update
				currentCode = event.scancode
				setText()
		elif event is InputEventMouseButton: # Mouse input
			if event.button_mask != currentCode : # idem
				currentCode = event.button_mask
				setText()

# sets the text in popup with COMMAND/KEY
func setText():
	$KeyChangeText.set_bbcode(
		BBCodeGenerator.BBCodeCenter(
			"Enter a new key for action : " + 
			BBCodeGenerator.BBCodeColor(keyCommandInstance.COMMAND, "cyan") + 
			"\n\n" + 
			BBCodeGenerator.BBCodeColor(OS.get_scancode_string(currentCode), "yellow")
		)
	) 

func _on_KeyChangePopup_confirmed():
	keyCommandInstance.KEY = currentCode
	keyCommandInstance.refreshData()
