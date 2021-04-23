extends TextureButton

export(String) var SCENE_PATH # Path of the scene to go

# when clicking on the door, switch to SCENE_PATH
func _on_EnterButton_pressed():
	SwitchSceneWithParam.goto_scene(SCENE_PATH)
