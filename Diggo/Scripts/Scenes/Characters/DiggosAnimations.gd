extends Node2D

# ARCHITECTURE : maybe use an animation tree to avoid having things like "jump_with_item,etc."
# OPTIMIZATION : there is definitely a better architecture possible here

var hasBall = false
var stopJumpAnim = false
var isPlayingEat = false

func _ready():
	if(SignalManager.connect("catch_ball",self,"catchBall") != OK):
		Logger.error("Error connecting signal \"catch_ball\" to method \"catchBall\"" + GlobalUtils.stack2String(get_stack())) 
	if(SignalManager.connect("give_ball",self,"giveBall") != OK):
		Logger.error("Error connecting signal \"give_ball\" to method \"giveBall\"" + GlobalUtils.stack2String(get_stack())) 

# plays diggo's idle animation
func playIdleAnimation(speed=1):
	stopJumpAnim = false
	isPlayingEat = false
	if(hasBall):
		$AnimationPlayer.play("IdleWithBall")
	else:
		$AnimationPlayer.play("Idle")
	$AnimationPlayer.playback_speed = speed

# plays diggo's sleeping animation
func playSleepingAnimation(speed=1):
	stopJumpAnim = false
	$AnimationPlayer.play("Sleep")
	$AnimationPlayer.playback_speed = speed

# plays diggo's dig animation
func playDigAnimation(speed=1):
	stopJumpAnim = false
	if(hasBall):
		$AnimationPlayer.play("DigWithBall")
	else:
		$AnimationPlayer.play("Dig")
	$AnimationPlayer.playback_speed = speed

# plays diggo run animation
func playRunAnimation(speed=3):
	stopJumpAnim = false
	if(hasBall):
		$AnimationPlayer.play("RunWithBall")
	else:
		$AnimationPlayer.play("Run")
	$AnimationPlayer.playback_speed = speed

func playEatAnimation(speed=1):
	stopJumpAnim = false
	$AnimationPlayer.play("Eat")
	$AnimationPlayer.playback_speed = speed
	if(not isPlayingEat):
		isPlayingEat = true
		$Timers/EatTimer.start()

# plays diggo jump animation
func playJumpAnimation(speed=1): 
	if(not stopJumpAnim):
		if(hasBall):
			$AnimationPlayer.play("JumpWithBall")
		else:
			$AnimationPlayer.play("Jump")
		$AnimationPlayer.playback_speed = speed

# plays diggo wake up animation
func playWakeUpAnimation(speed=1):
	stopJumpAnim = false
	$AnimationPlayer.play("WakeUp")
	$AnimationPlayer.playback_speed = speed

# sets the "hasBall" to true after receiving the signal to catch ball
func catchBall():
	hasBall = true

# sets the "hasBall" to false after receiving the signal to give ball
func giveBall():
	hasBall = false

# sends the signal that the item was eaten
func _on_EatTimer_timeout(): 
	SignalManager.emit_diggo_anim_info("EatAnimDone")

func _on_AnimationPlayer_animation_finished(anim_name):
	match(anim_name):
		"Jump":
			stopJumpAnim = true
		"JumpWithBall":
			stopJumpAnim = true
