extends Node2D

func playIdleAnimation():
	$AnimationPlayer.play("Idle")

func playSittingAnimation():
	$AnimationPlayer.play("Sitting")
