extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var tiles = find_node("Tiles")
	tiles.hide()
	set_process(true)
	
func _process(delta):
	var tiles = find_node("Tiles")
	var tp = find_node("Teleport")
	if is_satisfied():
		tp.setState(true)
		tiles.show()
	else:
		tp.setState(false)
		tiles.hide()
	print(tp.get_global_pos())

func is_satisfied():
	var cont = get_parent()
	var pos = cont.find_node("Pushable").get_global_pos()
	var pos2 = cont.find_node("Button").get_global_pos()
	var diff = pos - pos2
	if diff.length() < 5:
		return true
	else:	
		return false
