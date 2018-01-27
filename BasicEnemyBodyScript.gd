extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func onInitialCollide(movement):
	return true;

func onPreCollide(id, player):
	if (id == 0):
		return true
	elif (id == 1):
		return false