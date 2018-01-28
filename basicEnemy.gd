extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var moveArray = [0,1,2,3]
var ind = 0;
var kinebody
var controller;
var TimeWait = 0;
var spawned = false;
const dist = 16;
const animTime = .4;
var travelled = 0;
var movement = Vector2(0.0, 0.0);

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	kinebody = get_node("BasicEnemyBody")
	controller = get_parent()
	set_process(true)
	
func _process(delta):
	controller.DepthChanger(get_node("."))
	if (travelled < dist):
		var moveamount = min(movement.length() * delta / animTime, dist - travelled)
		travelled += moveamount
		set_pos(get_pos() + movement.normalized() * moveamount)
		kinebody.move_to(get_global_pos())
	else:
		set_pos(get_pos().snapped(Vector2(4,4)))

func PreCheck(playerPos): #playerPos is the future position of the player
	
	movement = IntToMove(moveArray[ind])
	var moveOk = true;
	kinebody.move(movement)
	if (kinebody.is_colliding()):
		moveOk = kinebody.get_collider().onPreCollide(1, movement);
	
	if not moveOk:
		movement = Vector2(0.0, 0.0)

	ind += 1;
	if (ind >= moveArray.size()):
		ind = 0
		
func TimeSpawn():
	if TimeWait > 0:
		TimeWait -= 1;
	if TimeWait == 0:
		spawned = true;
		travelled = 0
	kinebody.set_pos(Vector2(0.0, 0.0))

func PostCheck():
	kinebody.move(Vector2(0.0, 0.1))
	#set_pos(get_pos().snapped(Vector2(4,4)))
	#kinebody.set_pos(Vector2(0.0, 0.0))
	if (kinebody.is_colliding()):
		var othernode = kinebody.get_collider().get_parent()
		controller.Explode(get_node("."), othernode);
	pass

func IntToMove(id):
	var animationPlayer = get_node("AnimationPlayer")
	if (id == 0):
		animationPlayer.play("ballUp")
		show_select_spikes([])
		return Vector2(0, -16.0)
	if (id == 1):
		animationPlayer.play("ballRight")
		show_select_spikes([])
		return Vector2(16.0, 0.0)
	if (id == 2):
		animationPlayer.play("ballDown")
		show_select_spikes([])
		return Vector2(0, 16.0)
	if (id == 3):
		animationPlayer.play("ballLeft")
		show_select_spikes([])
		return Vector2(-16.0, 0.0)
	else:
		animationPlayer.play("SpikesUDLR")
		return Vector2(0.0, 0.0)
		
func show_select_spikes(list_of_spikes):
	
	var up = get_node("upSpike")
	var right = get_node("rightSpike")
	var down = get_node("downSpike")
	var left = get_node("leftSpike")
	
	if 1 in list_of_spikes:	
		up.show_spike()
	else:
		up.hide_spike()
	if 2 in list_of_spikes:
		right.show_spike()
	else:
		right.hide_spike()
	if 3 in list_of_spikes:
		down.show_spike()
	else:
		down.hide_spike()
	if 4 in list_of_spikes:
		left.show_spike()
	else:
		left.hide_spike()