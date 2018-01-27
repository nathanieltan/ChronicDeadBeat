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
	
func onInitialCollide(movement):
	move(movement);
	if not is_colliding():
		return true;
	else:
		return false;
	
func onPreCollide(id, movement):
	if (id == 0): #player
		move(movement);
		if not is_colliding():
			parent.set_pos(parent.get_pos() + movement)
			set_pos(Vector2(0.0, 0.0))
			return true
		else:
			set_pos(Vector2(0.0, 0.0))
			return false;
	elif (id == 1):
		return false


