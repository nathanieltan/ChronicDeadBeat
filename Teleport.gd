extends Node2D
var active = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var Teleport = get_node("AnimationPlayer")
	if not Teleport.is_playing():
		Teleport.play("Inactive")
	set_process(true)

func _process(delta):
	var Teleport = get_node("AnimationPlayer")
	if not Teleport.is_playing():
		if not active:
			Teleport.play("Inactive")
		else:
			Teleport.play("Active")
			
func toggleState():
	active = (active==false)
	
func setState(state):
	active = state
	
func getState():
	return active