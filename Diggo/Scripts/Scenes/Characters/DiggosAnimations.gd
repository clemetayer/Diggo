extends Node2D

# plays diggo's idle animation
func playIdleAnimation():
	openEyes()
	openMouth()
	$AnimationPlayer.play("Idle")

# plays diggo's sleeping animation
func playSleepingAnimation():
	closeEyes()
	closeMouth()
	$AnimationPlayer.play("Sleep")

# plays diggo's dig animation
func playDigAnimation():
	openEyes()
	openMouth()
	$AnimationPlayer.play("Dig")

# plays diggo run animation
func playRunAnimation():
	openEyes()
	openMouth()
	$AnimationPlayer.play("Run")

# plays diggo jump animation
func playJumpAnimation():
	openEyes()
	openMouth()
	$AnimationPlayer.play("Jump")

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
