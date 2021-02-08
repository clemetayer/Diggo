extends Button

export(String) var MAIN_MENU_SCENE = "res://Scenes/Menus/MainMenu.tscn"

func _on_MainMenuButton_pressed():
	get_tree().change_scene(MAIN_MENU_SCENE)
