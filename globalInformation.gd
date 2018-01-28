extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var lastSceneFileName

func get_last_scene_name():
	return lastSceneFileName
func set_last_scene_name(input):
	lastSceneFileName = input
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
