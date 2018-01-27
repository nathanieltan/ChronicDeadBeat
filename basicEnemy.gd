extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var moveArray = [0,1,2,3]
var ind = 0;
var kinebody

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	kinebody = get_node("BasicEnemyBody")

func PreCheck(playerPos): #playerPos is the future position of the player
	
	#kinebody.
	
	var movement = IntToMove(moveArray[ind])
	var moveOk = true;
	kinebody.move(movement)
	if (kinebody.is_colliding()):
		moveOk = kinebody.get_collider().onPreCollide(1, movement);
	
	if not moveOk:
		kinebody.set_pos(Vector2(0.0, 0.0))
	
	print(movement)
	
	ind += 1;
	if (ind >= moveArray.size()):
		ind = 0

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