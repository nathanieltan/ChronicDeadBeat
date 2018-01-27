extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var kinebody;
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	kinebody = get_node("PlayerBody")
	pass

func InitialCheck(movement):
	kinebody.move(movement)
	if kinebody.is_colliding():
		return kinebody.get_collider().onInitialCollide(0, movement)
	else:
		return true;

func PreCheck():
	if kinebody.is_colliding():
		return kinebody.get_collider().onPreCollide(0, movement)
	else:
		return true;

func TimeSpawn():
	
	