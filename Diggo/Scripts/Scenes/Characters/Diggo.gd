extends KinematicBody2D

# TODO : remove SPEED_DELTA to a better method
# TODO : divide a bit better the different responsiblities in this script

export var SPEED = 500 # Diggo standard speed
export var SPEED_DELTA = 50 # Diggo acceleration
export var MAX_SPEED = 500 # maximum diggo speed
export var DIG_SPEED = 100 # Diggo speed while digging
export var GRAVITY = 20 # world gravity acceleration
export var BASE_GRAVITY = 500 # gravity when on floor
export var JUMP_POWER = -900 # Diggo jump power
export var AIR_FRICTION = 1.5 # Diggo air acceleration/deceleration
export var FLOOR = Vector2(0,-1) # Vector position of the floor
export var DIG_RADIUS = 250 # Digging radius hitbox detection (to know if it is possible to dig)
export(NodePath) var PATH_FINDING # Path finding of Diggo (should be Navigation2D)
export(NodePath) var PATH_LINE # Line to show when pressing the button of path finding (should be Line2D)

var velocity = Vector2() # Diggo movement velocity
var isFacingRight = true # true if Diggo is facing right
var animationDone = true # true if the animation is done
var canDig = false # true if it is possible to dig (see checkTimerDig)
var keyPos = Vector2(1000,200) # position of desired key item for path finding


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	inputManager()
	move_and_slide(velocity,FLOOR)

# shows the path from diggo to keyPos in PATH_LINE
func getPath():
	if((PATH_FINDING != "") and (get_node(PATH_FINDING) is Navigation2D)):
		if((PATH_LINE != "") and (get_node(PATH_LINE) is Line2D)):
			get_node(PATH_LINE).points = get_node(PATH_FINDING).get_simple_path(position,keyPos)
		else:
			print("Error : Path line node not present or wrong type")
	else:
		print("Error : Path find node not present or wrong type")

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

# Adds gravity acceleration on diggo if he's in the air
func applyGravity():
	if(is_on_floor()):
		velocity.y = BASE_GRAVITY
	else:
		velocity.y += GRAVITY

# moves Diggo to the right
func moveRight():
	isFacingRight = true
	if(is_on_floor()):
		velocity.x = SPEED
		velocity.y = BASE_GRAVITY
		playAnimation("Run")
	elif(velocity.x < MAX_SPEED):
		velocity.x = velocity.x + SPEED_DELTA

# moves Diggo to the left
func moveLeft():
	isFacingRight = false
	if(is_on_floor()):
		velocity.x = -SPEED
		velocity.y = BASE_GRAVITY
		playAnimation("Run")
	elif(velocity.x > -MAX_SPEED):
		velocity.x = velocity.x - SPEED_DELTA

# jump action
func jump():
	if(is_on_floor()):
		velocity.y = JUMP_POWER
		playAnimation("Jump")
		animationDone = false

# set the possible interaction buttons, depending on the overlapping area
func setInteractButtons():
	var collidingAreas = get_node("InteractArea").get_overlapping_areas()
	for collidingArea in collidingAreas:
		if(collidingArea.has_method("getButtons")):
			var ButtonsArea = collidingArea.getButtons()
			get_node("CircleSelect").BUTTONS = ButtonsArea
			get_node("CircleSelect").refreshButtons()

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
	setScaleNodes()
	if(Input.is_action_just_pressed("interact")):
		setInteractButtons()
	if(Input.is_action_pressed("action") and canDig):
		if(canDig):
			dig()
	else:
		get_node("DigHitbox/DigCollision").set_disabled(true)
		checkTimerDig()
		set_rotation(0)
		applyGravity()
		if(Input.is_action_pressed("right")):
			moveRight()
		elif(Input.is_action_pressed("left")):
			moveLeft()
		elif(is_on_floor()):
			velocity.x = 0
			playAnimation("Idle")
		else:
			velocity.x /= AIR_FRICTION
		if(Input.is_action_pressed("jump")):
			jump()
		if(Input.is_action_just_pressed("find path")):
			getPath()

# plays the animation for diggo specified by the string in parameter
func playAnimation(animation):
	get_node("Animations").play(animation)

# on dig timeout, check if it is possible to keep digging
# see checkTimerDig function
func _on_CheckDigTimer_timeout():
	var AreasArray = get_node("DigTest").get_overlapping_areas()
	canDig = false
	for area in AreasArray:
		if area.is_in_group("DestructibleSpriteBlock"):
			canDig = true
	get_node("CheckDigTimer").start()
	
