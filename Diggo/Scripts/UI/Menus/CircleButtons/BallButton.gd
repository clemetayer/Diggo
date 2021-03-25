extends TextureButton

func _on_BallButton_pressed():
	SignalManager.emit_catch_ball()
