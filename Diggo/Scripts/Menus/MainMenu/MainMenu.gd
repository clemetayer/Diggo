extends Node2D

export(String,FILE) var INTRO_SCENE = "res://Scenes/Levels/Mountains1/DiggosMasterHouse.tscn" # First scene of the game (the one that should be launched at start)
export(String,FILE) var SAVE_MENU = "res://Scenes/Menus/SaveMenu.tscn" # Save menu scene
export(String,FILE) var OPTION_MENU = "res://Scenes/Menus/OptionsMenu.tscn" # Option menu scene
export(String,FILE) var MENU_MUSIC = "res://Scenes/Sound/BGM/TitleThemeStreamPlayer.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.playBGMWithFilter(MENU_MUSIC,2,8)

# launches the intro scene when "New game" pressed
func _on_NewGameButton_pressed():
	SwitchSceneWithParam.goto_scene(INTRO_SCENE)

# launches the save menu when "Continue" pressed
func _on_ContinueButton_pressed():
	SwitchSceneWithParam.change_scene(SAVE_MENU,{"isSaveMenu":false})

# Launches the option menu when "Options" pressed
func _on_OptionButton_pressed():
	get_tree().change_scene(OPTION_MENU)

# quits the game when pressing the quit button
func _on_QuitButton_pressed():
	get_tree().quit()
