extends Control

export(float) var cycleTime = 4.0 # Time of a diggo cyle
export(float) var maxAngle = PI/4 # Tilt angle of diggo icon (in radians)
 
var mouseOver = false # boolean to check if the user is hovering the sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")
	$Polygons/EyesPet.visible = false
	$Polygons/EyesNormal.visible = true

# Called on input event
func _input(event):
	if mouseOver and event.is_pressed() and event.button_index == BUTTON_LEFT:
		$Polygons/EyesPet.visible = true
		$Polygons/EyesNormal.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_rotation(sin((2*PI/cycleTime)*OS.get_ticks_msec()/1000.0) * maxAngle)
	if(!mouseOver):
		$Polygons/EyesPet.visible = false
		$Polygons/EyesNormal.visible = true

# sets mouseOver to true
func _on_ClickContainer_mouse_entered():
	mouseOver = true

# sets mouseOver to false
func _on_ClickContainer_mouse_exited():
	mouseOver = false
