extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var lifeTime = 0.5
func shoot(dir):
	var kinebody = get_node("laserHeadBody")
	var stillMoving = true
	#var headSprite = get_node("laserHead")
	while(stillMoving):
		if dir == "up":
			kinebody.move(Vector2(0.0,-16.0))
		elif dir == "down":
			kinebody.move(Vector2(0.0,16.0))
		elif dir == "left":
			kinebody.move(Vector2(16.0,0.0))
		elif dir == "right":
			kinebody.move(Vector2(-16.0,0.0))
		if(kinebody.is_colliding()):
			stillMoving = false
			var collidedNode = kinebody.get_collider()
			if(collidedNode.get_name() != "TileMap"):
				set_pos(get_pos() + kinebody.get_pos())
		else:
			set_pos(get_pos() + kinebody.get_pos())
			kinebody.set_pos(Vector2(0.0,0.0))
		break
				
func _process(delta):
	lifeTime -= delta
	if lifeTime <= 0.0:
		get_node("laserHead").free()
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
