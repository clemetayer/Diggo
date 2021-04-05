extends Node

# Autoload node to send global signal easily
# TODO : fill some global signals here
# NOTE : functions are exceptionally written this way to avoid a mix between capitals and underscores

signal catch_ball()
signal give_ball()
signal diggo_owner_interact()
signal path_finding_item_chosen()

func emit_catch_ball():
	emit_signal("catch_ball")

func emit_diggo_owner_interact():
	emit_signal("diggo_owner_interact")

func emit_give_ball():
	emit_signal("give_ball")

func emit_path_finding_item_chosen():
	emit_signal("path_finding_item_chosen")
