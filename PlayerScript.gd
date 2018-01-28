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
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	kinebody = get_node("PlayerBody")
	set_process(true)
	pass

func _process(delta):
	if (travelled < dist):
		var moveamount = min(move.length() * delta / animTime, dist - travelled)
		travelled += moveamount
		set_pos(get_pos() + move.normalized() * moveamount)

func InitialCheck(movement):
	kinebody.move(movement)
	if kinebody.is_colliding():
		print("Colliding")
		return kinebody.get_collider().onInitialCollide(movement)
	else:
		return true;

func PreCheck(movement):
	if kinebody.is_colliding():
		return kinebody.get_collider().onPreCollide(0, movement)
	else:
		return true;

func TimeSpawn():
	if (TimeWait > 0):
		TimeWait -= 1;
	elif (TimeWait == 0):
		spawned = true;

func PostCheck(movement):
	move = movement
	travelled = 0
	kinebody.set_pos(Vector2(0.0,0.0))