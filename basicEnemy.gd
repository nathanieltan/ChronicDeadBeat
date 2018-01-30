extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#var moveArray = [0, 1]
var ind = 0;
var kinebody
var controller;
var TimeWait = 0;
var spawned = true;
const dist = 16;
var animTime;
var travelled = 0;
var dir = Vector2(0.0, 0.0);
var targ;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	animTime = get_tree().get_root().get_child(0).animTime;
	targ = get_pos()/16;
	kinebody = get_node("BasicEnemyBody")
	controller = get_parent()
	set_process(true)
	
	var animationPlayer = get_node("AnimationPlayer")
	animationPlayer.play("ballCharge")

func _process(delta):
	if (spawned):
		controller.DepthChanger(get_node("."))
		if (travelled < dist):
			var moveamount = min(16 * delta / animTime, dist - travelled)
			travelled += moveamount
			set_pos(get_pos() + dir.clamped(1) * moveamount)
			#kinebody.move_to(get_global_pos())
		else:
			set_pos(get_pos().snapped(Vector2(4,4)))

func PreCheck(playerPos, playerprevpos): #playerPos is the future position of the player
	if spawned:
		targ = get_pos()/16
		#dir = IntToMove(moveArray[ind]);
		dir = Vector2(0.0, 0.0)
		if ind == 0:
			var diff = playerPos - get_pos();
			var moveint = 0;
			if abs(diff.x) > abs(diff.y):
				if (sign(diff.x) == 1):
					moveint = 1
				else:
					moveint = 3
			else:
				if (sign(diff.y) == -1):
					moveint = 0
				else:
					moveint = 2
			dir = IntToMove(moveint);
			var id = controller.CheckNode(targ + dir)
			var test = false;
			if (typeof(id) == 2):
				test = true;
			else:
				test = id.onPreCollide(1, get_node("."));
		
			if test:
				targ += dir
				controller.UpdateNode(0, get_pos()/16)
				controller.UpdateNode(get_node("."), targ)
				print("happened")
			else:
				dir = Vector2(0.0, 0.0)
				#return true
		else:
			dir = IntToMove(-1);
		
		ind += 1;
		if (ind >= 2):
			ind = 0

func TimeSpawn():
	if (spawned):
		travelled = 0
	else:
		get_node(".").hide()

	if (TimeWait > 0):
		TimeWait -= 1;
		targ = get_pos()/16;
	elif (not spawned and TimeWait == 0):
		get_node(".").show()
		var underitem = controller.CheckNode(targ)
		var tmpbool = true;
		
		
		if (typeof(underitem) == 2):
			pass
		elif (not underitem.is_in_group("Button")):
			tmpbool = false;
		
		controller.UpdateNode(get_node("."), targ)
		if not tmpbool:
			controller.Explode(get_node("."), underitem)
		
		spawned = true;
		travelled = 0;
	#kinebody.set_pos(Vector2(0.0, 0.0))

func PostCheck():
	dir = Vector2(0.0, 0.0);
	targ = get_pos()/16
	#kinebody.move(Vector2(0.0, 0.1))
	#set_pos(get_pos().snapped(Vector2(4,4)))
	#kinebody.set_pos(Vector2(0.0, 0.0))
	#if (kinebody.is_colliding()):
	#	var othernode = kinebody.get_collider().get_parent()
	#	controller.Explode(get_node("."), othernode);
	pass

func onInitialCollide(dir):
	return true;

func onPreCollide(id, player):
	if (id == 0):
		return true
	elif (id == 1):
		return false

func IntToMove(id):
	var animationPlayer = get_node("AnimationPlayer")
	if (id == 0):
		animationPlayer.play("ballUp")
		show_select_spikes([])
		return Vector2(0, -1)
	if (id == 1):
		show_select_spikes([])
		animationPlayer.play("ballRight")
		return Vector2(1, 0.0)
	if (id == 2):
		show_select_spikes([])
		animationPlayer.play("ballDown")
		return Vector2(0, 1)
	if (id == 3):
		show_select_spikes([])
		animationPlayer.play("ballLeft")
		return Vector2(-1, 0.0)
	else:
		var up = controller.CheckNode(get_pos()/16 + Vector2(0.0, -1.0))
		var right = controller.CheckNode(get_pos()/16 + Vector2(1.0, 0.0))
		var down = controller.CheckNode(get_pos()/16 + Vector2(0.0, 1.0))
		var left = controller.CheckNode(get_pos()/16 + Vector2(-1.0, 0.0))
		var count = 1;
		var animlist = []
		for direction in [up, right, down, left]:
			var test = false
			if typeof(direction) == 2:
				test = true
			elif (direction.is_in_group("Button") || direction.is_in_group("Player")):
				test = true
				controller.Explode(direction, get_node("."))
			
			if test:
				animlist.append(count)
			count += 1;
		
		show_select_spikes(animlist)
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
