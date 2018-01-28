extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var timePassed = 0
func _process(delta):
	timePassed += delta
	if timePassed >= 3:
		set_modulate(Color(1,1,1,3*(4-timePassed)/4))
	if timePassed >=7:
		get_tree().change_scene("res://Level1.tscn")
		
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
	
