extends Area2D

export var MIN_SIZE = 4

var temp = 0
var Size = 32
var spriteTexture = Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	createShape()

func createShape():
	var areaCollision = get_node("AreaCollision")
	var solidCollision = get_node("BlockArea/SolidCollision")
	var newCol = RectangleShape2D.new()
	newCol.set_extents(Vector2(Size,Size))
	areaCollision.set_shape(newCol)
	areaCollision.position = Vector2(Size,Size)
	solidCollision.set_shape(newCol)
	solidCollision.position = Vector2(Size,Size)

func setRegionTexture(pos):
	var spriteArea = Rect2(pos, Vector2(Size*2,Size*2))
	get_node("Sprite").set_region(true)
	get_node("Sprite").set_texture(spriteTexture)
	get_node("Sprite").set_region_rect(spriteArea)

func isNewBlockColliding(blockPos, body):
	var bodyRadius = body.getCollisionRadius()
	var bodyMax = body.position + Vector2(bodyRadius,bodyRadius)
	var bodyMin = body.position - Vector2(bodyRadius,bodyRadius)
	if(blockPos >= bodyMin and blockPos <= bodyMax):
		return true
	elif((blockPos + Vector2(Size,Size)) >= bodyMin and (blockPos + Vector2(Size,Size)) <= bodyMax):
		return true
	elif(((blockPos.x + Size) >= bodyMin.x and (blockPos.x + Size) <= bodyMax.x) and 
		((blockPos.y) >= bodyMin.y and (blockPos.y) <= bodyMax.y)):
		return true
	elif(((blockPos.x) >= bodyMin.x and (blockPos.x) <= bodyMax.x) and 
		((blockPos.y + Size) >= bodyMin.y and (blockPos.y + Size) <= bodyMax.y)):
		return true
	else:
		return false

func createDivideBlocks(body):
	var newPos = position
	if(Size > MIN_SIZE):
		for row in range(2):
			for col in range(2):
				get_parent().createNewBlock(Size/2, newPos)
				newPos.x += Size
			newPos.x = position.x
			newPos.y += Size
	queue_free()

func _on_Area2D_area_entered(area):
	if(area.is_in_group("Terraform")):
		createDivideBlocks(area)
