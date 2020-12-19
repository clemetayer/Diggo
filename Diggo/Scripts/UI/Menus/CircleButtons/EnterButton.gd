extends TextureButton

export(String) var SCENE_PATH

func _on_EnterButton_pressed():
	get_tree().change_scene(SCENE_PATH)
