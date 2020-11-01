extends Area2D 

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
	
func recurCreate(Size, Pos, body):
	if(isNewBlockColliding(Pos, Size, body)):
		if(Size > get_parent().minSize):
			var newPos = Pos
			for row in range(2):
				for col in range(2):
					self.call_deferred("recurCreate", Size/2, newPos, body)
					#recurCreate(Size/2, newPos, body)
					newPos.x += Size
				newPos.x = position.x
				newPos.y += Size
		else:
			return
	else:
		get_parent().createNewBlock(Size, Pos)

func isNewBlockColliding(blockPos, Size, body):
	var globalBlockPos = blockPos + get_parent().position
	var bodyRadius = body.getCollisionRadius()
	var bodyMax = body.position + Vector2(bodyRadius,bodyRadius)
	var bodyMin = body.position - Vector2(bodyRadius,bodyRadius)
	if(globalBlockPos >= bodyMin and globalBlockPos <= bodyMax):
		return true
	elif((globalBlockPos + Vector2(Size,Size)) >= bodyMin and (globalBlockPos + Vector2(Size,Size)) <= bodyMax):
		return true
	elif(((globalBlockPos.x + Size) >= bodyMin.x and (globalBlockPos.x + Size) <= bodyMax.x) and 
		((globalBlockPos.y) >= bodyMin.y and (globalBlockPos.y) <= bodyMax.y)):
		return true
	elif(((globalBlockPos.x) >= bodyMin.x and (globalBlockPos.x) <= bodyMax.x) and 
		((globalBlockPos.y + Size) >= bodyMin.y and (globalBlockPos.y + Size) <= bodyMax.y)):
		return true
	else:
		return false

func createDivideBlocks(body):
	var newPos = position
	if(Size > get_parent().minSize):
		for row in range(2):
			for col in range(2):
				if(not isNewBlockColliding(newPos, Size, body)):
					get_parent().createNewBlock(Size/2, newPos)
				else:
					recurCreate(Size/2, newPos, body)
				newPos.x += Size
			newPos.x = position.x
			newPos.y += Size
	queue_free()

func _on_Area2D_area_entered(area):
	if(area.is_in_group("Terraform")):
		createDivideBlocks(area)
