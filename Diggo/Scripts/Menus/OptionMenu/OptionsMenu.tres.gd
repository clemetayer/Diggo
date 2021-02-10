extends Node2D

export (String,FILE) var KEY_COMMAND = "res://Scenes/Menus/KeyCommand.tscn"

# TODO : After managing presets, check that every command is implemented before updating with preset (or put "UNASSIGNED_KEY" ?)

var keyCommandLoad # instance of key command scene

# Called when the node enters the scene tree for the first time.
func _ready():
	addPresets()
	keyCommandLoad = load(KEY_COMMAND)
	addKeys()

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
			OS.window_fullscreen = false
			GlobalParameters.setScreenMode(GlobalParameters.screenModes.FULL_SCREEN)
		1: # full sreen
			OS.window_fullscreen = true
			GlobalParameters.setScreenMode(GlobalParameters.screenModes.WINDOWED)
		

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

# TODO : implement change of preset here
func _on_PresetsButton_item_selected(index):
	pass
