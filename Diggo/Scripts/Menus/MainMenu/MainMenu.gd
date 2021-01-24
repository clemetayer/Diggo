extends Node2D

export(String,FILE)  var INTRO_SCENE = "res://Scenes/Levels/Mountains1/MainHouse2.tscn"

func _on_NewGameButton_pressed():
	get_tree().change_scene(INTRO_SCENE)

func _on_ContinueButton_pressed():
	SwitchSceneWithParam.change_scene("res://Scenes/Menus/SaveMenu.tscn",{"isSaveMenu":false})

func _on_QuitButton_pressed():
	get_tree().quit()
