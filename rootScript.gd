extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dir = Vector2(0.0, 0.0)
var actionTaken = false;
var size;
var player;
var actionvalid;
var scenetree;

func _process(delta):
	var kinebody = get_node("Player/PlayerBody")
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
		elif (Input.is_action_pressed("shoot")):
			print("test")
			get_node("laserHead").shoot("up")
			actionTaken = true;
	else:
		if not (Input.is_action_pressed("move_down") or Input.is_action_pressed("shoot") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
			actionTaken = false;
	
	var movement = dir*size
	kinebody.move(movement);

	if kinebody.is_colliding():
		actionvalid = kinebody.get_collider().onPreCollide(movement)
			#player.set_pos(player.get_pos()+movement)
	else:
		actionvalid = true;
		#player.set_pos(player.get_pos()+movement)
		
	if (actionvalid):
		SceneTree.Call
		
	kinebody.set_pos(Vector2(0.0, 0.0))

#func CollisionControl(collisionNode, movement):
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("Player");
	size = get_node("TileMap").get_cell_size()
	scenetree = get_tree().call_group(0, "Enemies", "PreCheck", kinebody.get_global_pos())
	set_process(true)
