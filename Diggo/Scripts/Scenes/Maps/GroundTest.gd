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

func subdivideOriginalSprite():
	var spriteRect = get_node("Sprite").get_rect()
#	var bitmap := BitMap.new()
#	bitmap.create_from_image_alpha(get_node("Sprite").texture.get_data())
#	get_node("Sprite").get_texture().get_data().save_png("res://screenshots/debug" + get_parent().name + ".png")
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
