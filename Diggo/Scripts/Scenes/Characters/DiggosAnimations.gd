extends Node2D

# plays diggo's idle animation
func playIdleAnimation(speed=1):
	openEyes()
	openMouth()
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
	$AnimationPlayer.play("Dig")
	$AnimationPlayer.playback_speed = speed

# plays diggo run animation
func playRunAnimation(speed=3):
	openEyes()
	openMouth()
	$AnimationPlayer.play("Run")
	$AnimationPlayer.playback_speed = speed

# plays diggo jump animation
func playJumpAnimation(speed=1):
	openEyes()
	openMouth()
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
