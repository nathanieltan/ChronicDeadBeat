extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var TimeWait = 0;
var spawned = false;
const dist = 16;
const animTime = .4;
var travelled = 16;
#var move = Vector2(0.0, 0.0);
var kinebody;
var controller;
var targ;
var dir = Vector2(0.0,0.0);
var shootdir = Vector2(0.0, 0.0);
var shot = false;
var laserPiece = preload("res://laserHead.tscn")
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	controller = get_parent();
	kinebody = get_node("PlayerBody")
	set_process(true)
	pass

func _process(delta):
	#print (move)
	controller.DepthChanger(get_node("."))
	if (travelled < dist):
		#print(travelled)
		var moveamount = min(16 * delta / animTime, dist - travelled)
		travelled += moveamount
		set_pos(get_pos() + dir.clamped(1) * moveamount)
		if (controller.timer > animTime / 2 and not shot):
			shot = true
			#shoot gun
			print (shot)
		#kinebody.move(0.0, 0.0);
		#kinebody.move_to(get_global_pos())
	else:
		set_pos(get_pos().snapped(Vector2(4,4)))
		shot = false

func InitialCheck(movement, shootingdirection):
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
		print(dir)
		test = id.onPreCollide(0, dir);
	controller.UpdateNode(0, get_pos()/16)
	controller.UpdateNode(get_node("."), targ)
	pass
	

func TimeSpawn():
	if (spawned):
		if (shootdir != Vector2(0.0, 0.0)):
			CheckShoot(shootdir)
		else:
			travelled = 0
		
	if (TimeWait > 0):
		TimeWait -= 1;
		targ = get_pos()/16;
	elif (not spawned and TimeWait == 0):
		var underitem = controller.CheckNode(targ/16)
		if (typeof(underitem) == 2):
			pass
		elif (not underitem.is_in_group("Button")):
			controller.Explode(get_node("."), underitem)
		spawned = true;
		travelled = 0;
	
	#kinebody.set_pos(Vector2(0.0,0.0))

func onInitialCollide(id):
		print("stayed in place")
		return true

func onPreCollide(id, dir):
	if (id == 0):
		print("stayed in place")
		return true
	elif(id == 1):
		controller.Explode(get_node("."), dir)
		return true

func PostCheck():
	dir = Vector2(0.0, 0.0);
	targ = get_pos()/16
	
func CheckShoot(shootdir):
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
		
		
		if test:
			laserspots.append(checkhead)
			orientation.append(1)
			continue
		else:
			print(id)
			break;
			
	for ind in range(laserspots.size()):
		var laser = laserPiece.instance();
		get_parent().add_child(laser)
		laser.set_global_pos(laserspots[ind])
		print(laserspots[ind])
		
		
	
	
	#print("me-sprite: ", kinebody.get_parent().get_global_pos());
	#print("me-kinebody: ", kinebody.get_global_pos());
	#print("me-collider: ", kinebody.get_node("CollisionPolygon2D").get_global_pos());
	#print("me-size: ", kinebody.get_node("CollisionPolygon2D").get_scale());
	#if (kinebody.is_colliding()):
	#	var othernode = kinebody.get_collider().get_parent()
	#	controller.Explode(get_node("."), othernode);
	#	#othernode.onPostCollide(0, get_node("."))