extends TextureButton

# emits the signal that this button was pressed
func _on_DiggosOwnerButton_pressed():
	SignalManager.emit_diggo_owner_interact()
