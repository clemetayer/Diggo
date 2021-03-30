extends Area2D

export(String) var TEXT = ""

func _ready():
	$SignText.set_bbcode(TEXT)
	$SignText.hide() # FIXME : not working

func _on_Sign_body_entered(body):
	$SignText.show()

func _on_Sign_body_exited(body):
	$SignText.hide()
