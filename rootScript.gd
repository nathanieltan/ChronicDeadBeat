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
var movelist = [];
var timer = 0;
var map = []
var movenum = 0;
var replay = false;
var code = 0;
var animTime;
const gunPower = 3;
var size;
var player;
var actionvalid;
var scenetree;
var kinebody
var allObjects;
var collidingTileMap;
var uncollidingTileMap;
var lastScenePath;

func _process(delta):
	
	dir = Vector2(0.0, 0.0)
	shootdir = Vector2(0.0, 0.0)
	actionprev = actionTaken
	var code = 0;
	if (replay):
		if movenum < movelist.size():
			set_Input(movelist[movenum], moving)
			#print(movelist[movenum])
		else:
			#print("out of moves")
			pass
	else:
		code = get_Input()

	if not moving:
		
		# DO PRE COLLISION CHECKING PROCEDURE FOR WHETHER TURN SHOULD BE TAKEN
		var movement = dir
		
			
		if (not moving and lastmoving):
			rerunsignal = true
		else:
			rerunsignal = false;
		if ((actionTaken and not actionprev) or  replay) and not rerunsignal:
			actionSignal = true;
		else:
			actionSignal = false;
		lastmoving = moving;

		if actionSignal or not player.spawned:
			actionvalid = player.InitialCheck(movement, shootdir)
			
		if (actionvalid):
			
			if not replay:
				movelist.append(code);
			# DO PRECHECKING PROCEDURE FOR ALL MOVING OBJECT
			scenetree.call_group(0, "Terrain", "PreCheck")
			player.PreCheck();
			scenetree.call_group(0, "Enemies", "PreCheck", CheckPosOf(player), player.get_pos())
			
			
			# DO SPAWNING PROCEDURE
			scenetree.call_group(0, "Terrain", "TimeSpawn")
			scenetree.call_group(0, "Enemies", "TimeSpawn")
			player.TimeSpawn()
			movenum += 1;
			
			#print(movelist)
			#Pause!
			moving = true;
			timer = 0;
		elif (rerunsignal):
			
			# DO CHECKING PROCEDURE (Check for animation, movement, and gamestates)
			#print("rerunsignal")
			scenetree.call_group(0, "Terrain", "PostCheck");
			scenetree.call_group(0, "Enemies", "PostCheck");
			player.PostCheck()
	else:
		lastmoving = moving
		if timer > animTime:
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
		UpdateNode(0, node1.get_pos()/16)
		node1.queue_free()
		node2.queue_free()
	elif(node1.is_in_group("Terrain") or node2.is_in_group("Terrain")):
		if (node1.is_in_group("Enemies") or node1 == player):
			if(node1 == player):
				playerDeath()
			else:
				node1.queue_free()
		elif (node2.is_in_group("Enemies") or node2 == player):
			if (node2 == player):
				playerDeath()
			else:
				node2.queue_free()
	elif(node1.is_in_group("Enemies") and node2.is_in_group("Enemies")):
		UpdateNode(0, node1.get_pos()/16)
		node1.queue_free()
		node2.queue_free()
	elif(node1.is_in_group("Enemies") or node2.is_in_group("Enemies")):
		if (node1 == player):
			playerDeath()
		elif (node2 == player):
			playerDeath()

func playerDeath():
	lastScenePath = get_tree().get_current_scene().get_filename()
	get_tree().get_root().get_child(0).set_last_scene_name(lastScenePath)
	get_tree().change_scene("res://GameOver.tscn")
	
func get_last_scene():
	return lastScenePath
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	animTime = get_tree().get_root().get_child(0).animTime;
	replay = get_tree().get_root().get_child(0).leveldonum;
	player = get_node("Player");
	kinebody = get_node("Player/PlayerBody")
	collidingTileMap = get_node("CollidingTileMap")
	uncollidingTileMap = get_node("UncollidingTileMap")
	size = uncollidingTileMap.get_cell_size()
	if (replay):
		movelist = get_tree().get_root().get_child(0).get_movelist()
	
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
	map[floor(player.get_pos().x/16)][floor(player.get_pos().y/16)] = player;
	
	for item in scenetree.get_nodes_in_group("Enemies"):
		map[floor(item.get_pos().x/16)][floor(item.get_pos().y/16)] = item;
		
	for item in scenetree.get_nodes_in_group("Terrain"):
		map[floor(item.get_pos().x/16)][floor(item.get_pos().y/16)] = item;
	
	for item in scenetree.get_nodes_in_group("Pushable"):
		map[floor(item.get_pos().x/16)][floor(item.get_pos().y/16)] = item;
		
	for item in collidingTileMap.get_used_cells():
		map[floor(item[0])][floor(item[1])] = collidingTileMap;
	
	

func CheckNode(pos):
	return map[floor(pos.x)][floor(pos.y)];

func UpdateNode(id, pos):
	map[floor(pos.x)][floor(pos.y)] = id;
	pass #node
	
func CheckPosOf(obj):
	for ind1 in range(map.size()):
		for ind2 in range(map[ind1].size()):
			var item = map[ind1][ind2]
			if (typeof(item) != 2):
				if (item == obj):
					return Vector2(ind1+.5, ind2+.5)*16 #We been doing it offset this whole time
				
	return null

func get_Input():
	var cod = 0;
	if not actionTaken:
		if (Input.is_action_pressed("move_down")):
			dir.y = 1;
			cod = 0
			actionTaken = true;
		elif (Input.is_action_pressed("move_up")):
			dir.y = -1;
			cod = 1
			actionTaken = true;
		elif (Input.is_action_pressed("move_right")):
			dir.x = 1;
			cod = 2
			actionTaken = true;
		elif (Input.is_action_pressed("move_left")):
			dir.x = -1;
			cod = 3
			actionTaken = true;
		elif (Input.is_action_pressed("shoot_down")):
			shootdir.y = 1;
			cod = 4
			actionTaken = true;
		elif (Input.is_action_pressed("shoot_up")):
			shootdir.y = -1;
			cod = 5
			actionTaken = true;
		elif (Input.is_action_pressed("shoot_left")):
			shootdir.x = -1;
			cod = 6
			actionTaken = true;
		elif (Input.is_action_pressed("shoot_right")):
			#get_tree().change_scene("res://Level2.tscn")
			shootdir.x = 1;
			cod = 7
			actionTaken = true;
		elif (Input.is_action_pressed("retry")):
			var currentScene = get_tree().get_current_scene()
			if(not (currentScene.get_filename() == "res://TitleScreen.tscn" or currentScene.get_filename() == "res://GameOver.tscn")):
				get_tree().reload_current_scene()
			elif(currentScene.get_filename() == "res://GameOver.tscn"):
				get_tree().change_scene(get_last_scene())
		return cod;
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


func set_Input(code, moving):
	if not moving:
		if (code == 0 ):
			dir.y = 1;
			actionTaken = true;
		elif (code == 1):
			dir.y = -1;
			actionTaken = true;
		elif (code == 2):
			dir.x = 1;
			actionTaken = true;
		elif (code == 3):
			dir.x = -1;
			actionTaken = true;
		elif (code == 4):
			shootdir.y = 1;
			actionTaken = true;
		elif (code == 5):
			shootdir.y = -1;
			actionTaken = true;
		elif (code == 6):
			shootdir.x = -1;
			actionTaken = true;
		elif (code == 7):
			#get_tree().change_scene("res://Level2.tscn")
			shootdir.x = 1;
			actionTaken = true;
		#elif (Input.is_action_pressed("retry")):
		#	var currentScene = get_tree().get_current_scene()
		#	if(not (currentScene.get_filename() == "res://TitleScreen.tscn" or currentScene.get_filename() == "res://GameOver.tscn")):
		#		get_tree().reload_current_scene()
		#	elif(currentScene.get_filename() == "res://GameOver.tscn"):
	else:
		actionTaken = false;
	#		get_tree().change_scene(get_last_scene()