extends Line2D

export(float) var ATTACK_ANIM_TIME = 0.2 # time the animation will reach it's peak
export(float) var DECAY_ANIM_TIME = 1 # time the animation will stay at it's peak
export(float) var RELEASE_ANIM_TIME = 1.5 # time the animation will fade out

func _ready():
	$Particles.emitting = false
	$DecayTimer.set_wait_time(DECAY_ANIM_TIME)
	hide()

#func _process(_delta): # debug
#	if(Input.is_action_just_pressed("jump")):
#		startAnim()

# starts the lazer beam animation
func startAnim():
	show()
	$Particles.emitting = true
	$AttackTween.interpolate_property(self,"width",0,20,ATTACK_ANIM_TIME)
	$AttackTween.start()
	$DecayTimer.start()

# starts the release of animation
func _on_DecayTimer_timeout():
	$AttackTween.stop_all()
	$ReleaseTween.interpolate_property(self,"width",20,0,RELEASE_ANIM_TIME)
	$ReleaseTween.start()

# ends the animation
func _on_ReleaseTween_tween_all_completed():
	$ReleaseTween.stop_all()
	$Particles.emitting = false
	hide()
