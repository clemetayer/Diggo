extends Area2D

export(NodePath) var EXPLOSION_COLLISION # collision shape of the explosion created by the throw
export(NodePath) var POSITION_TWEEN # tween to smoothly dig a trace in the snow for the ball

func _ready():
	$TerraformCollision.disabled = true
	get_node(EXPLOSION_COLLISION).disabled = true

# ARCHITECTURE : find a better way to do this ?
# necessary so that the digging mechanic can work
# returns the collision radius
func getCollisionRadius():
	return 15

# sets the throw feedback (enables the collision shapes and moves the tween to leave a trace in the snow)
func throwFeedback():
	$TerraformCollision.disabled = false
	get_node(EXPLOSION_COLLISION).disabled = false
	get_parent().sleeping = true
	get_parent().visible = true
	get_node(POSITION_TWEEN).interpolate_property(get_parent(),"position",Vector2(3940,-200),Vector2(4295,-380),3)
	get_node(POSITION_TWEEN).start()

func _on_PositionTween_tween_all_completed():
	$TerraformCollision.disabled = true
	get_node(EXPLOSION_COLLISION).disabled = true
	get_parent().sleeping = false
