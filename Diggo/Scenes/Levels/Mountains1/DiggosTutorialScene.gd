extends Node2D

export(bool) var ADDITIONAL_LOADS = true # tells the scene switcher that there are additionnal resources to load on ready
export(String,FILE) var GAME_OVER_SCENE = "res://Scenes/Menus/GameOverScreen.tscn" # Game over scene
export(String,FILE) var HOME_SCENE = "res://Scenes/Menus/MainMenu.tscn" # TODO : replace here with next scene
export(String,FILE) var DIGGOS_MASTER_HOUSE_BGM = "res://Scenes/Sound/BGM/HomeTheme.tscn" # BGM of the tutorial scene
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
	SoundManager.addBGMToQueue(SoundManager.createParameters(DIGGOS_MASTER_HOUSE_BGM,true,2,true,2,true,32))
	SignalManager.emit_enable_interactions(true)
	setTutorialDialogs()
	setSaveData()
	setPathFind()
	sceneParam = SaveFile.currentData.getSceneParameter("tutorialScene")
	showSigns()
	$BallOfDestiny.hide()
	$BallOfDestiny.sleeping = true
	$BallOfDestiny.disableInteract()
	$DiggosOwnerAnim.scale.x = -abs($DiggosOwnerAnim.scale.x)
	cinematicPlaying = true
	gameOverLoading = false
	nbOfBallThrows = 0
	if(SignalManager.connect("catch_ball",self,"catchBall") != OK):
		Logger.error("Error connecting signal \"catch_ball\" to method \"catchBall\"" + GlobalUtils.stack2String(get_stack()))
	if(SignalManager.connect("diggo_owner_interact",self,"diggoOwnerInteract") != OK):
		Logger.error("Error connecting signal \"diggo_owner_interact\" to method \"diggoOwnerInteract\"" + GlobalUtils.stack2String(get_stack())) 
	if(SignalManager.connect("screen_shake",self,"screenShake") != OK):
		Logger.error("Error connecting signal \"screen_shake\" to method \"screenShake\"" + GlobalUtils.stack2String(get_stack())) 
	if(SignalManager.connect("diggo_anim_info",self,"diggoAnimInfo") != OK):
		Logger.error("Error connecting signal \"diggo_anim_info\" to method \"diggoAnimInfo\"" + GlobalUtils.stack2String(get_stack())) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(not cinematicPlaying):
		lookAtDiggo($DiggosOwnerAnim)

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
func lookAtDiggo(node):
	var diggo_pos = $DiggoKinematic.position
	if(diggo_pos > node.position):
		node.scale.x = abs(node.scale.x)
	else:
		node.scale.x = -abs(node.scale.x)

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

# ARCHITECTURE : move this in global bbcode script ?
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
	SignalManager.emit_enable_interactions(false)

func _on_FirstDialog_dialogs_done():
	$DiggoKinematic.enableMovement(true)
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim.playThrowBallAnimation()
	$Dialogs/Tutorial/MoveTutorial.startDialog()
	SignalManager.emit_enable_interactions(true)
	ballTaken = false
	nbOfBallThrows += 1

func _on_SecondDialog_dialogs_done():
	cinematicPlaying = true
	if($DiggoKinematic.position.x <= $DiggosOwnerAnim.position.x): # diggo on the left of owner
		$DiggoKinematic.setFaceRight(true)
	else: # diggo on the right of owner
		$DiggoKinematic.setFaceRight(false)
	$DiggosOwnerAnim.playGiveItem()

func _on_ThirdDialog_dialogs_done():
	cinematicPlaying = false
	$DiggoKinematic.enableMovement(false)
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim.playMegaThrowAnimation()
	$BallOfDestiny/TerraformArea.throwFeedback()
	ballTaken = false
	nbOfBallThrows += 1
	SignalManager.emit_enable_interactions(false)

func _on_FourthDialog_dialogs_done():
	$DiggoKinematic.enableMovement(true)
	$Dialogs/Tutorial/FindTutorial.startDialog()
	SignalManager.emit_enable_interactions(true)

func _on_LoopDialog_dialogs_done():
	$DiggoKinematic.enableMovement(true)
	cinematicPlaying = false
	SignalManager.emit_enable_interactions(true)

func _on_CatchBallDialog_dialogs_done():
	SignalManager.emit_enable_interactions(true)

func _on_BallDroppedDialog_dialogs_done():
	TransitionManager.standardFadeIn()
	yield(SignalManager,"fade_in_done")
	$DiggoKinematic.position = Vector2(1015,557)
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	TransitionManager.standardFadeOut()
	yield(SignalManager,"fade_out_done")
	SignalManager.emit_enable_interactions(true)
	if(nbOfBallThrows == 1):
		nbOfBallThrows = 0 # resets the number of throws
		$Dialogs/DiggosOwner/FirstDialog.startDialog()
		SignalManager.emit_enable_interactions(false)
	elif(nbOfBallThrows == 2):
		nbOfBallThrows = 1 # resets the number of throws
		$Dialogs/DiggosOwner/ThirdDialog.startDialog()
		SignalManager.emit_enable_interactions(false)
	else:
		$Dialogs/DiggosOwner/LoopDialog.startDialog()
		SignalManager.emit_enable_interactions(false)

func _on_DiggosOwnerAnim_throwDone(_position):
	var throwPow = 400
	var angle = PI/5
	$BallOfDestiny.show()
	$BallOfDestiny.sleeping = false
	$BallOfDestiny.position = $DiggosOwnerAnim.position + Vector2(60,-50)
	$BallOfDestiny.enableInteract()
	$BallOfDestiny.apply_central_impulse(Vector2(cos(angle) * throwPow, -sin(angle) * throwPow))
	$DiggosOwnerAnim.playIdleAnimation()
	cinematicPlaying = false
	PathFindingItems.setNodePath("ballOfReality",$BallOfDestiny.get_path())

func _on_DiggosOwnerAnim_megaThrowDone():
	$Dialogs/DiggosOwner/FourthDialog.startDialog()
	$BallOfDestiny.enableInteract()
	SignalManager.emit_enable_interactions(false)
	PathFindingItems.setNodePath("ballOfReality",$BallOfDestiny.get_path())

# signal function when catch ball signal received
func catchBall():
	$BallOfDestiny.sleeping = true
	$BallOfDestiny.hide()
	$BallOfDestiny.disableInteract()
	ballTaken = true
	PathFindingItems.setNodePath("ballOfReality",$DiggoKinematic.get_path())

# FIXME : when pressing space, it counts as pressing the button
# function when diggo_owner_interact signal received
func diggoOwnerInteract():
	if(ballTaken):
		SignalManager.emit_give_ball()
		ballTaken = false
		PathFindingItems.setNodePath("ballOfReality",$DiggosOwnerAnim.get_path())
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
	SignalManager.emit_enable_interactions(false)

# FIXME : not resetting the camera to default parameters
# shakes the screen
func screenShake(duration,frequency,amplitude,priority):
	GlobalUtils.shakeScreen($DiggoKinematic/DiggoCamera,duration,frequency,amplitude,priority)

# go to the mega throw dialog
func diggoAnimInfo(info):
	match(info):
		"EatAnimDone":
			cinematicPlaying = true
			$Dialogs/DiggosOwner/ThirdDialog.startDialog()
			SignalManager.emit_enable_interactions(false)
			$DiggoKinematic.animationOverrided = false

# Checks if something went out of the scene
func _on_CheckSceneItems_timeout():
	# Check the ball
	if(not $SceneSizeRect.get_rect().has_point($BallOfDestiny.position)): # ball out of the map
		$BallOfDestiny.position = Vector2(0,0)
		$BallOfDestiny.sleeping = true
		$BallOfDestiny.hide()
		$BallOfDestiny.disableInteract()
		PathFindingItems.setNodePath("ballOfReality",$DiggoKinematic.get_path())
		ballLost = true
	# check diggo
	if(not $SceneSizeRect.get_rect().has_point($DiggoKinematic.position) and not gameOverLoading): # diggo out of the map
		gameOverLoading = true
		TransitionManager.standardFadeIn()
		yield(SignalManager,"fade_in_done")
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
		$SaveTutorialCheckArea/SaveTutorialCheckCollision.call_deferred("set_disabled",false) # enables the save check area tutorial

# Starts the save tutorial
func _on_SaveTutorialCheckArea_body_entered(body):
	if(body.get_name() == "DiggoKinematic"):
		$Dialogs/Tutorial/SaveTutorial.startDialog()
		$SaveTutorialCheckArea.queue_free()
		$SaveTutorialCheckArea2/SaveTutorialCheckCollision2.call_deferred("set_disabled",false) # enables the second part check of the save area tutorial

# Starts the second part of the save tutorial
func _on_SaveTutorialCheckArea2_body_entered(body):
	if(body.get_name() == "DiggoKinematic"):
		$Dialogs/Tutorial/SaveTutorial2.startDialog()
		$SaveTutorialCheckArea2.queue_free()

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
			SignalManager.emit_enable_interactions(false)
		"endDialog":
			$Dialogs/DiggosOwner/LoopDialog.endDialog()
			$DiggoKinematic.enableMovement(true)
			ballTaken = true
			SignalManager.emit_enable_interactions(true)

# sets diggo eat animation
func _on_DiggosOwnerAnim_itemGiven():
	$DiggoKinematic.setAnimation(GlobalUtils.AnimationEnum.Eat)
	$DiggoKinematic.animationOverrided = true

