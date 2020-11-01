extends Node2D

export var TILE_SIZE_POW = 6
export var MIN_SIZE_POW = 2
export var MIN_FPS = 15
export var GOAL_FPS = 30

export(Texture) var SPRITE
export(String) var BLOCK_PATH = "res://Scenes/Utils/Blocks/BlockArea.tscn"

var stepFPS = (GOAL_FPS - MIN_FPS)/3
var blockArea = load(BLOCK_PATH)
var bitmap = BitMap
var minSize = pow(2,MIN_SIZE_POW)


# Called when the node enters the scene tree for the first time.
func _ready():
	bitmap = BitMap.new()
	bitmap.create_from_image_alpha(SPRITE.get_data())
	subdivideOriginalSprite()

func _process(delta):
		var avgFps = Performance.get_monitor(Performance.TIME_FPS)
		if(avgFps > GOAL_FPS):
			minSize = 4
		elif((avgFps < GOAL_FPS) and (avgFps >= MIN_FPS + 2*stepFPS)):
			minSize = 8
		elif((avgFps < MIN_FPS + 2*stepFPS) and (avgFps >= MIN_FPS + stepFPS)):
			minSize = 16
		elif((avgFps < MIN_FPS + stepFPS) and (avgFps >= MIN_FPS)):
			minSize = 32
		else:
			minSize = 64

# Returns an array : ret[0] => is empty; ret[1] => is full
func isTransparentOrFull(size, position):
	var retArray = [true,true]
	for row in range(size):
		for col in range(size):
			if(bitmap.get_bit((position + Vector2(row,col)))):
				retArray[0] = false
			else:
				retArray[1] = false
	return retArray

func subdivideBlock(Size, position):
	var newPos = position
	if(Size > minSize):
		for row in range(2):
			for col in range(2):
				var isTransparentFullArray = isTransparentOrFull(Size/2, newPos)
				if(not isTransparentFullArray[0]): # is not entirely transparent
					if(not isTransparentFullArray[1]): # is not entirely full
						subdivideBlock(Size/2, newPos)
					else: # is entirely full
						createNewBlock(Size/2, newPos)
				newPos.x += Size/2
			newPos.x = position.x
			newPos.y += Size/2

func subdivideOriginalSprite():
	var spriteSize = SPRITE.get_size()
	var xPos = 0
	var yPos = 0
	var xPosTexture = 0
	var yPosTexture = 0
	for row in range(spriteSize.y/pow(2,TILE_SIZE_POW)):
		for col in range(spriteSize.x/pow(2,TILE_SIZE_POW)):
			var area = blockArea.instance()
			area.spriteTexture = SPRITE
			area.position = Vector2(xPos,yPos)
			var isTransparentFullArray = isTransparentOrFull(pow(2,TILE_SIZE_POW), Vector2(xPos,yPos))
			if(not isTransparentFullArray[0]): # is not entirely transparent
				if(not isTransparentFullArray[1]): # is not entirely full
					subdivideBlock(pow(2,TILE_SIZE_POW), Vector2(xPos,yPos))
				else: # is entirely full
					area.setRegionTexture(Vector2(xPosTexture,yPosTexture))
					self.call_deferred("add_child",area)
			xPos += pow(2,TILE_SIZE_POW)
			xPosTexture += pow(2,TILE_SIZE_POW)
		xPos = 0
		xPosTexture = 0
		yPos += pow(2,TILE_SIZE_POW)
		yPosTexture += pow(2,TILE_SIZE_POW)

func createNewBlock(Size, newPos):
	var area = blockArea.instance()
	area.position = newPos
	area.Size = Size
	area.spriteTexture = SPRITE
	area.setRegionTexture(newPos)
	self.call_deferred("add_child",area)
