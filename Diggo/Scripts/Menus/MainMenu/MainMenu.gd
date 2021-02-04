extends Node2D

export(String,FILE) var INTRO_SCENE = "res://Scenes/Levels/Mountains1/MainHouse2.tscn" # First scene of the game (the one that should be launched at start)

# launches the intro scene when "New game" pressed
func _on_NewGameButton_pressed():
	get_tree().change_scene(INTRO_SCENE)

# launches the save menu when "Continue" pressed
func _on_ContinueButton_pressed():
	SwitchSceneWithParam.change_scene("res://Scenes/Menus/SaveMenu.tscn",{"isSaveMenu":false})

# quits the game when pressing the quit button
func _on_QuitButton_pressed():
	get_tree().quit()
