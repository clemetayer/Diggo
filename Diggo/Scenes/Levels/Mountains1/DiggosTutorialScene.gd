extends Node2D

# FIXME : fix the tilemap looking a bit weird on some spots
# TODO : add a Game over transition if the player jumps off the cliff

export(bool) var ADDITIONAL_LOADS = true # tells the scene switcher that there are additionnal resources to load on ready
export(String,FILE) var GAME_OVER_SCENE = "res://Scenes/Menus/GameOverScreen.tscn" # Game over scene
export(String,FILE) var HOME_SCENE = "res://Scenes/Menus/MainMenu.tscn" # TODO : replace here with next scene
export(Vector2) var DIGGO_EAT_POSITION = Vector2(1000,570)

signal loaded() # signal to tell the scene switcher that everything is loaded

var cinematicPlaying # variable that tells if a cinematic is playing (to make the elements follow the scenario instead of having a normal behaviour)
var nbOfBallThrows # variable to know how many times the ball was thrown
var ballTaken # true if diggo took the ball (to trigger specific dialogs)
var ballLost # true if the player lost the ball by moving it around
var sceneParam # saved scene parameters
var gameOverLoading # to avoid trying to load the game over scene multiple times

# Called when the node enters the scene tree for the first time.
func _ready():
	setTutorialDialogs()
	setSaveData()
	setPathFind()
	sceneParam = SaveFile.currentData.getSceneParameter("tutorialScene")
	showSigns()
	$BallOfDestiny.hide()
	$BallOfDestiny.sleeping = true
	$DiggosOwnerAnim.scale.x = -abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = -abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	cinematicPlaying = true
	gameOverLoading = false
	nbOfBallThrows = 0
	if(SignalManager.connect("catch_ball",self,"catchBall") != OK):
		printerr("Error in DiggoTutorialScene -> _ready -> SignalManager -> connect (catch_ball)") # LOGGER
	if(SignalManager.connect("diggo_owner_interact",self,"diggoOwnerInteract") != OK):
		printerr("Error in DiggoTutorialScene -> _ready -> SignalManager -> connect (diggo_owner_interact)") # LOGGER
	if(SignalManager.connect("screen_shake",self,"screenShake") != OK):
		printerr("Error in DiggoTutorialScene -> _ready -> SignalManager -> connect (screen_shake)") # LOGGER
	if(SignalManager.connect("diggo_anim_info",self,"diggoAnimInfo") != OK):
		printerr("Error in DiggoTutorialScene -> _ready -> SignalManager -> connect (diggo_anim_info)") # LOGGER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(not cinematicPlaying):
		lookAtDiggo($DiggosOwnerAnim, $DiggosOwnerAnim/diggosOwnerDialogBox)

# refreshes the save data when entering the scene
func setSaveData():
	SaveFile.currentData.setLocation({
		'locationName':'Diggo tutorial scene',
		'locationPath':'res://Scenes/Levels/Mountains1/DiggosTutorialScene.tscn'
	})
	SaveFile.setLastSafeSpot()

#  sets the path find variables
func setPathFind():
	PathFindingItems.setEnabled("ballOfReality",true)
	PathFindingItems.setNodePath("noItem",$DiggoKinematic.get_path())
	PathFindingItems.setNodePath("ballOfReality",$BallOfDestiny.get_path())
	$PathFinder.TARGET_START = $DiggoKinematic.get_path()
	$PathFinder.TARGET_END = PathFindingItems.getCurrentPath()

# makes a node look at diggo (while not reversing the dialogBox) # OPTIMIZATION : might not be the best way (from an architecture point of view)
func lookAtDiggo(node,dialogBox):
	var diggo_pos = $DiggoKinematic.position
	if(diggo_pos > node.position):
		node.scale.x = abs(node.scale.x)
		dialogBox.rect_scale.x = abs(dialogBox.rect_scale.x)
	else:
		node.scale.x = -abs(node.scale.x)
		dialogBox.rect_scale.x = -abs(dialogBox.rect_scale.x)

func showSigns():
	if(not sceneParam.nbOffCliff >= 1):
		$Signs/Sign2.queue_free()
	if(not sceneParam.nbOffCliff >= 2):
		$Signs/Sign3.queue_free()
	if(not sceneParam.nbOffCliff >= 3):
		$Signs/Sign4.queue_free()
	if(not sceneParam.nbOffCliff >= 4):
		$Signs/Sign5.queue_free()
	if(not sceneParam.nbOffCliff >= 5):
		$Signs/Sign6.queue_free()
	if(not sceneParam.nbOffCliff >= 6):
		$Signs/Sign7Block.queue_free()
		$Signs/Sign7.queue_free()

# sets the dialogs with BBCode for the tutorials
func setTutorialDialogs():
	var moveDialog = BBCodeGenerator.BBCodeColor(
		"To move, press  " + 
			formatKey(InputMap.get_action_list("right")[0]) + 
			"," + 
			formatKey(InputMap.get_action_list("left")[0]) +
		".", "#D8DB00")
	var interactDialog = BBCodeGenerator.BBCodeColor(
		"To interact with objects, approach it, then click on the appearing button." , "#D8DB00")
	var findDialog = BBCodeGenerator.BBCodeColor(
		"To locate an item, press " + 
			formatKey(InputMap.get_action_list("find menu")[0]) +
		", select it, then press " + 
			formatKey(InputMap.get_action_list("find path")[0]) +
		" to show a path to it.", "#D8DB00")
	var jumpDialog = BBCodeGenerator.BBCodeColor(
		"To jump, press  " + 
			formatKey(InputMap.get_action_list("jump")[0]) +
		".", "#D8DB00")
	var digDialog = BBCodeGenerator.BBCodeColor(
		"To dig, press  " + 
			formatKey(InputMap.get_action_list("dig")[0]) +
		". Keep in mind not everything can be dug.", "#D8DB00")
	$Dialogs/Tutorial/MoveTutorial.DIALOGS[0].dialog = moveDialog
	$Dialogs/Tutorial/InteractTutorial.DIALOGS[0].dialog = interactDialog
	$Dialogs/Tutorial/FindTutorial.DIALOGS[0].dialog = findDialog
	$Dialogs/Tutorial/JumpTutorial.DIALOGS[0].dialog = jumpDialog
	$Dialogs/Tutorial/DigTutorial.DIALOGS[0].dialog = digDialog

# formats the command to show in the rich text label
func formatKey(key):
	if(key is InputEventKey):
		return BBCodeGenerator.BBCodeColor(key.as_text(),"#11DB00")
	if(key is InputEventMouseButton):
		return BBCodeGenerator.BBCodeColor(GlobalUtils.getInputAsString(key.button_index),"#11DB00")

func _on_DestructibleTilemap_destructible_loaded():
	emit_signal("loaded")
	$DiggosOwnerAnim.playIdleAnimation()
	$DiggoKinematic.enableMovement(false)
	$Dialogs/DiggosOwner/FirstDialog.startDialog()

func _on_FirstDialog_dialogs_done():
	$DiggoKinematic.enableMovement(true)
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	$DiggosOwnerAnim.playThrowBallAnimation()
	$Dialogs/Tutorial/MoveTutorial.startDialog()
	ballTaken = false
	nbOfBallThrows += 1

func _on_SecondDialog_dialogs_done():
	cinematicPlaying = true
	if($DiggoKinematic.position.x <= $DiggosOwnerAnim.position.x): # diggo on the left of owner
		$DiggoKinematic.setFaceRight(true)
	else: # diggo on the right of owner
		$DiggoKinematic.setFaceRight(false)
	$DiggosOwnerAnim.playGiveItem()

func _on_ThirdDialog_dialogs_done(): # TODO : <<<<<<<<<<<<<here : enables movement after "catch !" dialog>>>>>>>>>>>>>>>>>>>
	$DiggoKinematic.enableMovement(false)
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	$DiggosOwnerAnim.playMegaThrowAnimation()
	$BallOfDestiny/TerraformArea.throwFeedback()
	ballTaken = false
	nbOfBallThrows += 1

func _on_FourthDialog_dialogs_done():
	$DiggoKinematic.enableMovement(true)
	$Dialogs/Tutorial/FindTutorial.startDialog()

func _on_LoopDialog_dialogs_done():
	$DiggoKinematic.enableMovement(true)
	cinematicPlaying = false

func _on_BallDroppedDialog_dialogs_done():
	# TODO : add a fade transition here and maybe reset the position of diggo
	add_child(load("res://Scenes/Interactibles/Items/BallOfDestiny.tscn").instance())
	$BallOfDestiny.sleeping = true
	$BallOfDestiny.hide()
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	if(nbOfBallThrows == 1):
		nbOfBallThrows = 0 # resets the number of throws
		$Dialogs/DiggosOwner/FirstDialog.startDialog()
	elif(nbOfBallThrows == 2):
		nbOfBallThrows = 1 # resets the number of throws
		$Dialogs/DiggosOwner/ThirdDialog.startDialog()
	else:
		$Dialogs/DiggosOwner/LoopDialog.startDialog()

func _on_DiggosOwnerAnim_throwDone(_position):
	var throwPow = 400
	var angle = PI/5
	$BallOfDestiny.show()
	$BallOfDestiny.sleeping = false
	$BallOfDestiny.position = $DiggosOwnerAnim.position + Vector2(60,-50)
	$BallOfDestiny.apply_central_impulse(Vector2(cos(angle) * throwPow, -sin(angle) * throwPow))
	$DiggosOwnerAnim.playIdleAnimation()
	cinematicPlaying = false

func _on_DiggosOwnerAnim_megaThrowDone():
	$Dialogs/DiggosOwner/FourthDialog.startDialog()

# signal function when catch ball signal received
func catchBall():
	$BallOfDestiny.sleeping = true
	$BallOfDestiny.hide()
	ballTaken = true

# FIXME : when pressing space, it counts as pressing the button
# function when diggo_owner_interact signal received
func diggoOwnerInteract():
	if(ballTaken):
		SignalManager.emit_give_ball()
		ballTaken = false
		$DiggoKinematic.enableMovement(false)
		if(nbOfBallThrows == 1): 
			$Dialogs/DiggosOwner/SecondDialog.startDialog()
		else:
			$Dialogs/DiggosOwner/LoopDialog.startDialog()
	elif(ballLost):
		cinematicPlaying = true
		$DiggoKinematic.enableMovement(false)
		$Dialogs/DiggosOwner/BallDroppedDialog.startDialog()
		ballLost = false
	else:
		$Dialogs/DiggosOwner/CatchBallDialog.startDialog()

# shakes the screen
func screenShake(duration,frequency,amplitude,priority):
	GlobalUtils.shakeScreen($DiggoKinematic/DiggoCamera,duration,frequency,amplitude,priority)

# go to the mega throw dialog
func diggoAnimInfo(info):
	match(info):
		"EatAnimDone":
			cinematicPlaying = true
			$Dialogs/DiggosOwner/ThirdDialog.startDialog()
			$DiggoKinematic.animationOverrided = false

# Checks if the ball is dropped out of the scene
func _on_CheckSceneItems_timeout():
	if(get_node_or_null("BallOfDestiny") != null and not $SceneSizeRect.get_rect().has_point($BallOfDestiny.position)): # ball out of the map
		$BallOfDestiny.queue_free()
		ballLost = true
	if(not $SceneSizeRect.get_rect().has_point($DiggoKinematic.position) and not gameOverLoading): # diggo out of the map
		gameOverLoading = true
		match(sceneParam.nbOffCliff):
			0:
				SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["Ah, you might have slipped here, that's unfornate ...\n Try to avoid standing close to the ledge !"]})
			1:
				SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["Again ? You should really be more careful ..."]})
			2:
				SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["Come on ! I even put more signs in front of this cliff !"]})
			3:
				SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["Oh, that's right, dogs can't read ..."]})
			4:
				SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["Why are you so determined to die ??? The game hasn't even started yet !"]})
			5: 
				SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["I'm starting to be bored ..."]})
			_:# > 5
				SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["..."]})
		var newSceneParam = sceneParam
		newSceneParam.nbOffCliff += 1
		SaveFile.currentData.setSceneParameter("nbOffCliff", newSceneParam)

# Starts the tutorial for interactions
func _on_InteractTutorialCheckArea_body_entered(body):
	if(body.is_in_group("Player")):
		$Dialogs/Tutorial/InteractTutorial.startDialog()
		$InteractTutorialCheckArea.queue_free()

# Starts the jump tutorial
func _on_JumpTutorialCheckArea_body_entered(body):
	if(body.get_name() == "DiggoKinematic"):
		$Dialogs/Tutorial/JumpTutorial.startDialog()
		$JumpTutorialCheckArea.queue_free()

# Starts the dig tutorial
func _on_DigTutorialCheckArea_body_entered(body):
	if(body.get_name() == "DiggoKinematic"):
		$Dialogs/Tutorial/DigTutorial.startDialog()
		$DigTutorialCheckArea.queue_free()

# loop dialog choices
func _on_LoopDialog_choice_made(signal_name):
	match(signal_name):
		"goHome":
			SwitchSceneWithParam.goto_scene(HOME_SCENE) 
		"notGoHome":
			$Dialogs/DiggosOwner/LoopDialog.nextDialog()
		"throwBall":
			$Dialogs/DiggosOwner/LoopDialog.endDialog()
			$Dialogs/DiggosOwner/FirstDialog.startDialog()
		"endDialog":
			$Dialogs/DiggosOwner/LoopDialog.endDialog()
			$DiggoKinematic.enableMovement(true)
			ballTaken = true

# sets diggo eat animation
func _on_DiggosOwnerAnim_itemGiven():
	$DiggoKinematic.setAnimation(GlobalUtils.AnimationEnum.Eat)
	$DiggoKinematic.animationOverrided = true

