extends Node2D
var active = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var controller;

func _ready():
	controller = get_parent().get_parent();
	var Teleport = get_node("AnimationPlayer")
	if not Teleport.is_playing():
		Teleport.play("Inactive")
	set_process(true)

func _process(delta):
	if able_to_progress():
		var level = get_tree().get_root().get_child(0).finishLevel(get_parent().next_level, get_tree().get_current_scene().get_filename())
		print(level)
		get_tree().get_root().get_child(0).set_movelist(controller.movelist);
		get_tree().change_scene(level)
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
	var player_pos = controller.get_node("Player").get_pos()
	#var player_pos = Vector2(0, 0)
	#if granny.get_name() == "Game":
	#	player_pos = granny.find_node("Player").get_global_pos()
	#elif mother.get_name() == "Game":
	#	player_pos = mother.find_node("Player").get_global_pos()
	var pos = get_global_pos()
	var offset = Vector2(0, -8)
	var diff = pos - player_pos - offset
	if diff.length() < 5:
		return true
	else:
		return false
		
func able_to_progress():
	return(checkPlayerPos() and active)