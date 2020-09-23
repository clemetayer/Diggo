extends Node2D

export var TILE_SIZE = 64
export var MIN_SIZE = 8

var blockArea = preload("res://Scenes/Utils/Blocks/BlockArea.tscn")
var texture = Texture


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = get_node("Sprite").get_texture()
	subdivideOriginalSprite()
	get_node("Sprite").hide()

# Returns an array : ret[0] => is empty; ret[1] => is full
func isTransparentOrFull(size, position):
	var retArray = [true,true]
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_data())
	var spriteStart = get_node("Sprite").get_rect().position
	for row in range(size):
		for col in range(size):
			if(bitmap.get_bit((position - spriteStart + Vector2(row,col)))):
				retArray[0] = false
			else:
				retArray[1] = false
	return retArray

func subdivideBlock(Size, position):
	var newPos = position
	if(Size > MIN_SIZE):
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
	var spriteRect = get_node("Sprite").get_rect()
	var spriteStart = spriteRect.position
	var spriteSize = spriteRect.size
	var xPos = spriteStart.x
	var yPos = spriteStart.y
	var xPosTexture = 0
	var yPosTexture = 0
	for row in range(spriteSize.y/TILE_SIZE):
		for col in range(spriteSize.x/TILE_SIZE):
			var area = blockArea.instance()
			area.spriteTexture = texture
			area.position = Vector2(xPos,yPos)
			var isTransparentFullArray = isTransparentOrFull(TILE_SIZE, Vector2(xPos,yPos))
			if(not isTransparentFullArray[0]): # is not entirely transparent
				if(not isTransparentFullArray[1]): # is not entirely full
					subdivideBlock(TILE_SIZE, Vector2(xPos,yPos))
				else: # is entirely full
					area.setRegionTexture(Vector2(xPosTexture,yPosTexture))
					self.call_deferred("add_child",area)
			xPos += TILE_SIZE
			xPosTexture += TILE_SIZE
		xPos = spriteStart.x
		xPosTexture = 0
		yPos += TILE_SIZE
		yPosTexture += TILE_SIZE

func createNewBlock(Size, newPos):
	var area = blockArea.instance()
	var spriteStart = get_node("Sprite").get_rect().position
	area.position = newPos
	area.Size = Size
	area.spriteTexture = texture
	area.setRegionTexture(newPos - spriteStart)
	self.call_deferred("add_child",area)
