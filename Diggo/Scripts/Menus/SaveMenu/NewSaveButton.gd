extends TextureButton

signal new_file() # signal for the save menu to create a new save

# sends the new_file signal when the button is pressed
func _on_NewSaveButton_pressed():
	emit_signal("new_file")
