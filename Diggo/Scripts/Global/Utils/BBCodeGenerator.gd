extends Node
# every functions to create some specific BBCode effects

# changes the color of the string
func BBCodeColor(string, color):
	return("[color=" + color + "]" + string + "[/color]")

# centers the string
func BBCodeCenter(string):
	return("[center]" + string + "[/center]")

# makes the text as a wave
func BBCodeWave(string,amp=50,freq=2):
	return("[wave amp=" + str(amp) + " freq=" + str(freq) + "]" + string + "[/wave]")
