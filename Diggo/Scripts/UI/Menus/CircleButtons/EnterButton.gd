extends TextureButton

export(String) var SCENE_PATH # Path of the scene to go

# when clicking on the door, switch to SCENE_PATH
func _on_EnterButton_pressed():
	if(get_tree().change_scene(SCENE_PATH) != OK): # LOGGER
			printerr("Error in EnterButton -> _on_EnterButton_pressed -> change_scene (SCENE_PATH)")
