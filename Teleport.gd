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
	if able_to_progress():
		get_tree().change_scene(get_parent().next_level)
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
	
func checkPlayerPos():
	var mother = get_parent()
	var granny = get_parent().get_parent()
	var player_pos = Vector2(0, 0)
	if granny.get_name() == "Game":
		player_pos = granny.find_node("Player").get_global_pos()
	elif mother.get_name() == "Game":
		player_pos = mother.find_node("Player").get_global_pos()
	var pos = get_global_pos()
	var offset = Vector2(0, -8)
	var diff = pos - player_pos - offset
	if diff.length() < 5:
		return true
	else:
		return false
		
func able_to_progress():
	return(checkPlayerPos() and active)