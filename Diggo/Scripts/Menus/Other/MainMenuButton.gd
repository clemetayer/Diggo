extends Button

export(String) var MAIN_MENU_SCENE = "res://Scenes/Menus/MainMenu.tscn"

func _on_MainMenuButton_pressed():
	if(get_tree().change_scene(MAIN_MENU_SCENE) != OK): # TODO : replace with custom loading
		printerr("Error in MainMenuButton -> _on_MainMenuButton_pressed -> change_scene (MAIN_MENU_SCENE)")
