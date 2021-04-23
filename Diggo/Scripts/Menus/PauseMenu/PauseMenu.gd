extends Control

export(String,FILE) var OPTION_MENU = "res://Scenes/Menus/OptionsMenu.tscn"
export(String,FILE) var MAIN_MENU = "res://Scenes/Menus/MainMenu.tscn"

var isPaused

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	if(SignalManager.connect("show_save_menu",self,"saveMenu") != OK):
		Logger.error("Error connecting signal \"show_save_menu\" to method \"saveMenu\"" + GlobalUtils.stack2String(get_stack()))
	$OptionsMenu.visible = false
	$SaveMenu.visible = false
	isPaused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("pause")):
		if(!isPaused):
			SoundManager.BGMFade(1,2000)
			visible = true
			isPaused = true
			get_tree().paused = true
		else:
			SoundManager.BGMFade(1,20000)
			visible = false
			isPaused = false
			get_tree().paused = false

# shows the save menu from game
func saveMenu():
	Input.action_press("pause") # forces the pause
	$SaveMenu.show()

# Hides the pause menu when pressed
func _on_ReturnButton_pressed():
	visible = false
	isPaused = false
	get_tree().paused = false
	SoundManager.BGMFade(1,20000)

# Shows the quit confirmation popup
func _on_MainMenuButton_pressed():
	$AcceptDialog.popup_centered_ratio(0.2)

# On popup accept, switch to the main menu scene
func _on_AcceptDialog_confirmed():
	visible = false
	isPaused = false
	get_tree().paused = false
	SwitchSceneWithParam.goto_scene(MAIN_MENU)

# Hides the current scene and shows the option menu
func _on_OptionsButton_pressed():
	$OptionsMenu.visible = true
