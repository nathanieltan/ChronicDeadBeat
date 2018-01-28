extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dir = Vector2(0.0, 0.0)
var actionTaken = false;
var actionprev = false;
var actionSignal = false;
var moving = false;
var lastmoving = false;
var rerunsignal = false;
var timer = 0;
const animtime = .6;
var size;
var player;
var actionvalid;
var scenetree;
var kinebody

func _process(delta):
	dir = Vector2(0.0, 0.0)
	actionprev = actionTaken
	if not moving:
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
		if not moving and lastmoving:
			rerunsignal = true
		else:
			rerunsignal = false;
		lastmoving = moving;
		
		if actionSignal:
			actionvalid = player.InitialCheck(movement)
			
		if (actionvalid):
			# DO PRECHECKING PROCEDURE FOR ALL MOVING OBJECT
			player.PreCheck();
			scenetree.call_group(0, "Enemies", "PreCheck", kinebody.get_global_pos())
			
			# DO SPAWNING PROCEDURE
			scenetree.call_group(0, "Terrain", "TimeSpawn")
			scenetree.call_group(0, "Enemies", "TimeSpawn")
			player.TimeSpawn()
			
			#Pause!
			moving = true;
			timer = 0;
		elif (rerunsignal):
			print("rerun_Signal")
			
			# DO CHECKING PROCEDURE (Check for animation, movement, and gamestates)
			scenetree.call_group(0, "Terrain", "PostCheck");
			scenetree.call_group(0, "Enemies", "PostCheck");
			player.PostCheck()
	else:
		lastmoving = moving
		if timer > animtime:
			print("move_done")
			moving = false;
		else:
			timer += delta
	actionvalid = false;
		
		
	#kinebody.set_pos(Vector2(0.0, 0.0))

#func CollisionControl(collisionNode, movement):
	
func Explode(node1, node2):
	print(node1.get_name())
	print(node2.get_name())
	if (node1.is_in_group("Terrain") and node2.is_in_group("Terrain")):
		node1.queue_free()
		node2.queue_free()
	else:
		if (node1.is_in_group("Enemies") or node1 == player):
			node1.queue_free()
		elif (node2.is_in_group("Enemies") or node2 == player):
			node2.queue_free()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("Player");
	kinebody = get_node("Player/PlayerBody")
	size = get_node("TileMap").get_cell_size()
	scenetree = get_tree()
	set_process(true)

func DepthChanger(node):
	node.set_z(node.get_pos().y);