extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dir = Vector2(0.0, 0.0)
var actionTaken = false;
var size;
func _process(delta):
	var kinebody = get_node("Player/KinematicBody2D")
	dir = Vector2(0.0, 0.0)
	if not actionTaken:
		if (Input.is_action_pressed("move_down")):
			dir.y = 1;
			actionTaken = true;
		elif (Input.is_action_pressed("move_up")):
			dir.y = -1;
			actionTaken = true;
		elif (Input.is_action_pressed("move_right")):
			dir.x = 1;
			actionTaken = true;
		elif (Input.is_action_pressed("move_left")):
			dir.x = -1;
			actionTaken = true;
	else:
		if not (Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
			actionTaken = false;
	
	if not kinebody.test_move(dir*size):
		get_node("Player").move(dir*size)

	#get_node("Player").set_pos(block_pos)
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	size = get_node("TileMap").get_cell_size()
	set_process(true)
