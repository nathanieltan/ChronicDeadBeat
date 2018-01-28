extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var id = 1;
var parent;
var movevar = Vector2(0.0, 0.0)
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
		set_pos(Vector2(0.0, 0.0));
		return false;
	
func onPreCollide(id, movement):
	if (id == 0): #player
		if not is_colliding():
			movevar = movement;
			parent.travelled = 0;
			return true
		else:
			print("wowow2")
			movevar = Vector2(0.0, 0.0)
			return false;
	elif (id == 1):
		return false

func onPostCollide(id, node):
	pass
