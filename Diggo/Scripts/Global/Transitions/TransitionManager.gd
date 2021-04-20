extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeLayer/StandardFadeRect.hide()

# fades from transparent to black
func standardFadeIn(time=1): 
	$Tweens/StandardFadeTween.interpolate_property(
		$FadeLayer/StandardFadeRect,
		"color:a",
		0,
		1,
		time
	)
	$Tweens/StandardFadeTween.start()
	$FadeLayer/StandardFadeRect.show()

# fades from black to transparent
func standardFadeOut(time=1):
	$Tweens/StandardFadeTween.interpolate_property(
		$FadeLayer/StandardFadeRect,
		"color:a",
		1,
		0,
		time
	)
	$Tweens/StandardFadeTween.start()

func _on_StandardFadeTween_tween_completed(object, _key):
	if(object.color.a == 0): # it was a fade out
		SignalManager.emit_fade_out_done()
		$FadeLayer/StandardFadeRect.hide()
	elif(object.color.a == 1): # it was a fade in
		SignalManager.emit_fade_in_done()
