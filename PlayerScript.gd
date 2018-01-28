extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var TimeWait = 0;
var spawned = true;
const dist = 16;
const animTime = .4;
var travelled = 16;
#var move = Vector2(0.0, 0.0);
var kinebody;
var controller;
var targ;
var dir = Vector2(0.0,0.0);
var shootdir = Vector2(0.0, 0.0);
var shot = true;
var laserPiece = preload("res://laserHead.tscn")
var playerFacing = "right";

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	targ = get_global_pos()
	controller = get_parent();
	kinebody = get_node("PlayerBody")
	set_process(true)

	var animationPlayer = get_node("AnimationPlayer")
	animationPlayer.play("teleportIn")

func _process(delta):
	print(get_global_pos())
	# Checks if the idle animation should play
	if (spawned):
		if travelled >= dist:
			var animationPlayer = get_node("AnimationPlayer")
			if not animationPlayer.is_playing():
				if playerFacing == "right":
					animationPlayer.play("idleRight")
				else:
					animationPlayer.play("idleLeft")
		controller.DepthChanger(get_node("."))
		if (travelled < dist):
			#print(travelled)
			var moveamount = min(16 * delta / animTime, dist - travelled)
			travelled += moveamount
			set_pos(get_pos() + dir.clamped(1) * moveamount)
		
			#kinebody.move(0.0, 0.0);
			#kinebody.move_to(get_global_pos())
		else:
			set_pos(get_pos().snapped(Vector2(4,4)))
			shot = false

func InitialCheck(movement, shootingdirection):
	if (not spawned):
		return true
	#kinebody.move(movement)
	shootdir = shootingdirection;
	targ = get_pos()/16
	dir = movement;
	var id = controller.CheckNode(targ + dir)
	var test = false;
	if (typeof(id) == 2):
		test = true;
	else:
		test = id.onInitialCollide(dir);

	if test:
		targ += dir
		return true
	else:
		return false;


func PreCheck():
	if not spawned:
		return
	#kinebody.set_pos(Vector2(0.0,0.0))
	#kinebody.move(move)
	#move = movement
	#var moveOk = true;


	#	moveOk = kinebody.get_collider().onPreCollide(0, move)
	#if not moveOk:
	#	move = Vector2(0.0, 0.0)

	var id = controller.CheckNode(targ)
	var test = false;
	if (typeof(id) == 2):
		test = true;
	else:
		test = id.onPreCollide(0, dir)
		pass
	controller.UpdateNode(0, get_pos()/16)
	controller.UpdateNode(get_node("."), targ)
	if test:
		var animationPlayer = get_node("AnimationPlayer")
		if dir.x < 0:
			animationPlayer.play("walkLeft")
			playerFacing = "left"
		elif dir.x > 0:
			animationPlayer.play("walkRight")
			playerFacing = "right"
		elif dir.y != 0:
			if playerFacing == "right":
				animationPlayer.play("walkRight")
			else:
				animationPlayer.play("walkLeft")
	pass


		# Controls Animations if Player Moves successfully


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

	#kinebody.set_pos(Vector2(0.0,0.0))

func onInitialCollide(id):
		#print("stayed in place")
		return true

func onPreCollide(id, dir):
	if (id == 0):
		#print("stayed in place")
		return true
	elif(id == 1):
		controller.Explode(get_node("."), dir)
		return true

func PostCheck():
	dir = Vector2(0.0, 0.0);
	targ = get_pos()/16

func CheckShoot(shootdir):
	var anim = get_node("AnimationPlayer")
	if shootdir == Vector2(1, 0):
		anim.play("shootRight")
		playerFacing = "right"
		
	elif shootdir == Vector2(-1, 0):
		anim.play("shootLeft")		
		playerFacing = "left"
		
	if shootdir == Vector2(0, -1) and playerFacing == "right":
		anim.play("shootUpRight")
	
	elif shootdir == Vector2(0, -1) and playerFacing == "left":
		anim.play("shootUpLeft")
		
	elif shootdir == Vector2(0, 1) and playerFacing == "right":
		anim.play("shootDown")
		
	elif shootdir == Vector2(0, 1) and playerFacing == "left":
		anim.play("shootDownLeft")
	
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
			print("wowee")
			print(id)
			if (id.is_in_group("Terrain") || id.is_in_group("Enemies") || id == get_node(".")):
				print("wowoiwoiw")
				id.TimeWait = controller.gunPower;
				controller.UpdateNode(0, id.get_pos()/16);
				id.spawned = false;
			break;

	for ind in range(laserspots.size()):
		var laser = laserPiece.instance();
		var dir = orientation[ind]
		var dir_dic = {Vector2(0, 1): "Vertical", 
			Vector2(1, 0): "Horizontal", 
			Vector2(0, -1): "Vertical", 
			Vector2(-1, 0): "Horizontal"}
		laser.d_mode(dir_dic[dir])
		get_parent().add_child(laser)
		laser.set_global_pos(laserspots[ind])
		#print(laserspots[ind])

func Vector2Dir(vec):
	var tmp = vec.normalized()
	if tmp.y < -.1:
		return 3
	if tmp.x > .1:
		return 4
	if tmp.y >= .1:
		return 1
	if tmp.x <= -.1:
		return 2
	else:
		return 0;
		
	
func Dir2Vector(dir):
	if dir == 1:
		return Vector2(0.0, -1.0)
	if dir == 2:
		return Vector2(1.0, 0.0)
	if dir == 3:
		return Vector2(0.0, 1.0)
	if dir == 4:
		return Vector2(-1.0, 0.0)
	else:
		return 0;