extends TextureButton

# when button clicked, go to save menu
func _on_SaveButton_pressed():
	SwitchSceneWithParam.change_scene("res://Scenes/Menus/SaveMenu.tscn", {"isSaveMenu":true})
