extends Node

const COMMANDS_SAVE_PATH = "user://commands/" # path to folder where the commands presets are stored
const PARAMETERS_SAVE_PATH = "user://diggo-parameters.json" # path to save parameters file

enum screenModes {WINDOWED, FULL_SCREEN}

# list of all command presets (only the name, to avoid loading useless presets and occupy memory)
var commandPresets = []

# commands assigned to keys, see https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-keylist
var commands = {
	"up": KEY_Z,
	"down": KEY_S,
	"left": KEY_Q,
	"right": KEY_D,
	"action": BUTTON_LEFT,
	"jump": KEY_SPACE,
	"find path": KEY_F,
	"interact": KEY_I
}

# current parameters selected
var parameters = {
	"commandsPreset":"Preset1",
	"sounds": {
		"master":100,
		"music":100,
		"fx":100
	},
	"screenMode": screenModes.WINDOWED
}

# Called when the node enters the scene tree for the first time.
func _ready():
	loadCommandsPresetsNames()
	loadParameters()
	loadPresetWithName(getCommandsPreset())
	

# saves the current commands preset at COMMANDS_SAVE_PATH/<presetName>.json
func saveCommandsPreset(presetName):
	var dir = Directory.new()
	if dir.open(COMMANDS_SAVE_PATH) != OK: # if folder does not exist
		dir.make_dir(COMMANDS_SAVE_PATH)
	var file = File.new()
	file.open(COMMANDS_SAVE_PATH + str(presetName) + ".json", File.WRITE)
	file.store_string(to_json(commands))
	file.close()

# loads the valid save presets names
func loadCommandsPresetsNames():
	var dir = Directory.new()
	if dir.open(COMMANDS_SAVE_PATH) == OK: # Directory exists
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "": # analyse the files
			if dir.current_is_dir(): # if file analysed is a directory
				print("Found directory: " + file_name + ", ignoring")
			else: 
				if(file_name.ends_with(".json")): # check if it is a JSON file
					if(isCommandFileValid(file_name)): # if file is valid
						commandPresets.append(file_name)
			file_name = dir.get_next()
	else: # Directory does not exist
		print("Commands directory does not exist, creating...")
		saveCommandsPreset("BasePreset")
		yield(GlobalUtils.wait(0.25),"completed") # wait for writing to end
		loadCommandsPresetsNames()

# checks if save file is valid
func isCommandFileValid(fileName):
	var file = File.new()
	file.open(COMMANDS_SAVE_PATH + str(fileName), File.READ)
	var parametersData = parse_json(file.get_as_text())
	file.close()
	if typeof(parametersData) == TYPE_DICTIONARY:
		return true
	else:
		return false

# load a specific command preset corresponding to presetName
func loadPresetWithName(presetName):
	var file = File.new()
	if file.file_exists(COMMANDS_SAVE_PATH + str(presetName)):
		file.open(COMMANDS_SAVE_PATH + str(presetName), File.READ)
		var presetData = parse_json(file.get_as_text())
		file.close()
		if typeof(presetData) == TYPE_DICTIONARY:
			commands = presetData
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

# saves the current parameters at PARAMETERS_SAVE_PATH
func saveParameters():
	var file = File.new()
	file.open(PARAMETERS_SAVE_PATH, File.WRITE)
	file.store_string(to_json(parameters))
	file.close()

# loads the current parameters at PARAMETERS_SAVE_PATH
func loadParameters():
	var file = File.new()
	if file.file_exists(PARAMETERS_SAVE_PATH):
		file.open(PARAMETERS_SAVE_PATH, File.READ)
		var parametersData = parse_json(file.get_as_text())
		file.close()
		if typeof(parametersData) == TYPE_DICTIONARY:
			parameters = parametersData
		else:
			printerr("Corrupted data!")
	else: 
		print("No saved data, creating parameter file ...")
		saveParameters()

# returns the array of presets names
func getPresets():
	return commandPresets

# getters/setters for commands object
## every command
func getCommands():
	return commands

# one command
func getCommand(command): # UNUSED?
	return commands[command]

func setCommand(command,key):
	commands[command] = key

# getters/setters for parameters object
## Command preset name
func getCommandsPreset():
	return parameters.commandsPreset

func setCommandsPreset(presetName):
	parameters.commandsPreset = presetName

## master sound volume
func getSoundMaster():
	return parameters.sounds.master

func setSoundMaster(percentage):
	parameters.sounds.master = percentage

## music sound volume
func getSoundMusic():
	return parameters.sounds.music

func setSoundMusic(percentage):
	parameters.sounds.music = percentage

## fx sound volume
func getSoundFX():
	return parameters.sounds.fx

func setSoundFX(percentage):
	parameters.sounds.fx = percentage

# screen mode
func getScreenMode():
	return parameters.screenMode

func setScreenMode(mode):
	parameters.screenMode = mode
