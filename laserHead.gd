extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var lifeTime = 0.5
var originalPos = Vector2(0.0,0.0)
func onPreCollide():
	return true
func shoot(dir):
	var kinebody = get_node("laserHeadBody")
	var stillMoving = true
	var moveSprite = true
	var moveAmount
	var tailScene = load("res://laserTail.tscn")
	#var headSprite = get_node("laserHead")
	while(stillMoving):
		if dir == "up":
			moveAmount = Vector2(0.0,-16.0)
		elif dir == "down":
			moveAmount = Vector2(0.0,16.0)
		elif dir == "left":
			moveAmount = Vector2(16.0,0.0)
		elif dir == "right":
			moveAmount = Vector2(-16.0,0.0)
		kinebody.move(moveAmount)
		if(kinebody.is_colliding()):
			stillMoving = false
			var collidedNode = kinebody.get_collider()
			if(collidedNode.get_name() == "TileMap"):
				kinebody.set_pos(Vector2(0.0,0.0))
				kinebody.move_to(get_global_pos())
				moveSprite = false
		if moveSprite:
			set_pos(get_pos() + moveAmount)
			kinebody.set_pos(Vector2(0.0,0.0))
			var tailNode = tailScene.instance()
			add_child(tailNode)
			tailNode.set_global_pos(originalPos)
			
				
func _process(delta):
	lifeTime -= delta
	if lifeTime <= 0.0:
		get_node("laserHead").free()
func _ready():
	originalPos = get_global_pos()
	print(originalPos)
	# Called every time the node is added to the scene.
	# Initialization here
