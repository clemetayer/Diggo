extends Node2D

# NOTE : the only reason for this to exist is because setting the scale on kinematic bodies creates an odd behaviour

var isFacingRight = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	setScaleNodes()

# sets isFacingRight variable
func setFaceRight(val):
	isFacingRight = val

# sets the different scales, depending on diggo facing direction
func setScaleNodes():
	if(isFacingRight):
		set_scale(Vector2(abs(get_scale().x),get_scale().y))
		$CircleSelect.set_scale(Vector2(abs($CircleSelect.get_scale().x),$CircleSelect.get_scale().y))
	else:
		set_scale(Vector2(-abs(get_scale().x),get_scale().y))
		$CircleSelect.set_scale(Vector2(-abs($CircleSelect.get_scale().x),$CircleSelect.get_scale().y))
