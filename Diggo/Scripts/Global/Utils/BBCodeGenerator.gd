extends Node

func BBCodeColor(string, color):
	return("[color=" + color + "]" + string + "[/color]")

func BBCodeCenter(string):
	return("[center]" + string + "[/center]")

func BBCodeWave(string,amp=50,freq=2):
	return("[wave amp=" + str(amp) + " freq=" + str(freq) + "]" + string + "[/wave]")
