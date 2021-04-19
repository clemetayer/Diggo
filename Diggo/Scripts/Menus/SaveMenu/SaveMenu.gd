extends Node2D

export(bool) var IS_SAVE_MENU = false # True if this is a save menu

var loadSaveButton = preload("res://Scenes/Menus/SaveFileButton.tscn") # load of the saveFile button
var newSaveButton = preload("res://Scenes/Menus/NewSaveButton.tscn") # load of the "New save" button

# starts when entering scene
func _ready():
	checkSceneParameters()
	if(not IS_SAVE_MENU): # disable the "Go back button"
		$Window/Elements/Banner/MainRetButtons/ReturnButton.hide()
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

# checks at start of the scene if the scene is actually a save or load menu
# this scene takes one parameter "IsSaveMenu" to see if you should load or save on click
func checkSceneParameters():
	var isSaveMenuParam = SwitchSceneWithParam.get_param("isSaveMenu")
	if(isSaveMenuParam != null):
		IS_SAVE_MENU = isSaveMenuParam

# adds an invisible rectangle at the end of the save menu to avoid an issue with the last button not being shown
func addInvisibleRect():
	var rect = ColorRect.new()
	rect.color = Color(0,0,0,0)
	rect.rect_size = Vector2(800,160)
	$Window/Elements/SaveButtons/CenterSaves/SavesVBox.add_child(rect)

# creates a "New save" button and adds it to the list of saves button at first place
func createNewSaveButton():
	var button = newSaveButton.instance()
	button.connect("new_file",self,"newFile")
	$Window/Elements/SaveButtons/CenterSaves/SavesVBox.add_child(button)
	$Window/Elements/SaveButtons/CenterSaves/SavesVBox.move_child(button,0)

# creates a button corresponding to the save and adds it to the list of saves button at place index
func createButton(save, index):
	var button = loadSaveButton.instance()
	button.save = save
	button.IS_SAVE_BUTTON = IS_SAVE_MENU
	button.showElements()
	button.connect("overwrite_save",self,"overwriteSave")
	button.connect("ask_delete",self,"askDelete")
	$Window/Elements/SaveButtons/CenterSaves/SavesVBox.add_child(button)
	$Window/Elements/SaveButtons/CenterSaves/SavesVBox.move_child(button,index)

# shows the SaveFileName popup
# when the signal "new_file" is received
func newFile():
	$SaveFileNamePopup.popup_centered_ratio(0.2)

# shows the EraseSave popup
# when the signal "ask_delete" is received
func askDelete(button):
	$EraseSavePopup.set_text("Are you really sure you want to delete " + button.getSaveName() + " ?")
	$EraseSavePopup.popup_centered_ratio(0.2)
	$EraseSavePopup.button = button

# shows the OverwriteFile popup
# when the signal "overwrite_save" is received
func overwriteSave(button):
	$OverwriteFilePopup/SaveFileName.set_text(button.getSaveName())
	$OverwriteFilePopup.button = button
	$OverwriteFilePopup.popup_centered_ratio(0.2)

# loads the current save loaded when pressing the "Return" button
func _on_ReturnButton_pressed():
	SaveFile.loadCurrentSave(get_tree())

# returns to the main menu when pressing the main menu button
func _on_MainMenuButton_pressed(): 
	SwitchSceneWithParam.goto_scene("res://Scenes/Menus/MainMenu.tscn")
