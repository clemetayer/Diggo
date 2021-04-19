extends ConfirmationDialog

signal key_changed(command,key)

export var currentCode = 0 # last key pressed as an int

var keyCommandInstance # KeyCommand instance where the button has been pressed

# Called when a new input is detected
func _input(event):
	if keyCommandInstance != null: # Not updating if keyCommandInstance not set
		if event is InputEventKey: # Keyboard input
			if event.scancode != currentCode : # to avoid updating the text at each key update
				currentCode = event.scancode
				setText()

# sets the text in popup with COMMAND/KEY
func setText():
	$KeyChangeCenter/KeyChangeVBox/KeyChangeText.set_bbcode(
		BBCodeGenerator.BBCodeCenter(
			"Enter a new key for action : " + 
			BBCodeGenerator.BBCodeColor(keyCommandInstance.COMMAND, "cyan") + 
			"\n\n" + 
			BBCodeGenerator.BBCodeColor(GlobalUtils.getInputAsString(currentCode), "yellow")
		)
	) 

# When key change done change key
func _on_KeyChangePopup_confirmed():
	keyCommandInstance.KEY = currentCode
	keyCommandInstance.refreshData()
	emit_signal("key_changed",keyCommandInstance.COMMAND,keyCommandInstance.KEY)

# When button "Mouse" pressed, show popup with various mouse buttons
func _on_MouseButton_pressed():
	$MouseButtonsPopup.popup_centered_ratio(0.3)

# When mouse key selected, update the key
func _on_MouseButtonsPopup_index_pressed(index):
	var mouseButtonText = $MouseButtonsPopup.get_item_text(index)
	currentCode = GlobalUtils.MouseInputEnum[mouseButtonText] 
	setText()
