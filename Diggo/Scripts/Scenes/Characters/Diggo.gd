extends KinematicBody2D

# Declare member variables here. Examples:
# export global variables
export var SPEED = 500
export var SPEED_DELTA = 50
export var MAX_SPEED = 500
export var GRAVITY = 20
export var BASE_GRAVITY = 500
export var JUMP_POWER = -900
export var FLOOR = Vector2(0,-1)
export var DIG_RADIUS = 250

var velocity = Vector2()
var isFacingRight = true
var animationDone = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inputManager()
	move_and_slide(velocity,FLOOR)
	velocity.y += GRAVITY

func inputManager():
	if(Input.is_action_pressed("right")):
		if(is_on_floor()):
			velocity.x = SPEED
			velocity.y = BASE_GRAVITY
			playAnimation("Run")
		elif(velocity.x < MAX_SPEED):
			velocity.x = velocity.x + SPEED_DELTA
		if(not isFacingRight):
			isFacingRight = true
			self.scale.x = self.scale.x * -1
	elif(Input.is_action_pressed("left")):
		if(is_on_floor()):
			velocity.x = -SPEED
			velocity.y = BASE_GRAVITY
			playAnimation("Run")
		elif(velocity.x > -MAX_SPEED):
			velocity.x = velocity.x - SPEED_DELTA
		if(isFacingRight):
			isFacingRight = false
			self.scale.x = self.scale.x * -1
	elif(animationDone and is_on_floor()):
		velocity.x = 0
		velocity.y = BASE_GRAVITY
		playAnimation("Idle")
	elif(not is_on_floor()):
		if(velocity.x > 0):
			velocity.x = velocity.x - SPEED_DELTA
		elif(velocity.x < 0):
			velocity.x = velocity.x + SPEED_DELTA
	if(Input.is_action_pressed("jump")):
		if(is_on_floor()):
			velocity.y = JUMP_POWER
			playAnimation("Jump")
			animationDone = false
	if(Input.is_action_pressed("action")):
		var digCollision = get_node("DigHitbox/DigCollision")
		digCollision.set_disabled(false)
		var mousePos = get_global_mouse_position()
		var mouseDiggoVector = mousePos - position
		var angle = atan(mouseDiggoVector.y/mouseDiggoVector.x)
		if(mousePos.x >= position.x):
			digCollision.position = Vector2(cos(angle)*DIG_RADIUS, sin(angle)*DIG_RADIUS)
		else:
			digCollision.position = Vector2(-cos(angle)*DIG_RADIUS, -sin(angle)*DIG_RADIUS)
		var timer = get_node("DigTimeout")
		if(timer.is_stopped()):
			timer.start()

func playAnimation(animation):
	get_node("Animations").play(animation)

func _on_AnimatedSprite_animation_finished():
	animationDone = true

func _on_DigTimeout_timeout():
	get_node("DigHitbox/DigCollision").set_disabled(true)
