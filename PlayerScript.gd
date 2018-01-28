extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var TimeWait = 0;
var spawned = false;
const dist = 16;
const animTime = .4;
var travelled = 0;
var move = Vector2(0.0, 0.0);
var kinebody;
var controller;
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	controller = get_parent();
	kinebody = get_node("PlayerBody")
	set_process(true)
	pass

func _process(delta):
	#print (move)
	if (travelled < dist):
		var moveamount = min(move.length() * delta / animTime, dist - travelled)
		travelled += moveamount
		set_pos(get_pos() + move.clamped(1) * moveamount)
		#kinebody.move(0.0, 0.0);
		kinebody.move_to(get_global_pos())
	else:
		set_pos(get_pos().snapped(Vector2(4,4)))

func InitialCheck(movement):
	kinebody.move(movement)
	move = movement;
	if kinebody.is_colliding():
		if kinebody.get_collider().onInitialCollide(movement):
			return true
		else:
			move = Vector2(0.0,0.0);
			kinebody.set_pos(Vector2(0.0, 0.0))
			return false
	else:
		return true;
	

func PreCheck():
	#kinebody.move(movement)
	#move = movement
	var moveOk = true;
	
	if kinebody.is_colliding():
		moveOk = kinebody.get_collider().onPreCollide(0, move)
	if not moveOk:
		move = Vector2(0.0, 0.0)

func TimeSpawn():
	if (TimeWait > 0):
		TimeWait -= 1;
	elif (TimeWait == 0):
		spawned = true;
		travelled = 0
	kinebody.set_pos(Vector2(0.0,0.0))

func PostCheck():
	#print("me-sprite: ", kinebody.get_parent().get_global_pos());
	#print("me-kinebody: ", kinebody.get_global_pos());
	#print("me-collider: ", kinebody.get_node("CollisionPolygon2D").get_global_pos());
	#print("me-size: ", kinebody.get_node("CollisionPolygon2D").get_scale());
	if (kinebody.is_colliding()):
		var othernode = kinebody.get_collider().get_parent()
		controller.Explode(get_node("."), othernode);
		#othernode.onPostCollide(0, get_node("."))