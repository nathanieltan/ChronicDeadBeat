extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var timePassed = 0
func _process(delta):
	timePassed += delta
	if Input.is_action_pressed("retry"):
		get_tree().change_scene(get_node("/root/globalInformation").get_last_scene_name())
		
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)