extends TextureButton

# when button clicked, go to save menu
func _on_SaveButton_pressed():
	SignalManager.emit_show_save_menu()
