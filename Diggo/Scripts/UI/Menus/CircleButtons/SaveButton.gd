extends TextureButton

func _on_SaveButton_pressed():
	SwitchSceneWithParam.change_scene("res://Scenes/Menus/SaveMenu.tscn", {"isSaveMenu":true})
