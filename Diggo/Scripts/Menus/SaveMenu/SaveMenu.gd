extends Node2D
#TODO : comment stuff
#FIXME : Somehow there are way too many savefiles shown when loading
#FIXME : Find a solution to prevent the list of save to look weird when scrolling up

export(int) var BUTTONS_OFFSET = 150
export(bool) var IS_SAVE_MENU = false

var loadSaveButton = preload("res://Scenes/Menus/SaveFileButton.tscn")
var saveButtons = []
var buttonAmount = 3

func _ready():
	checkSceneParameters()
	SaveFile.loadSaves()
	var saves = SaveFile.getSaves()
	var saveIndex = 0
	for save in saves:
		if(save != null): # drawback of the trick used to avoid an index update on save delete (check SaveFile.gd)
			createButton(save, saveIndex)
			saveIndex += 1
	addInvisibleRect()

# This scene takes one parameter "IsSaveMenu" to see if you should load or save on click
func checkSceneParameters(): #TODO: show/hide go back button when needed
	var isSaveMenuParam = SwitchSceneWithParam.get_param("isSaveMenu")
	if(isSaveMenuParam != null):
		IS_SAVE_MENU = isSaveMenuParam

func addInvisibleRect(): # In order to avoid an issue with the last button not being shown
	var rect = ColorRect.new()
	rect.color = Color(0,0,0,0)
	rect.rect_size = Vector2(800,160)
	$SaveButtons/SavesVBox.add_child(rect)

func createButton(save, index):
	var button = loadSaveButton.instance()
	button.save = save
	button.index = index
	button.IS_SAVE_MENU = IS_SAVE_MENU
	button.showElements()
	button.connect("overwrite_save",self,"overwriteSave")
	button.connect("new_file",self,"newFile")
	button.connect("ask_delete",self,"askDelete")
	$SaveButtons/SavesVBox.add_child(button)
	$SaveButtons/SavesVBox.move_child(button,index)

func newFile():
	$SaveFileNamePopup.popup_centered_ratio(0.5)

func reloadButtons():
	createButton(SaveFile.lastSave,1)

func askDelete(button):
	$EraseSavePopup.set_text("Are you really sure you want to delete " + button.getSaveName() + " ?")
	$EraseSavePopup.popup_centered_ratio(0.5)
	$EraseSavePopup.button = button

func overwriteSave(button):
	$OverwriteFilePopup/SaveFileName.set_text(button.getSaveName())
	$OverwriteFilePopup.button = button
	$OverwriteFilePopup.popup_centered_ratio(0.5)

func _on_BackButton_pressed():
	SaveFile.loadCurrentSave(get_tree())

func _on_MainMenuButton_pressed(): 
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")

func _on_SaveFileNamePopup_reload_buttons():
	reloadButtons()

func _on_OverwriteFilePopup_reload_buttons():
	reloadButtons()
