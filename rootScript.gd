extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dir = Vector2(0.0, 0.0)
var actionTaken = false;
var actionprev = false;
var actionSignal = false;
var size;
var player;
var actionvalid;
var scenetree;
var kinebody

func _process(delta):
	dir = Vector2(0.0, 0.0)
	actionprev = actionTaken
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
			get_node("laserHead").shoot("up")
			actionTaken = true;
	else:
		if not (Input.is_action_pressed("move_down") or Input.is_action_pressed("shoot") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
			actionTaken = false;
	
	# DO PRE COLLISION CHECKING PROCEDURE FOR WHETHER TURN SHOULD BE TAKEN
	var movement = dir*size
	
	if actionTaken and not actionprev:
		actionSignal = true;
	else:
		actionSignal = false;
	
	if actionSignal:
		actionvalid = player.InitialCheck(movement)
	
	if (actionvalid):
		# DO PRECHECKING PROCEDURE FOR ALL MOVING OBJECT
		scenetree.call_group(0, "Enemies", "PreCheck", kinebody.get_global_pos())
		player.PreCheck(movement);
		
		# DO SPAWNING PROCEDURE
		scenetree.call_group(0, "Enemies", "TimeSpawn")
		player.TimeSpawn()
		
		#scenetree.call_group(0, "Enemies", "Move", kinebody.get_global_pos())
		#player.Move()
		
		# DO CHECKING PROCEDURE (Check for animation, movement, and gamestates)
		scenetree.call_group(0, "Enemies", "PostCheck");
		player.PostCheck(movement)
	
	actionvalid = false;
		
		
	#kinebody.set_pos(Vector2(0.0, 0.0))

#func CollisionControl(collisionNode, movement):
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("Player");
	kinebody = get_node("Player/PlayerBody")
	size = get_node("UncollidingTileMap").get_cell_size()
	scenetree = get_tree()
	set_process(true)
