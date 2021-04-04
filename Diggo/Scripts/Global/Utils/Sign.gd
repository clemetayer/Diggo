extends Area2D

export(String) var TEXT = ""

func _ready():
	$SignText.set_bbcode(TEXT)
	$SignText.hide()

func _on_Sign_body_entered(body):
	print("here" + get_name())
	if(body.is_in_group("Player")):
		$SignText.show()

func _on_Sign_body_exited(body):
	if(body.is_in_group("Player")):
		$SignText.hide()
