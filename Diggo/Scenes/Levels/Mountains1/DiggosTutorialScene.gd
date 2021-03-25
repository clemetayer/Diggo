extends Node2D

# FIXME : fix a bit the tilemap looking a bit weird on some spots
# TODO : add warning panels in front of the cliff (add another panel each time the player jumps off the cliff)
# TODO : add a Game over transition if the player jumps off the cliff
# TODO : Game over screen + different texts each time the player jumps off the cliff
# TODO : make a backup file for dialogs
# TODO : implement path finding menu

# TODO : <<<<<<<<<< HERE finish changing the dialogs >>>>>>>>>>>>>

export(bool) var ADDITIONAL_LOADS = true # tells the scene switcher that there are additionnal resources to load on ready
export(String,FILE) var GAME_OVER_SCENE = "res://Scenes/Menus/GameOverScreen.tscn" # Game over scene

signal loaded() # signal to tell the scene switcher that everything is loaded

var cinematicPlaying # variable that tells if a cinematic is playing (to make the elements follow the scenario instead of having a normal behaviour)
var nbOfBallThrows # variable to know how many times the ball was thrown
var ballTaken # true if diggo took the ball (to trigger specific dialogs)
var ballLost # true if the player lost the ball by moving it around

# Called when the node enters the scene tree for the first time.
func _ready():
	setTutorialDialogs()
	$BallOfDestiny.hide()
	$BallOfDestiny.sleeping = true
	$DiggosOwnerAnim.scale.x = -abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = -abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	cinematicPlaying = true
	nbOfBallThrows = 0
	SignalManager.connect("catch_ball",self,"catchBall")
	SignalManager.connect("diggo_owner_interact",self,"diggoOwnerInteract")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not cinematicPlaying):
		lookAtDiggo($DiggosOwnerAnim, $DiggosOwnerAnim/diggosOwnerDialogBox)

# makes a node look at diggo (while not reversing the dialogBox) # OPTIMIZATION : might not be the best way (from an architecture point of view)
func lookAtDiggo(node,dialogBox):
	var diggo_pos = $DiggoKinematic.position
	if(diggo_pos > node.position):
		node.scale.x = abs(node.scale.x)
		dialogBox.rect_scale.x = abs(dialogBox.rect_scale.x)
	else:
		node.scale.x = -abs(node.scale.x)
		dialogBox.rect_scale.x = -abs(dialogBox.rect_scale.x)

# sets the dialogs with BBCode for the tutorials
func setTutorialDialogs():
	var moveDialog = BBCodeGenerator.BBCodeColor(
		"To move, press  " + 
		BBCodeGenerator.BBCodeColor(
			InputMap.get_action_list("right")[0].as_text() + 
			"," + 
			InputMap.get_action_list("left")[0].as_text(), "#11DB00") +
		".", "#D8DB00")
	var interactDialog = BBCodeGenerator.BBCodeColor(
		"To interact with objects, approach it, then click on the appearing button." , "#D8DB00")
	var findDialog = BBCodeGenerator.BBCodeColor(
		"To locate an item, press " + 
		BBCodeGenerator.BBCodeColor(InputMap.get_action_list("find menu")[0].as_text(), "#11DB00") + 
		", select it, then press " + 
		BBCodeGenerator.BBCodeColor(InputMap.get_action_list("find path")[0].as_text(), "#11DB00") + 
		" to show a path to it.", "#D8DB00")
	var jumpDialog = BBCodeGenerator.BBCodeColor(
		"To jump, press  " + 
		BBCodeGenerator.BBCodeColor(
			InputMap.get_action_list("jump")[0].as_text(), "#11DB00") +
		".", "#D8DB00")
	var digDialog = BBCodeGenerator.BBCodeColor(
		"To dig, press  " + 
		BBCodeGenerator.BBCodeColor(
			InputMap.get_action_list("dig")[0].as_text(), "#11DB00") +
		". Keep in mind not everything can be dug.", "#D8DB00")
	$Dialogs/Tutorial/MoveTutorial.DIALOGS[0].dialog = moveDialog
	$Dialogs/Tutorial/InteractTutorial.DIALOGS[0].dialog = interactDialog
	$Dialogs/Tutorial/FindTutorial.DIALOGS[0].dialog = findDialog
	$Dialogs/Tutorial/JumpTutorial.DIALOGS[0].dialog = jumpDialog
	$Dialogs/Tutorial/DigTutorial.DIALOGS[0].dialog = digDialog

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
	nbOfBallThrows += 1

func _on_SecondDialog_dialogs_done():
	# TODO : implement give an orange animation
	cinematicPlaying = true
	$Dialogs/DiggosOwner/ThirdDialog.startDialog()

func _on_ThirdDialog_dialogs_done():
	# TODO : implement MEGA THROW
	$DiggoKinematic.enableMovement(true)
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	$DiggosOwnerAnim.playThrowBallAnimation()
	$Dialogs/Tutorial/FindTutorial.startDialog()
	nbOfBallThrows += 1

func _on_LoopDialog_dialogs_done():
	# TODO : find a way to add choices in dialogs
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

func _on_DiggosOwnerAnim_throwDone(position):
	var throwPow = 400
	var angle = PI/5
	$BallOfDestiny.show()
	$BallOfDestiny.sleeping = false
	$BallOfDestiny.position = $DiggosOwnerAnim.position + Vector2(60,-50)
	$BallOfDestiny.apply_central_impulse(Vector2(cos(angle) * throwPow, -sin(angle) * throwPow))
	$DiggosOwnerAnim.playIdleAnimation()
	cinematicPlaying = false

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
		$BallDroppedDialog.startDialog()
		ballLost = false
	else:
		$Dialogs/DiggosOwner/CatchBallDialog.startDialog()

# Checks if the ball is dropped out of the scene
func _on_CheckSceneItems_timeout():
	if(get_node_or_null("BallOfDestiny") != null and not $SceneSizeRect.get_rect().has_point($BallOfDestiny.position)): # ball out of the map
		$BallOfDestiny.queue_free()
		ballLost = true
	if(not $SceneSizeRect.get_rect().has_point($DiggoKinematic.position)): # diggo out of the map
		SwitchSceneWithParam.goto_scene(GAME_OVER_SCENE,{"gameOverDialog":["Ah, you might have slipped here, that's unfornate ...\n Try to avoid standing close to the ledge !"]})

# Starts the tutorial for interactions
func _on_InteractTutorialCheckArea_body_entered(body):
	if(body.get_name() == "DiggoKinematic"):
		$Dialogs/Tutorial/InteractTutorial.startDialog()

# Starts the jump tutorial
func _on_JumpTutorialCheckArea_body_entered(body):
	if(body.get_name() == "DiggoKinematic"):
		$Dialogs/Tutorial/JumpTutorial.startDialog()

# Starts the dig tutorial
func _on_DigTutorialCheckArea_body_entered(body):
	if(body.get_name() == "DiggoKinematic"):
		$Dialogs/Tutorial/DigTutorial.startDialog()
