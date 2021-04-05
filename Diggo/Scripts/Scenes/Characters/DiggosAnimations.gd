extends Node2D

# TODO : maybe use "set_next_animation" ? idk
# TODO : maybe use an animation tree to avoid having things like "jump_with_item,etc."
# OPTIMIZATION : there is definitely a better architecture possible here

var hasBall = false

func _ready():
	if(SignalManager.connect("catch_ball",self,"catchBall") != OK):
		printerr("Error in DiggosAnimations -> _ready -> SignalManager -> connect (catch_ball)") # LOGGER
	if(SignalManager.connect("give_ball",self,"giveBall") != OK):
		printerr("Error in DiggosAnimations -> _ready -> SignalManager -> connect (give_ball)") # LOGGER

# plays diggo's idle animation
func playIdleAnimation(speed=1):
	openEyes()
	openMouth()
	if(hasBall):
		showBall()
		hideTongue()
		$AnimationPlayer.play("IdleWithBall")
	else:
		hideBall()
		showTongue()
		$AnimationPlayer.play("Idle")
	$AnimationPlayer.playback_speed = speed

# plays diggo's sleeping animation
func playSleepingAnimation(speed=1):
	closeEyes()
	closeMouth()
	$AnimationPlayer.play("Sleep")
	$AnimationPlayer.playback_speed = speed

# plays diggo's dig animation
func playDigAnimation(speed=1):
	openEyes()
	openMouth()
	if(hasBall):
		showBall()
		hideTongue()
		$AnimationPlayer.play("DigWithBall") # FIXME : it is looking weird
	else:
		hideBall()
		showTongue()
		$AnimationPlayer.play("Dig")
	$AnimationPlayer.playback_speed = speed

# plays diggo run animation
func playRunAnimation(speed=3):
	openEyes()
	openMouth()
	if(hasBall):
		showBall()
		hideTongue()
		$AnimationPlayer.play("RunWithBall")
	else:
		showTongue()
		hideBall()
		$AnimationPlayer.play("Run")
	$AnimationPlayer.playback_speed = speed


# plays diggo jump animation
func playJumpAnimation(speed=1): # FIXME : play this animation only once
	openEyes()
	openMouth()
	if(hasBall):
		showBall()
		hideTongue()
		$AnimationPlayer.play("JumpWithBall")
	else:
		hideBall()
		showTongue()
		$AnimationPlayer.play("Jump")
	$AnimationPlayer.playback_speed = speed

# changes the mouth to open
func openMouth():
	$Polygons/ClosedMouthHead.visible = false
	$Polygons/BottomHead.visible = true
	$Polygons/TopHead.visible = true
	$Polygons/Tongue.visible = true

# changes the mouth to closed
func closeMouth():
	$Polygons/ClosedMouthHead.visible = true
	$Polygons/BottomHead.visible = false
	$Polygons/TopHead.visible = false
	$Polygons/Tongue.visible = false

# changes the eyes to open eyes
func openEyes():
	$Polygons/Eyes.visible = true
	$Polygons/SleepEyes.visible = false

# changes the eyes to closed eyes
func closeEyes():
	$Polygons/Eyes.visible = false
	$Polygons/SleepEyes.visible = true

# hides the tongue
func hideTongue():
	$Polygons/Tongue.hide()

# shows the tongue
func showTongue():
	$Polygons/Tongue.show()

# shows the ball
func showBall():
	$Polygons/BallOfDestiny.show()

# hides the ball
func hideBall():
	$Polygons/BallOfDestiny.hide()

# sets the "hasBall" to true after receiving the signal to catch ball
func catchBall():
	hasBall = true

# sets the "hasBall" to false after receiving the signal to give ball
func giveBall():
	hasBall = false
