extends Node2D

signal throwDone(position)

func playIdleAnimation():
	$AnimationPlayer.play("Idle")
	showBook(false)
	showBall(false)

func playSittingAnimation():
	$AnimationPlayer.play("Sitting")
	showBook(true)
	showBall(false)

func playThrowBallAnimation():
	$AnimationPlayer.play("ThrowBall")
	showBook(false)
	showBall(true)

func showBook(value):
	if(value):
		$Polygons/Book.show()
	else:
		$Polygons/Book.hide()

func showBall(value):
	if(value):
		$Polygons/BallOfDestiny.show()
	else:
		$Polygons/BallOfDestiny.hide()

func _on_AnimationPlayer_animation_finished(anim_name):
	match(anim_name):
		"ThrowBall":
			emit_signal("throwDone",$Polygons/BallOfDestiny.position)
