extends Node2D

export (String,FILE) var KEY_COMMAND = "res://Scenes/Menus/KeyCommand.tscn"
export (String,FILE) var MAIN_MENU = "res://Scenes/Menus/MainMenu.tscn"
export (bool) var IS_FROM_PAUSE = false

# TODO : After managing presets, check that every command is implemented before updating with preset (or put "UNASSIGNED_KEY" ?)
# TODO : Actually change the keys at start/when modifying the keys
# TODO : Remove the ".json" at the end of the presets

var keyCommandLoad # instance of key command scene

# Called when the node enters the scene tree for the first time.
func _ready():
	keyCommandLoad = load(KEY_COMMAND)
	addPresets()
	addKeys()
	loadControlsPreset()
	loadAudioLevels()
	loadVideoParameters()
	if(not IS_FROM_PAUSE):
		$MarginContainer/HBoxContainer/MenusButtons/ReturnButton.visible = false
	else:
		$Camera2D.current = false

# sets the option button to the preset specified in parameters
func loadControlsPreset():
	$MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsOptions/PresetsCenter/PresetsHBox/PresetsButton.select(GlobalParameters.getCurrentPresetIndex())

# selects the video parameter defined in GlobalParameters
func loadVideoParameters():
	match(int(GlobalParameters.getScreenMode())):
		GlobalParameters.screenModes.FULL_SCREEN:
			$MarginContainer/HBoxContainer/TabContainer/Video/VideoMargin/VideoOptions/WindowType/WindowTypeOption.select(1)
		GlobalParameters.screenModes.WINDOWED:
			$MarginContainer/HBoxContainer/TabContainer/Video/VideoMargin/VideoOptions/WindowType/WindowTypeOption.select(0)

# loads the audio levels from parameters
func loadAudioLevels():
	$MarginContainer/HBoxContainer/TabContainer/Audio/AudioMargin/AudioOptions/Sliders/MarginMasterSlider/MasterSlider.value = GlobalParameters.getSoundMaster()
	$MarginContainer/HBoxContainer/TabContainer/Audio/AudioMargin/AudioOptions/Sliders/MarginMusicSlider/MusicSlider.value = GlobalParameters.getSoundMusic()
	$MarginContainer/HBoxContainer/TabContainer/Audio/AudioMargin/AudioOptions/Sliders/MarginFXSlider/FXSlider.value = GlobalParameters.getSoundFX()

# adds the preset names in PresetsButton
func addPresets():
	var presets = GlobalParameters.getPresets()
	for preset in presets:
		$MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsOptions/PresetsCenter/PresetsHBox/PresetsButton.add_item(preset)

# adds the keys in the controls panel
func addKeys():
	var commands = GlobalParameters.getCommands()
	for command in commands.keys():
		addKey(command,commands[command])

# removes all the keys
func resetKeys():
	GlobalUtils.removeAllChildren($MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsOptions/KeysMargin/KeysScroll/KeysContainer)

# adds the key with command in controls panel
func addKey(command,key):
	var keyCommandInstance = keyCommandLoad.instance()
	keyCommandInstance.COMMAND = command
	keyCommandInstance.KEY = key
	keyCommandInstance.connect("change_key",self,"changeKey")
	$MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsOptions/KeysMargin/KeysScroll/KeysContainer.add_child(keyCommandInstance)

# shows the popup to change the key
func changeKey(keyInstance):
	$MarginContainer/KeyChangePopup.currentCode = keyInstance.KEY
	$MarginContainer/KeyChangePopup.keyCommandInstance = keyInstance
	$MarginContainer/KeyChangePopup.setText()
	$MarginContainer/KeyChangePopup.popup_centered_ratio(0.25)

# when change key popup confirmed, change global controls
func _on_KeyChangePopup_key_changed(command, key):
	GlobalParameters.setCommand(command,key)

# TODO : add a borderless mode
# changes the window type (windowed or full screen)
func _on_WindowTypeOption_item_selected(index):
	match(index):
		0: # windowed
			GlobalParameters.setScreenMode(GlobalParameters.screenModes.WINDOWED)
		1: # full sreen
			GlobalParameters.setScreenMode(GlobalParameters.screenModes.FULL_SCREEN)

# shows the save preset popup
func _on_SavePresetButton_pressed():
	$MarginContainer/SavePresetPopup.popup_centered_ratio(0.15)

# saves the preset
func _on_SavePresetPopup_confirmed():
	var name = $MarginContainer/SavePresetPopup/PresetEdit.get_text()
	GlobalParameters.saveCommandsPreset(name)
	$MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsOptions/PresetsCenter/PresetsHBox/PresetsButton.add_item(name)
	var index = $MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsOptions/PresetsCenter/PresetsHBox/PresetsButton.get_item_count()-1
	$MarginContainer/HBoxContainer/TabContainer/Controls/ControlsMargin/ControlsOptions/PresetsCenter/PresetsHBox/PresetsButton.select(index)

# select the preset
func _on_PresetsButton_item_selected(index):
	GlobalParameters.setCommandsPreset(index)
	resetKeys()
	addKeys()

# when master value changed, changes it in global parameters
func _on_MasterSlider_value_changed(value):
	GlobalParameters.setSoundMaster(value)

# when music value changed, changes it in global parameters
func _on_MusicSlider_value_changed(value):
	GlobalParameters.setSoundMusic(value)

# TODO : play FX sound when changed
# when FX value changed, changes it in global parameters
func _on_FXSlider_value_changed(value):
	GlobalParameters.setSoundFX(value)

# saves the current parameters 
func _on_MainMenuButton_pressed():
	GlobalParameters.saveParameters()
	if(IS_FROM_PAUSE):
		$MarginContainer/AcceptMainMenu.popup_centered_ratio(0.25)
	else:
		get_tree().change_scene(MAIN_MENU)

# hides self (that should normally be in the pause menu in that case)
func _on_ReturnButton_pressed():
	GlobalParameters.saveParameters()
	visible = false

# saves the parameters, unpauses, and goes back to main menu 
func _on_AcceptMainMenu_confirmed():
	get_tree().paused = false
	get_tree().change_scene(MAIN_MENU)
