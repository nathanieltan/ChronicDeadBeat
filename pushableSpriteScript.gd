extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var kinebody
var TimeWait = 0;
var spawned = false;
const dist = 16;
const animTime = .4;
var travelled = 0;
var movement = Vector2(0.0, 0.0);
var controller;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	kinebody = get_node("PushableBody")
	controller = get_parent()
	set_process(true)
	
func _process(delta):
	controller.DepthChanger(get_node("."))
	if (travelled < dist):
		var moveamount = min(movement.length() * delta / animTime, dist - travelled)
		travelled += moveamount
		set_pos(get_pos() + movement.normalized() * moveamount)
		kinebody.move_to(get_global_pos())
	else:
		set_pos(get_pos().snapped(Vector2(4,4)))
		#kinebody.set_pos(Vector2(0.0, 0.0))
		#kinebody.move(Vector2(0.0, 0.0))

func TimeSpawn():
	if TimeWait > 0:
		TimeWait -= 1;
	if TimeWait == 0:
		spawned = true;
		movement = kinebody.movevar;
	kinebody.set_pos(Vector2(0.0,0.0))

func PostCheck():
	#set_pos(get_pos().snapped(Vector2(4,4)))
	#kinebody.set_pos(Vector2(0.0,0.0))
	if (kinebody.is_colliding()):
		var othernode = kinebody.get_collider().get_parent()
		controller.Explode(get_node("."), othernode);
	pass