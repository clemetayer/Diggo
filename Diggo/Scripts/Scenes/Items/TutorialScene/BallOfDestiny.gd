extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$InteractShape/CollisionShape2D.disabled = false

# enables interactions with the ball
func enableInteract():
	$InteractShape/CollisionShape2D.disabled = false

# disables interactions with the ball
func disableInteract():
	$InteractShape/CollisionShape2D.disabled = true
