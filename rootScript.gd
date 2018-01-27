extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dir = Vector2(0.0, 0.0)
func _process(delta):
	var block_pos = get_node("Player").get_pos()
	dir = Vector2(0.0, 0.0)
	if (Input.is_action_pressed("move_down")):
		dir.y = 1;
	elif (Input.is_action_pressed("move_up")):
		dir.y = -1;
	elif (Input.is_action_pressed("move_right")):
		dir.x = 1;
	elif (Input.is_action_pressed("move_left")):
		dir.x = -1;
		
	block_pos += dir*80*delta
	get_node("Player").set_pos(block_pos)
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
