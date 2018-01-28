extends Node2D
var active = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var Teleport = get_node("Teleport")
	if not Teleport.is_playing():
		Teleport.play("TeleportInctive")
	set_process(true)

func _process(delta):
	var Teleport = get_node("Teleport")
	if not Teleport.is_playing():
		if not active:
			Teleport.play("TeleportInactive")
		else:
			Teleport.play("TeleportActive")
			
func toggleState():
	active = (active==false)
	
func setState(state):
	active = state
	
func getState():
	return active