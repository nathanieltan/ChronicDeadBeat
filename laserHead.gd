extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var lifeTime = 0.5
var mode = "Vertical"
#func onPreCollide():
#	return true



func _process(delta):
	lifeTime -= delta
	if lifeTime <= 0.0:
		get_node(".").free()
		
func _ready():
	var h = find_node("Horizontal")
	var v = find_node("Vertical")
	var animationPlayer = get_node("AnimationPlayer")
	if mode == "Vertical":
		h.hide()
		v.show()
	elif mode == "Horizontal":
		v.hide()
		h.show()
	animationPlayer.seek(0)
	animationPlayer.play(mode)
	set_process(true)
	# Called every time the node is added to the scene.
	# Initialization here

func d_mode(setting):
	mode = setting