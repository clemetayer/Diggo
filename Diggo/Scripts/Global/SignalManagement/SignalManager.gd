extends Node

# Autoload node to send global signal easily
# TODO : fill some global signals here
# NOTE : functions are exceptionally written this way to avoid a mix between capitals and underscores

signal catch_ball()
signal give_ball()
signal diggo_anim_info(info) # sends informations on the state of diggo's animation (if an animation is done for instance)
signal diggo_owner_interact()
signal path_finding_item_chosen()
signal screen_shake(duration,frequency,amplitude,priority)
signal fade_in_done()
signal fade_out_done()

func emit_catch_ball():
	emit_signal("catch_ball")

func emit_diggo_owner_interact():
	emit_signal("diggo_owner_interact")

func emit_give_ball():
	emit_signal("give_ball")

func emit_path_finding_item_chosen():
	emit_signal("path_finding_item_chosen")

func emit_screen_shake(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	emit_signal("screen_shake",duration,frequency,amplitude,priority)

func emit_set_diggo_animation(animationName):
	emit_signal("set_diggo_animation",animationName)

func emit_diggo_anim_info(info):
	emit_signal("diggo_anim_info",info)

func emit_fade_in_done():
	emit_signal("fade_in_done")

func emit_fade_out_done():
	emit_signal("fade_out_done")
