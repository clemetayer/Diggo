extends Area2D

export var MIN_SIZE = 8

var temp = 0
var Size = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	createShape()

func createShape():
	var collision = get_node("CollisionShape2D")
	var newCol = RectangleShape2D.new()
	newCol.set_extents(Vector2(Size,Size))
	collision.set_shape(newCol)
	collision.position = Vector2(Size,Size)

func _on_BlockArea_body_entered(body):
	var newPos = position
	if(Size > MIN_SIZE):
		for row in range(2):
			for col in range(2):
				get_parent().createNewBlock(Size/2, newPos)
				newPos.x += Size
			newPos.x = position.x
			newPos.y += Size
	queue_free()
