extends Node2D

export var TILE_SIZE = 64
export var MIN_SIZE = 8

var blockArea = preload("res://Scenes/Utils/Blocks/BlockArea.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	subdivideOriginalSprite()

func subdivideOriginalSprite():
	var spriteRect = get_node("Sprite").get_rect()
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(get_node("Sprite").texture.get_data())
	get_node("Sprite").get_texture().get_data().save_png("res://screenshots/debug" + get_parent().name + ".png")
	var spriteStart =  spriteRect.position
	var spriteSize = spriteRect.size
	var xPos = spriteStart.x
	var yPos = spriteStart.y
	for row in range(spriteSize.y/TILE_SIZE):
		for col in range(spriteSize.x/TILE_SIZE):
			var area = blockArea.instance()
			area.position = Vector2(xPos,yPos)
			self.add_child(area)
			xPos += TILE_SIZE
		xPos = spriteStart.x
		yPos += TILE_SIZE

func createNewBlock(Size, newPos):
	var area = blockArea.instance()
	area.position = newPos
	area.Size = Size
	self.add_child(area)
