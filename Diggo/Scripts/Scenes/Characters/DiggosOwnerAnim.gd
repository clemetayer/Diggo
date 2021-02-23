extends Node2D

func playIdleAnimation():
	$AnimationPlayer.play("Idle")
	$Polygons/Book.hide()

func playSittingAnimation():
	$AnimationPlayer.play("Sitting")
	$Polygons/Book.show()
