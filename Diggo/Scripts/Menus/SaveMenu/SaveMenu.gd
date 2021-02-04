extends Node2D

export(int) var BUTTONS_OFFSET = 150
export(bool) var IS_SAVE_MENU = false

var loadSaveButton = preload("res://Scenes/Menus/SaveFileButton.tscn")
var newSaveButton = preload("res://Scenes/Menus/NewSaveButton.tscn")
var saveButtons = []

func _ready():
	checkSceneParameters()
	if(not IS_SAVE_MENU):
		$BackButton.hide()
	var saves = SaveFile.getSaves()
	var saveIndex = 0
	if(IS_SAVE_MENU):
		createNewSaveButton()
		saveIndex += 1
	for save in saves:
		if(is_instance_valid(save)): # drawback of the trick used to avoid an index update on save delete (check SaveFile.gd)
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

func createNewSaveButton():
	var button = newSaveButton.instance()
	button.connect("new_file",self,"newFile")
	$SaveButtons/SavesVBox.add_child(button)
	$SaveButtons/SavesVBox.move_child(button,0)

func createButton(save, index):
	var button = loadSaveButton.instance()
	button.save = save
	button.IS_SAVE_BUTTON = IS_SAVE_MENU
	button.showElements()
	button.connect("overwrite_save",self,"overwriteSave")
	button.connect("ask_delete",self,"askDelete")
	$SaveButtons/SavesVBox.add_child(button)
	$SaveButtons/SavesVBox.move_child(button,index)

func newFile():
	$SaveFileNamePopup.popup_centered_ratio(0.5)

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
