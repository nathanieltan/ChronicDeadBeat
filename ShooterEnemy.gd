extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var ind = 0;
var kinebody
var controller;
var TimeWait = 0;
var spawned = true;
const dist = 16;
const animTime = .4;
var travelled = 0;
var dir = Vector2(0.0, 0.0);
var shootdir = Vector2(0.0, 0.0);
var targ;
var deadlyLazer = preload("res://laserTail.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	targ = get_pos()/16;
	controller = get_parent()
	set_process(true)
	
	#animationPlayer.play("ballCharge")

func _process(delta):
	if (spawned):
		controller.DepthChanger(get_node("."))
		if (travelled < dist):
			var moveamount = min(16 * delta / animTime, dist - travelled)
			travelled += moveamount
			set_pos(get_pos() + dir.clamped(1) * moveamount)
			#kinebody.move_to(get_global_pos())
		else:
			set_pos(get_pos().snapped(Vector2(4,4)))

func PreCheck(playerPos): #playerPos is the future position of the player
	if spawned:
		targ = get_pos()/16
		var ydiff = playerPos.y - get_pos().y
		print("ydiff: ", ydiff)
		if (abs(ydiff) < 1):
			dir = Vector2(0.0, 0.0);
			var xdiff = playerPos.x - get_pos().x;
			shootdir = Vector2(sign(xdiff), 0.0);
		else:
			dir = Vector2(0.0, sign(ydiff));#IntToMove(moveArray[ind]);
			shootdir = Vector2(0.0, 0.0);
		#print ("wow: ", shootdir)
		var id = controller.CheckNode(targ + dir);
		var test = false;
		if (typeof(id) == 2):
			test = true;
		else:
			test = id.onPreCollide(1, get_node("."));
				
		if test:
			targ += dir
			controller.UpdateNode(0, get_pos()/16)
			controller.UpdateNode(get_node("."), targ)
		else:
			dir = Vector2(0.0, 0.0)
			
			#return true
	

func TimeSpawn():
	if (spawned):
		if (shootdir != Vector2(0.0, 0.0)):
			CheckShoot(shootdir)
		else:
			travelled = 0
	else:
		get_node(".").hide()

	if (TimeWait > 0):
		TimeWait -= 1;
		targ = get_pos()/16;
	elif (not spawned and TimeWait == 0):
		get_node(".").show()
		var underitem = controller.CheckNode(targ)
		var tmpbool = true;
		
		
		if (typeof(underitem) == 2):
			pass
		elif (not underitem.is_in_group("Button")):
			tmpbool = false;
		
		if tmpbool:
			controller.UpdateNode(get_node("."), targ)
		else:
			controller.Explode(get_node("."), underitem)
		spawned = true;
		travelled = 0;
	#kinebody.set_pos(Vector2(0.0, 0.0))

func PostCheck():
	dir = Vector2(0.0, 0.0);
	targ = get_pos()/16
	#kinebody.move(Vector2(0.0, 0.1))
	#set_pos(get_pos().snapped(Vector2(4,4)))
	#kinebody.set_pos(Vector2(0.0, 0.0))
	#if (kinebody.is_colliding()):
	#	var othernode = kinebody.get_collider().get_parent()
	#	controller.Explode(get_node("."), othernode);
	pass

func onInitialCollide(dir):
	return true;

func onPreCollide(id, player):
	if (id == 0):
		print ("ho dang")
		return true
	elif (id == 1):
		return false

func IntToMove(id):
	var animationPlayer = get_node("AnimationPlayer")
	if (id == 0):
		#animationPlayer.play("ballUp")
		#show_select_spikes([])
		return Vector2(0, -1)
	if (id == 1):
		#show_select_spikes([])
		#animationPlayer.play("ballRight")
		return Vector2(1, 0.0)
	if (id == 2):
		#show_select_spikes([])
		#animationPlayer.play("ballDown")
		return Vector2(0, 1)
	if (id == 3):
		#show_select_spikes([])
		#animationPlayer.play("ballLeft")
		return Vector2(-1, 0.0)
	else:
		#var up = controller.CheckNode(get_pos()/16 + Vector2(0.0, -1.0))
		#var right = controller.CheckNode(get_pos()/16 + Vector2(1.0, 0.0))
		#var down = controller.CheckNode(get_pos()/16 + Vector2(0.0, 1.0))
		#var left = controller.CheckNode(get_pos()/16 + Vector2(-1.0, 0.0))
		#var count = 1;
		#var animlist = []
		#for direction in [up, right, down, left]:
		#	var test = false
		#	if typeof(direction) == 2:
		#		test = true
		#	elif (direction.is_in_group("Button") || direction.is_in_group("Player")):
		#		test = true
		#		controller.Explode(direction, get_node("."))
		#	
		#	if test:
		#		animlist.append(count)
		#	count += 1;
		
		#show_select_spikes(animlist)
		#animationPlayer.play("SpikesUDLR")
		
		#INPUT SHOOTING ANIMATION HERE
		return Vector2(0.0, 0.0)
		
func CheckShoot(shootdir):
	#var anim = get_node("AnimationPlayer")
	if shootdir == Vector2(1, 0):
		find_node("AnimationPlayer").play("FireRight")
		#playerFacing = "right"
		pass
		
	elif shootdir == Vector2(-1, 0):
		find_node("AnimationPlayer").play("FireLeft")	
		#playerFacing = "left"
		pass
	
	var checkhead = get_pos()
	var laserspots = []
	var orientation = []
	while(true):
		checkhead += shootdir * 16
		var id = controller.CheckNode(checkhead/16);
		var test = false;
		if (typeof(id) == 2):
			test = true;
		elif (id.is_in_group("Button")):
			test = true;
		elif (id.is_in_group("Mirrors")):
			test = true;
			var tmpdir = Vector2Dir(shootdir)
			var newdir = id.determine_bounce(tmpdir)
			shootdir = Dir2Vector(newdir)
			if (typeof(shootdir) == 2 and shootdir == 0):
				test = false;
		

		if test:
			laserspots.append(checkhead)
			orientation.append(shootdir)
			continue
		else:
			print(id)
			if (id.is_in_group("Terrain") || id.is_in_group("Enemies") || id.is_in_group("Player")):
				#id.TimeWait = controller.gunPower;
				#controller.UpdateNode(0, id.get_pos()/16);
				controller.Explode(id, get_node("."));
			break;

	for ind in range(laserspots.size()):
		var laser = deadlyLazer.instance();
		var dir = orientation[ind]
		var dir_dic = {Vector2(0, 1): "Vertical", 
			Vector2(1, 0): "Horizontal", 
			Vector2(0, -1): "Vertical", 
			Vector2(-1, 0): "Horizontal"}
		laser.d_mode(dir_dic[dir])
		get_parent().add_child(laser)
		laser.set_global_pos(laserspots[ind])
		print(laserspots[ind])

func show_select_spikes(list_of_spikes):

	var up = get_node("upSpike")
	var right = get_node("rightSpike")
	var down = get_node("downSpike")
	var left = get_node("leftSpike")

	if 1 in list_of_spikes:
		up.show_spike()
	else:
		up.hide_spike()
	if 2 in list_of_spikes:
		right.show_spike()
	else:
		right.hide_spike()
	if 3 in list_of_spikes:
		down.show_spike()
	else:
		down.hide_spike()
	if 4 in list_of_spikes:
		left.show_spike()
	else:
		left.hide_spike()
