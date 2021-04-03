extends TileMap

export(String,FILE) var DESTRUCTIBLE_SPRITE_PATH = "res://Scenes/Maps/DestructibleSprite.tscn"
export(String,FILE) var BLOCK_PATH = "res://Scenes/Utils/Blocks/BlockArea.tscn" 
export(int) var TILE_SIZE_POW = 6 
export(int) var MIN_SIZE_POW = 2

var viewport

signal destructible_loaded()

# FIXME : Not working sometimes, i don't know why

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(VisualServer, 'frame_post_draw') # waits one frame before getting the texture, otherwise, some unexpected behaviours happens
	var TileMapRect = computeTileMapBounds()
	var TileMapPosition = position + TileMapRect.position 
	viewport = createViewport(TileMapPosition,TileMapRect.size)
	addTilemapToViewport(TileMapRect)
	# Note : TileMapRect.position is the offset from the center position to the first pixel on the top left
	createDestructibleSprite(TileMapRect.position)
	self.get_parent().get_parent().get_parent().remove_child(get_parent().get_parent())
	emit_signal("destructible_loaded")
#	get_parent().get_parent().call_deferred("queue_free") # FIXME : The texture of the viewport is linked in memory to the one in the sprite, so freeing the viewport will free the texture

# creates the destructible sprite corresponding to the viewport of the tilemap
func createDestructibleSprite(pos):
	var destructible_instance = load(DESTRUCTIBLE_SPRITE_PATH).instance()
	var img = viewport.get_texture()
	img.get_data().flip_y()
	img.get_data().save_png("res://test.png") # debug
	destructible_instance.position = pos 
	destructible_instance.SPRITE = img
	destructible_instance.BLOCK_PATH = BLOCK_PATH
	destructible_instance.TILE_SIZE_POW = TILE_SIZE_POW
	destructible_instance.MIN_SIZE_POW = MIN_SIZE_POW
	get_parent().get_parent().get_parent().add_child(destructible_instance)
#	get_parent().get_parent().get_parent().call_deferred("add_child",destructible_instance)

# adds tilemap as a child of the viewport
func addTilemapToViewport(tilemapRect):
	get_parent().remove_child(self)
	viewport.add_child(self) # FIXME : issue here is that it does the rest BEFORE adding child. Fix with a method waiting for child to be added
							 #         Oh, and some position issues also
	# offsets the tilemap position to the first pixel on the top left
	position = Vector2(0,0)

# function by CKO on godot forum : https://godotengine.org/qa/3276/tilemap-size
func computeTileMapBounds():
	var cell_bounds = get_used_rect()
	# create transform
	var cell_to_pixel = Transform2D(Vector2(cell_size.x * scale.x, 0), Vector2(0, cell_size.y * scale.y), Vector2())
	# apply transform
	return Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size)

func createViewport(position,size):
	var viewportC = ViewportContainer.new()
	viewportC.rect_size = size
	viewportC.rect_position = position - size/2
	viewport = Viewport.new()
	viewport.transparent_bg = true
	viewport.size = size
	viewport.set_usage(0)
	viewport.render_target_v_flip = true
	viewportC.add_child(viewport)
	get_parent().add_child(viewportC)
	return viewport