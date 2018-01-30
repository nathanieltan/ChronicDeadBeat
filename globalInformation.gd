extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var lastSceneFileName
var moveArray;
var leveldonum = 0;
const slowtime = .3;
const fasttime = .2;
var animTime = slowtime;

func get_last_scene_name():
	return lastSceneFileName
func set_last_scene_name(input):
	lastSceneFileName = input

func finishLevel(next_level, this_level):
	if leveldonum == 0:
		leveldonum += 1
		animTime = fasttime
		return this_level
		#Run level again, but replay mode
	else:
		leveldonum = 0;
		animTime = slowtime
		return next_level
		#Run next_level, but normal mode

func set_movelist(input):
	moveArray = input;
	
func get_movelist():
	return moveArray

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
