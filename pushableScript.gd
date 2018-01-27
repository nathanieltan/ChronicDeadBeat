extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var id = 1;
var parent;
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	parent = get_parent()
	pass
	
func onCollide(movement):
	move(movement);
	if not is_colliding():
		parent.set_pos(parent.get_pos() + movement)
	else:
		return false
	set_pos(Vector2(0.0, 0.0))
	return true
