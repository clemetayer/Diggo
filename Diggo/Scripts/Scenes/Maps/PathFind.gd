extends Node2D

# Attempt at pathfinding using AStar
# entire scene UNUSED?

export var POINTS_DISTANCE = 64
export var SCENE_SIZE = 4096

var astar = AStar2D.new()
#var points = []
#var lines = []

# Called when the node enters the scene tree for the first time.
func _ready():
	createAstarPoints()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("find_path")):
		var path = astar.get_point_path(astar.get_closest_point(get_global_mouse_position()), astar.get_closest_point(get_node("TargetObject").position))
		get_node("Line2D").points = path
#		print(path)

#func _draw():
#	for point in points:
#		draw_circle(point,10,Color(255,0,0))
#	for line in lines:
#		draw_line(line[0],line[1],Color(0,255,0))

func registerPoints(row, col, index):
	astar.add_point(index, Vector2(row,col))
#	points.append(Vector2(col,row))
	connectGridPoint(row, col, index)

func createAstarPoints():
	var index = 3
	for row in range(-SCENE_SIZE/2,SCENE_SIZE/2,POINTS_DISTANCE):
		for col in range(-SCENE_SIZE/2,SCENE_SIZE/2,POINTS_DISTANCE):
			call_deferred("registerPoints",row,col,index)
			index += 1

func connectGridPoint(row, col, index):
	if(row == -SCENE_SIZE/2): # if on first row
		if(col == -SCENE_SIZE/2): # and forst column
			return
		else: # other columns in first row
			astar.connect_points(index,index-1,true) # Connect to left bidirectionnal
#			lines.append([Vector2(col,row),astar.get_point_position(index-1)])
	elif(col == -SCENE_SIZE/2 ): # if first column
		astar.connect_points(index,index-(SCENE_SIZE/POINTS_DISTANCE)) # Connect to up bidirectionnal
#		lines.append([Vector2(col,row),astar.get_point_position(index-(SCENE_SIZE/POINTS_DISTANCE))])
	else: #other cases
		astar.connect_points(index,index-1,true) # Connect to left bidirectionnal
#		lines.append([Vector2(col,row),astar.get_point_position(index-1)])
		astar.connect_points(index,index-(SCENE_SIZE/POINTS_DISTANCE)) # Connect to up bidirectionnal
#		lines.append([Vector2(col,row),astar.get_point_position(index-(SCENE_SIZE/POINTS_DISTANCE))])
