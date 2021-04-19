extends Node2D

# TODO : create a better fire

export(String,FILE) var DIGGOS_MASTER_HOUSE_BGM = "res://Scenes/Sound/BGM/HomeTheme.tscn"
export var DIALOG_DELAY = 2 # delay between the two dialogs

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.addBGMToQueue(SoundManager.createParameters(DIGGOS_MASTER_HOUSE_BGM,true,8,true,2,true,0,32))
	$DiggosMasterAnim.playSittingAnimation()
	$DiggosAnimations.playSleepingAnimation()
	$FirstDialog.startDialog()
	setSaveData()

# refreshes the save data when entering the scene
func setSaveData():
	SaveFile.currentData.setLocation({
		'locationName':'Diggo introduction',
		'locationPath':'res://Scenes/Levels/Mountains1/DiggoIntro.tscn'
	})

# change Diggo eyes and sleep text when first dialog done
func _on_FirstDialog_dialogs_done():
	$SleepTextLabel.set_bbcode(BBCodeGenerator.BBCodeColor("!","yellow"))
	$DiggosAnimations.playWakeUpAnimation()
	$SleepTextLabel.set_scale(Vector2(4,4))
	yield(GlobalUtils.wait(DIALOG_DELAY),"completed")
	$SecondDialog.startDialog()

# switch to the "tutorial" scene
func _on_SecondDialog_dialogs_done():
	SwitchSceneWithParam.goto_scene("res://Scenes/Levels/Mountains1/DiggosTutorialScene.tscn")
