extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var lifeTime = 0.5
#func onPreCollide():
#	return true



func _process(delta):
	lifeTime -= delta
	if lifeTime <= 0.0:
		get_node(".").free()
func _ready():
	set_process(true)
	# Called every time the node is added to the scene.
	# Initialization here
