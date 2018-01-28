extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dir = Vector2(0.0, 0.0)
var shootdir = Vector2(0.0, 0.0)
var actionTaken = false;
var actionprev = false;
var actionSignal = false;
var moving = false;
var lastmoving = false;
var rerunsignal = false;
var timer = 0;
var map = []
const animtime = .4;
const gunPower = 3;
var size;
var player;
var actionvalid;
var scenetree;
var kinebody
var allObjects;
var collidingTileMap;
var uncollidingTileMap;

func _process(delta):
	dir = Vector2(0.0, 0.0)
	shootdir = Vector2(0.0, 0.0)
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
			elif (Input.is_action_pressed("shoot_down")):
				shootdir.y = 1;
				actionTaken = true;
			elif (Input.is_action_pressed("shoot_up")):
				shootdir.y = -1;
				actionTaken = true;
			elif (Input.is_action_pressed("shoot_left")):
				shootdir.x = -1;
				actionTaken = true;
			elif (Input.is_action_pressed("shoot_right")):
<<<<<<< HEAD
=======
				#get_tree().change_scene("res://Level2.tscn")
>>>>>>> a75bdf765ab3239a9508ced7e376f73f424b90b3
				shootdir.x = 1;
				actionTaken = true;
			elif (Input.is_action_pressed("retry")):
				var currentScene = get_tree().get_current_scene()
				if(not currentScene.get_filename() == "res://TitleScreen.tscn"):
					get_tree().reload_current_scene()
		else:
			if not (Input.is_action_pressed("move_down") 
			or Input.is_action_pressed("move_up")
			or Input.is_action_pressed("move_right")
			or Input.is_action_pressed("move_left")
			or Input.is_action_pressed("shoot_up")
			or Input.is_action_pressed("shoot_down")
			or Input.is_action_pressed("shoot_left")
			or Input.is_action_pressed("shoot_right")):
				actionTaken = false;
		
		# DO PRE COLLISION CHECKING PROCEDURE FOR WHETHER TURN SHOULD BE TAKEN
		var movement = dir
		
		if actionTaken and not actionprev:
			actionSignal = true;
		else:
			actionSignal = false;
		if not moving and lastmoving:
			rerunsignal = true
		else:
			rerunsignal = false;
		lastmoving = moving;
		
		if actionSignal or not player.spawned:
			actionvalid = player.InitialCheck(movement, shootdir)
			
		if (actionvalid):
			# DO PRECHECKING PROCEDURE FOR ALL MOVING OBJECT
			scenetree.call_group(0, "Terrain", "PreCheck")
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
		UpdateNode(0, node1.get_pos())
		UpdateNode(0, node2.get_pos())
		node1.queue_free()
		node2.queue_free()
	elif(node1.is_in_group("Terrain") or node2.is_in_group("Terrain")):
		if (node1.is_in_group("Enemies") or node1 == player):
			UpdateNode(0, node1.get_pos())
			node1.queue_free()
		elif (node2.is_in_group("Enemies") or node2 == player):
			UpdateNode(0, node2.get_pos())
			node2.queue_free()
	elif(node1.is_in_group("Enemies") and node2.is_in_group("Enemies")):
		UpdateNode(0, node1.get_pos())
		UpdateNode(0, node2.get_pos())
		node1.queue_free()
		node2.queue_free()
	elif(node1.is_in_group("Enemies") or node2.is_in_group("Enemies")):
		if (node1 == player):
			UpdateNode(0, node1.get_pos())
			node1.queue_free()
		elif (node2 == player):
			UpdateNode(0, node2.get_pos())
			node2.queue_free()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("Player");
	kinebody = get_node("Player/PlayerBody")
	collidingTileMap = get_node("CollidingTileMap")
	uncollidingTileMap = get_node("UncollidingTileMap")
	size = uncollidingTileMap.get_cell_size()
	
	scenetree = get_tree()
	InitNodes()
	set_process(true)

func DepthChanger(node):
	node.set_z(node.get_pos().y);
	
#==================================================================#

func InitNodes():
	
	# 0 - floor; 1 - wall; non-int - object node
	
	for x in range (125):
		map.append([])
		for y in range(125):
			map[x].append(0)
	map[player.get_pos().x/16][player.get_pos().y/16] = player;
	
	for item in scenetree.get_nodes_in_group("Enemies"):
		map[item.get_pos().x/16][item.get_pos().y/16] = item;
		
	for item in scenetree.get_nodes_in_group("Terrain"):
		map[item.get_pos().x/16][item.get_pos().y/16] = item;
	
	for item in scenetree.get_nodes_in_group("Pushable"):
		map[item.get_pos().x/16][item.get_pos().y/16] = item;
		
	for item in collidingTileMap.get_used_cells():
		map[item[0]][item[1]] = collidingTileMap;
	
	

func CheckNode(pos):
	return map[pos.x][pos.y];

func UpdateNode(id, pos):
	map[pos.x][pos.y] = id;
	pass #node
	