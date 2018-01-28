extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var kinebody
var TimeWait = 0;
var spawned = false;
const dist = 16;
const animTime = .4;
var travelled = 16;
var dir = Vector2(0.0, 0.0);
var controller;
var targ = get_pos();

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	kinebody = get_node("PushableBody")
	controller = get_parent()
	set_process(true)
	
func _process(delta):
	controller.DepthChanger(get_node("."))
	if (travelled < dist):
		var moveamount = min(16 * delta / animTime, dist - travelled)
		travelled += moveamount
		set_pos(get_pos() + dir.clamped(1) * moveamount)
		#kinebody.move_to(get_global_pos())
	else:
		set_pos(get_pos().snapped(Vector2(4,4)))
		#targ = get_pos()/16;
		#dir = Vector2(0.0, 0.0)
		
		#kinebody.set_pos(Vector2(0.0, 0.0))
		#kinebody.move(Vector2(0.0, 0.0))

func PreCheck():
	#dir = Vector2(0.0, 0.0);
	targ = get_pos()/16;
	controller.UpdateNode(0, get_pos()/16)
	controller.UpdateNode(get_node("."), targ + dir)

func TimeSpawn():
	print(dir)
	if (spawned):
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
		#movement = kinebody.movevar;
	#kinebody.set_pos(Vector2(0.0,0.0))

func PostCheck():
	dir = Vector2(0.0, 0.0)
	targ = get_pos()/16;
	

func onInitialCollide(direnter):
	#controller.CheckNode(get_pos()+dir)
	#dir = direnter
	targ = get_pos()/16
	var id = controller.CheckNode(targ + direnter)
	var test = false;
	if (typeof(id) == 2):
		test = true;
	if test:
		return true
	else:
		return false;
		
func onPreCollide(id, direnter):
	#controller.CheckNode(get_pos()+dir)
	if (id == 0):
		dir = direnter
		print(dir)
		targ = get_pos()/16
		var collide = controller.CheckNode(targ + dir)
		var test = false;
		if (typeof(collide) == 2):
			test = true;
		
		if test:
			targ += dir
			controller.UpdateNode(0, get_pos()/16)
			controller.UpdateNode(get_node("."), targ)
			return true
		else:
			return false
	else:
		return false;