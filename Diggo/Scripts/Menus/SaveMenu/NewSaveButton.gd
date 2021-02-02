extends TextureButton

signal new_file()

func _on_NewSaveButton_pressed():
	emit_signal("new_file")
