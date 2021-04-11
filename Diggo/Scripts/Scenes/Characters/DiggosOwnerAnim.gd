extends Node2D

signal throwDone(position)

#func _ready(): # debug
#	playMegaThrowAnimation()

func playIdleAnimation():
	$AnimationPlayer.play("Idle")

func playSittingAnimation():
	$AnimationPlayer.play("Sitting")

func playThrowBallAnimation():
	$AnimationPlayer.play("ThrowBall")

func playMegaThrowAnimation():
	$AnimationPlayer.play("MegaThrow")
	$ParticleAndEffects/DuplicateSprite.startEffect()
	$ParticleAndEffects/LazerBeamThrow/StartLazer.start()

func _on_AnimationPlayer_animation_changed(old_name, _new_name):
	match(old_name):
		"ThrowBall":
			emit_signal("throwDone",$ViewportContainer/Viewport/Polygons/BallOfDestiny.position)
		"MegaThrow":
			$ParticleAndEffects/DuplicateSprite/FadeOutDelay.start()

func _on_FadeOutDelay_timeout():
	$ParticleAndEffects/DuplicateSprite.endEffect()

func _on_StartLazer_timeout():
	SignalManager.emit_screen_shake(3)
	$ParticleAndEffects/LazerBeamThrow.startAnim()
