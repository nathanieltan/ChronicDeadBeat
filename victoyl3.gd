extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var next_level = "res://Levels/Level4.tscn"

func _ready():
	var tp = find_node("Teleport")
	tp.setState(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass