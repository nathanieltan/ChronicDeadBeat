extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var moveArray = [0,1,2,3]
var ind = 0;
var kinebody
var TimeWait = 0;
var spawned = false;
const dist = 16;
const animTime = .4;
var travelled = 0;
var movement = Vector2(0.0, 0.0);

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	kinebody = get_node("BasicEnemyBody")
	set_process(true)
	
func _process(delta):
	if (travelled < dist):
		var moveamount = min(movement.length() * delta / animTime, dist - travelled)
		travelled += moveamount
		set_pos(get_pos() + movement.normalized() * moveamount)

func PreCheck(playerPos): #playerPos is the future position of the player
	
	#kinebody.
	
	movement = IntToMove(moveArray[ind])
	var moveOk = true;
	kinebody.move(movement)
	if (kinebody.is_colliding()):
		moveOk = kinebody.get_collider().onPreCollide(1, movement);
	
	if not moveOk:
		kinebody.set_pos(Vector2(0.0, 0.0))
		movement = Vector2(0.0, 0.0)
	
	print(movement)
	
	ind += 1;
	if (ind >= moveArray.size()):
		ind = 0
		
func TimeSpawn():
	if TimeWait > 0:
		TimeWait -= 1;
	if TimeWait == 0:
		spawned = true;

func PostCheck():
	travelled = 0
	kinebody.set_pos(Vector2(0.0,0.0))

func IntToMove(id):
	if (id == 0):
		return Vector2(0, -16.0)
	if (id == 1):
		return Vector2(16.0, 0.0)
	if (id == 2):
		return Vector2(0, 16.0)
	if (id == 3):
		return Vector2(-16.0, 0.0)
	else:
		return Vector2(0.0, 0.0)