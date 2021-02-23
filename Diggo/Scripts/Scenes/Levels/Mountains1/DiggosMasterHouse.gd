extends Node2D

# TODO : create a better fire

export var DIALOG_DELAY = 2 # delay between the two dialogs

# Called when the node enters the scene tree for the first time.
func _ready():
	$DiggosMasterAnim.playSittingAnimation()
	$DiggosAnimations.playSleepingAnimation()
	$FirstDialog.startDialog()

# change Diggo eyes and sleep text when first dialog done
func _on_FirstDialog_dialogs_done():
	$SleepTextLabel.set_bbcode(BBCodeGenerator.BBCodeColor("!","yellow"))
	$DiggosAnimations.openEyes()
	$SleepTextLabel.set_scale(Vector2(4,4))
	yield(GlobalUtils.wait(DIALOG_DELAY),"completed")
	$SecondDialog.startDialog()

# switch to the "tutorial" scene
func _on_SecondDialog_dialogs_done():
	print("Goto tutorial scene")
