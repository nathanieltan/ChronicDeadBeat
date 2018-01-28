extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func determine_bounce(direction):
	#	1 is up, 2 is right, 3 is down, 4 is left
	#	Returns 0 if doesn't bounce
	var key = [2, 1, 0, 0]
	return key[direction - 1]