extends Node2D

# FIXME : fix a bit the tilemap looking a bit weird on some spots
# TODO : add warning panels in front of the cliff (add another panel each time the player jumps off the cliff)
# TODO : add a Game over transition if the player jumps off the cliff
# TODO : Game over screen + different texts each time the player jumps off the cliff

export(bool) var ADDITIONAL_LOADS = true # tells the scene switcher that there are additionnal resources to load on ready
export(Vector2) var LAUNCH_BALL_POS = Vector2(945,465) # position of the ball at launch

signal loaded() # signal to tell the scene switcher that everything is loaded

var cinematicPlaying # variable that tells if a cinematic is playing (to make the elements follow the scenario instead of having a normal behaviour)


# Called when the node enters the scene tree for the first time.
func _ready():
	$BallOfDestiny.hide()
	$DiggosOwnerAnim.scale.x = -abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = -abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	cinematicPlaying = true

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

func _on_DestructibleTilemap_destructible_loaded():
	emit_signal("loaded")
	$DiggosOwnerAnim.playIdleAnimation()
	$DiggoKinematic.enableMovement(false)
	$FirstDialog.startDialog()

func _on_FirstDialog_dialogs_done():
	$DiggoKinematic.enableMovement(true)
	$DiggosOwnerAnim.scale.x = abs($DiggosOwnerAnim.scale.x)
	$DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x = abs($DiggosOwnerAnim/diggosOwnerDialogBox.rect_scale.x)
	$DiggosOwnerAnim.playThrowBallAnimation()

func _on_DiggosOwnerAnim_throwDone(position):
	var throwPow = 400
	var angle = PI/5
	$BallOfDestiny.show()
	$BallOfDestiny.position = LAUNCH_BALL_POS
	$BallOfDestiny.apply_central_impulse(Vector2(cos(angle) * throwPow, -sin(angle) * throwPow))
