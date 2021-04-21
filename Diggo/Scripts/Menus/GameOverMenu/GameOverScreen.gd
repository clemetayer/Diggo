extends Control

# TODO : put a shader instead of a black background, with a cool moving gradient or something ...

export(String,FILE) var SAVE_MENU_PATH = "res://Scenes/Menus/SaveMenu.tscn"
export(String,FILE) var MAIN_MENU_PATH = "res://Scenes/Menus/MainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	TransitionManager.standardFadeOut(1)
	yield(SignalManager,"fade_out_done")
	var gameOverDialog = SwitchSceneWithParam.get_param("gameOverDialog")
	if(gameOverDialog != null and gameOverDialog is Array):
		$GameOverDialogManager.DIALOGS = []
		for dialog in gameOverDialog:
			addGameOverDialog(dialog)
	$GameOverDialogManager.startDialog()

# Adds the game over dialog to the dialog manager
func addGameOverDialog(dialog):
	$GameOverDialogManager.DIALOGS.append({
		"targets":[
			NodePath("../CenterContainer/VBoxContainer/GameOverDialog") # Note : path from the dialog manager
		],
		"dialog":dialog
	})

# loads the last safe spot
func _on_ContinueButton_pressed():
	SaveFile.loadLastSafeSpot(get_tree())

# loads the save menu
func _on_SaveMenuButton_pressed():
	var parameters = {"isSaveMenu":false}
	SwitchSceneWithParam.goto_scene(SAVE_MENU_PATH,parameters)

# loads the main menu
func _on_MainMenuButton_pressed():
	SwitchSceneWithParam.goto_scene(MAIN_MENU_PATH)
