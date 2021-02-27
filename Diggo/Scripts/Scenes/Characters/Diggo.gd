extends KinematicBody2D

export var DIG_SPEED = 100 # Diggo speed while digging
export var DIG_RADIUS = 250 # Digging radius hitbox detection (to know if it is possible to dig)

var velocity = Vector2() # Diggo movement velocity
var isFacingRight = true # true if Diggo is facing right
var animationDone = true # true if the animation is done
var canDig = false # true if it is possible to dig (see checkTimerDig)
var animation = GlobalUtils.AnimationEnum.Idle # current animation that should be playing (but can be ignored if needed)
var const_floor = Vector2(0,-1) # Vector position of the floor (note : floor is a keyword and cannot be used as a variable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	setIsOnFloorCharacterMovement()
	setScaleNodes()
	inputManager()
	animationManager()

# sets the is on floor status of the character movement script
func setIsOnFloorCharacterMovement():
	$CharacterMovement.IS_ON_FLOOR = is_on_floor()

# sets the different scales, depending on diggo facing direction
func setScaleNodes():
	scale.y = 0.25
	if(isFacingRight):
		set_scale(Vector2(0.25,0.25))
		get_node("CircleSelect").set_scale(Vector2(1,1))
	else:
		set_scale(Vector2(-0.25,0.25))
		get_node("CircleSelect").set_scale(Vector2(-1,1))

# input function processing
func inputManager():
	if(Input.is_action_pressed("dig") and canDig):
		if(canDig):
			dig()
	else:
		move_and_slide($CharacterMovement.getVelocity(),const_floor)

func animationManager():
	if(Input.is_action_pressed("dig")):
		$DiggosAnimations.playDigAnimation()
	else:
		match(animation):
			GlobalUtils.AnimationEnum.Idle:
				$DiggosAnimations.playIdleAnimation()
			GlobalUtils.AnimationEnum.Run:
				$DiggosAnimations.playRunAnimation()
			GlobalUtils.AnimationEnum.Jump:
				$DiggosAnimations.playJumpAnimation()

# digs the floor
func dig():
	set_scale(Vector2(0.25,0.25))
	get_node("Animations").play("Digging")
	var digCollision = get_node("DigHitbox/DigCollision")
	var mousePos = get_global_mouse_position()
	var mouseDiggoVector = mousePos - position
	if(mouseDiggoVector.x != 0):
		var angle = atan(mouseDiggoVector.y/mouseDiggoVector.x)
		if(mousePos.x >= position.x):
			set_rotation(angle)
			velocity = Vector2(cos(angle)*DIG_SPEED, sin(angle)*DIG_SPEED)
		else:
			set_rotation(angle - PI)
			velocity = Vector2(-cos(angle)*DIG_SPEED, -sin(angle)*DIG_SPEED)
		digCollision.set_disabled(false)

# at the end of the timer dig, checks if it is possible to keep digging
# to avoid issue that keeping the digging button pressed will keep digging, leading to diggo becoming super diggo, with the ability to dig the sky
func checkTimerDig():
	if(Input.is_action_pressed("action") and get_node("CheckDigTimer").is_stopped()):
		get_node("CheckDigTimer").start()
	elif(not Input.is_action_pressed("action")):
		canDig = false
		get_node("CheckDigTimer").stop()

# sets the animation for diggo specified in GlobalUtils.AnimationEnum 
func setAnimation(animation):
	self.animation = animation

func setFaceRight(val):
	isFacingRight = val

# on dig timeout, check if it is possible to keep digging
# see checkTimerDig function
func _on_CheckDigTimer_timeout():
	var AreasArray = get_node("DigTest").get_overlapping_areas()
	canDig = false
	for area in AreasArray:
		if area.is_in_group("DestructibleSpriteBlock"):
			canDig = true
	get_node("CheckDigTimer").start()
	
