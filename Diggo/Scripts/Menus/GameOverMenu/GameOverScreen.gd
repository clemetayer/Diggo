extends Control

# TODO : put a shader instead of a black background, with a cool moving gradient or something ...

export(String,FILE) var SAVE_MENU_PATH = "res://Scenes/Menus/SaveMenu.tscn"
export(String,FILE) var MAIN_MENU_PATH = "res://Scenes/Menus/MainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	if(not SaveFile.lastSaveExists()): # if no last save, cannot continue
		$CenterContainer/VBoxContainer/ContinueButton.hide()
	$DialogManager.startDialog()

# loads the last save
func _on_ContinueButton_pressed():
	SaveFile.loadLastSave(get_tree())

# loads the save menu
func _on_SaveMenuButton_pressed():
	var parameters = {"isSaveMenu":false}
	SwitchSceneWithParam.change_scene(SAVE_MENU_PATH,parameters)

# loads the main menu
func _on_MainMenuButton_pressed():
	get_tree().change_scene(MAIN_MENU_PATH)
