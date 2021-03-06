extends KinematicBody2D

# OPTIMIZATION : set a timer on dig hitbox to check more periodically
# TODO : Move the camera towards the mouse cursor

export var DIG_SPEED = 100 # Diggo speed while digging
export var DIG_RADIUS = 250 # Digging radius hitbox detection (to know if it is possible to dig)

var velocity = Vector2() # Diggo movement velocity
var animationDone = true # true if the animation is done
var canDig = true # true if it is possible to dig (see checkTimerDig)
var animation = GlobalUtils.AnimationEnum.Idle # current animation that should be playing (but can be ignored if needed)
var const_floor = Vector2(0,-1) # Vector position of the floor (note : floor is a keyword and cannot be used as a variable)
var animationOverrided = false # true if this is a specific animation that should override the animation of characterMovement
var movementOverrided = false # overrides the velocity value (for digging in that case)
var movementEnabled = true # true if diggo can move

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	setIsOnFloorCharacterMovement()
	inputManager()
	animationManager()
	if(not movementOverrided):
		velocity = $DiggoScales/CharacterMovement.getVelocity()
	var _vect = move_and_slide(velocity,const_floor)

# sets the is on floor status of the character movement script
func setIsOnFloorCharacterMovement():
	if(not movementOverrided):
		$DiggoScales/CharacterMovement.IS_ON_FLOOR = is_on_floor()
	else:
		$DiggoScales/CharacterMovement.IS_ON_FLOOR = true # stops the gravity effect when digging

# input function processing
func inputManager():
	if(Input.is_action_pressed("dig") and canDig and movementEnabled):
		movementOverrided = true
		if(canDig):
			dig()
	else:
		movementOverrided = false
		set_rotation(0)
		$DiggoScales/DigHitbox/DigCollision.set_disabled(true)

func animationManager():
	if(Input.is_action_pressed("dig") and canDig):
		$DiggoScales/DiggosAnimations.playDigAnimation()
	else:
		match(animation):
			GlobalUtils.AnimationEnum.Idle:
				$DiggoScales/DiggosAnimations.playIdleAnimation()
			GlobalUtils.AnimationEnum.Run:
				$DiggoScales/DiggosAnimations.playRunAnimation()
			GlobalUtils.AnimationEnum.Jump:
				$DiggoScales/DiggosAnimations.playJumpAnimation()
			GlobalUtils.AnimationEnum.Eat:
				$DiggoScales/DiggosAnimations.playEatAnimation()

func enableMovement(value):
	movementEnabled = value
	$DiggoScales/CharacterMovement.enableMovement(value)

# digs the floor
func dig():
	var digCollision = $DiggoScales/DigHitbox/DigCollision
	var mousePos = get_global_mouse_position()
	var mouseDiggoVector = position - mousePos
	if(mouseDiggoVector.x != 0):
		var angle = atan(mouseDiggoVector.y/mouseDiggoVector.x)
		if(mouseDiggoVector.x < 0):
			$DiggoScales.setFaceRight(true)
			set_rotation(angle)
			velocity = Vector2(cos(angle)*DIG_SPEED, sin(angle)*DIG_SPEED)
		elif(mouseDiggoVector.x > 0):
			$DiggoScales.setFaceRight(false)
			set_rotation(angle)
			velocity = Vector2(-cos(angle)*DIG_SPEED, -sin(angle)*DIG_SPEED)
	digCollision.set_disabled(false)

# at the end of the timer dig, checks if it is possible to keep digging
# to avoid issue that keeping the digging button pressed will keep digging, leading to diggo becoming super diggo, with the ability to dig the sky
func checkTimerDig():
	if(Input.is_action_pressed("action") and $CheckDigTimer.is_stopped()):
		$CheckDigTimer.start()
	elif(not Input.is_action_pressed("action")):
		canDig = false
		movementOverrided = false
		$CheckDigTimer.stop()

# sets the animation for diggo specified in GlobalUtils.AnimationEnum 
func setAnimation(pAnimation):
	if(not animationOverrided):
		self.animation = pAnimation

# sets the faceRightValue to val in parent (check DiggoScale.gd)
func setFaceRight(val):
	$DiggoScales.setFaceRight(val)

# on dig timeout, check if it is possible to keep digging
# see checkTimerDig function
func _on_CheckDigTimer_timeout():
	var AreasArray = $DiggoScales/DigTest.get_overlapping_areas()
	canDig = false
	for area in AreasArray:
		if area.is_in_group("DestructibleSpriteBlock"):
			canDig = true
	$CheckDigTimer.start()
	
