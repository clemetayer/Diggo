extends KinematicBody2D

# Declare member variables here. Examples:
# export global variables
export var SPEED = 500
export var SPEED_DELTA = 50
export var MAX_SPEED = 500
export var DIG_SPEED = 100
export var GRAVITY = 20
export var BASE_GRAVITY = 500
export var JUMP_POWER = -900
export var AIR_FRICTION = 1.5
export var FLOOR = Vector2(0,-1)
export var DIG_RADIUS = 250

var velocity = Vector2()
var isFacingRight = true
var animationDone = true
var canDig = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inputManager()
	move_and_slide(velocity,FLOOR)

func inputManager():
	if(Input.is_action_pressed("action") and canDig):
		if(canDig):
			set_scale(Vector2(0.25,0.25))
			get_node("Animations").play("Digging")
			var digCollision = get_node("DigHitbox/DigCollision")
			var mousePos = get_global_mouse_position()
			var mouseDiggoVector = mousePos - position
			var angle = atan(mouseDiggoVector.y/mouseDiggoVector.x)
			if(mousePos.x >= position.x):
				set_rotation(angle)
				velocity = Vector2(cos(angle)*DIG_SPEED, sin(angle)*DIG_SPEED)
			else:
				set_rotation(angle - PI)
				velocity = Vector2(-cos(angle)*DIG_SPEED, -sin(angle)*DIG_SPEED)
			digCollision.set_disabled(false)
	else:
		get_node("DigHitbox/DigCollision").set_disabled(true)
		if(Input.is_action_pressed("action") and get_node("CheckDigTimer").is_stopped()):
			get_node("CheckDigTimer").start()
		elif(not Input.is_action_pressed("action")):
			canDig = false
			get_node("CheckDigTimer").stop()
		set_rotation(0)
		if(is_on_floor()):
			velocity.y = BASE_GRAVITY
		else:
			velocity.y += GRAVITY
		if(Input.is_action_pressed("right")):
			set_scale(Vector2(0.25,0.25))
			if(is_on_floor()):
				velocity.x = SPEED
				velocity.y = BASE_GRAVITY
				playAnimation("Run")
			elif(velocity.x < MAX_SPEED):
				velocity.x = velocity.x + SPEED_DELTA
		elif(Input.is_action_pressed("left")):
			set_scale(Vector2(-0.25,0.25))
			if(is_on_floor()):
				velocity.x = -SPEED
				velocity.y = BASE_GRAVITY
				playAnimation("Run")
			elif(velocity.x > -MAX_SPEED):
				velocity.x = velocity.x - SPEED_DELTA
		elif(is_on_floor()):
			velocity.x = 0
			velocity.y = BASE_GRAVITY
			playAnimation("Idle")
		else:
			velocity.x /= AIR_FRICTION
		if(Input.is_action_pressed("jump")):
			if(is_on_floor()):
				velocity.y = JUMP_POWER
				playAnimation("Jump")
				animationDone = false
		scale.y = 0.25

func playAnimation(animation):
	get_node("Animations").play(animation)


func _on_CheckDigTimer_timeout():
	var AreasArray = get_node("DigTest").get_overlapping_areas()
	canDig = false
	for area in AreasArray:
		if area.is_in_group("DestructibleSpriteBlock"):
			canDig = true
	get_node("CheckDigTimer").start()
	
