extends Node2D

export(NodePath) var VIEWPORT_PATH # path to the viewport to get the sprite
export(Array,Color) var COLORS # colors to use in the sprite
export(float) var CLONE_TIME = 0.5 # time to create another sprite instance
export(float) var DECAY_TIME = 2 # time a sprite instance stays in the scene

var customSprite # custom sprite instance with a specific color shader material
var spriteArray = [] # array of sprite instances
var decayDone = false # true if the first decay is done 
var stopEffect = false # true if the effect should (at least) start to stop (haha)

# Called when the node enters the scene tree for the first time.
func _ready():
	customSprite = load("res://Other/VariousEffects/DuplicateSprite/ShaderSprite.tscn")
	$CloneTimer.set_wait_time(CLONE_TIME)
	$DecayTimer.set_wait_time(DECAY_TIME)

# starts the effect
func startEffect():
	$CloneTimer.start()
	$DecayTimer.start()

# ends the effect
func endEffect():
	$DecayTimer.start()
	stopEffect = true

# duplicates the sprite
func addSprite():
	var sprite = customSprite.instance()
	sprite.COLORS = COLORS
	var img = get_node(VIEWPORT_PATH).get_texture().get_data()
	img.flip_y()
	var itex = ImageTexture.new()
	itex.create_from_image(img)
	sprite.texture = itex
	add_child(sprite)
	return sprite

func _on_CloneTimer_timeout():
	if(not stopEffect):
		var sprite = addSprite()
		spriteArray.push_front(sprite)
	if(decayDone):
		spriteArray.pop_back().queue_free()

func _on_DecayTimer_timeout():
	if(not stopEffect):
		decayDone = true
		$DecayTimer.stop()
	else:
		$CloneTimer.stop()
		$DecayTimer.stop()
		decayDone = false
		stopEffect = false
