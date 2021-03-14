extends Node2D

export(NodePath) var ELEMENT # Element that should move (Should be a KinematicBody or equivalent with a script for animation playing if needed)
							 # Note : get_node() needed to actually access it
export(bool) var IS_ON_FLOOR = true # true if the element is on floor
export(int) var SPEED = 500 # Standard speed
export(float) var ACCELERATION = 10 # Acceleration to get to standard speed mid air
export(float) var JUMP_POWER = 500 # Power of a jump
export(int) var GRAVITY = 10 # World's gravity

var floor_gravity = 100 # gravity value when on floor
var velocity = Vector2() # velocity of the element
var epsilon = 0.5 # epsilon to check the velocity x float around 0
var movementEnabled = true # true if the movement is enabled

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inputManager(delta)

# returns the current velocity associated to the character
func getVelocity():
	return velocity

# enable or disable the movement
func enableMovement(value):
	movementEnabled = value

# input function processing
func inputManager(delta):
	applyGravity(delta)
	if(Input.is_action_pressed("right") and movementEnabled):
		moveRight(delta)
	elif(Input.is_action_pressed("left") and movementEnabled):
		moveLeft(delta)
	elif(IS_ON_FLOOR):
		get_node(ELEMENT).setAnimation(GlobalUtils.AnimationEnum.Idle)
		velocity.x = 0
	else:
		get_node(ELEMENT).setAnimation(GlobalUtils.AnimationEnum.Jump)
		velocity.x /= 2 # Gently slows down in mid air
	if(Input.is_action_pressed("jump") and movementEnabled):
		jump()

# Adds gravity acceleration on the character if he's in the air
func applyGravity(delta):
	if(IS_ON_FLOOR):
		velocity.y = floor_gravity
	else:
		velocity.y += GRAVITY * delta * 100 # delta used to avoid different jump heights depending on fps

# jump action
func jump():
	if(IS_ON_FLOOR):
		velocity.y = -JUMP_POWER
		get_node(ELEMENT).setAnimation(GlobalUtils.AnimationEnum.Jump)

# moves element to the right
func moveRight(delta):
	get_node(ELEMENT).setFaceRight(true)
	if(IS_ON_FLOOR):
		velocity.x = SPEED
		get_node(ELEMENT).setAnimation(GlobalUtils.AnimationEnum.Run)
	else:
		velocity.x += (ACCELERATION * min(abs(SPEED - velocity.x),2*SPEED)) * delta # vf = vi + a * t, but capped at SPEED

# moves element to the left
func moveLeft(delta):
	get_node(ELEMENT).setFaceRight(false)
	if(IS_ON_FLOOR):
		velocity.x = -SPEED
		get_node(ELEMENT).setAnimation(GlobalUtils.AnimationEnum.Run)
	else:
		velocity.x -= (ACCELERATION * min(abs(SPEED + velocity.x), 2*SPEED)) * delta # vf = vi - a * t, but capped at SPEED
