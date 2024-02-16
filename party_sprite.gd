extends AnimatedSprite3D

@export var myLeader:AnimatedSprite3D
@onready var myCam = get_node("/root/test scene/HeroController/HeroCollider/SVC/SubViewport/MainCamera")
@onready var myController = get_parent()

var stopped 
func _ready():
	pass 

func _process(delta):
	if(Monastery.control_mode == Monastery.ControlModes.NORMAL) and stopped:
		stopped = false 
	if not stopped:
		var myDistance = myController.get_global_position().distance_to(myLeader.get_global_position())
		var direction = (myLeader.get_global_position() - myController.get_global_position()).normalized()
		var camdir = direction * myCam.basis
		var myvelocity = direction.normalized();
		var t = 0.33
		#var speed = 1.2 / myDistance;
		
		if(myDistance > 0.25):
			var n : CharacterBody3D = get_parent() as CharacterBody3D;#.move_and_slide()
			n.velocity = myvelocity;
			n.move_and_slide();
			t = 1
		else:
			t = 0.33
			
		if(abs(camdir.x) > abs(camdir.y)):
			if(camdir.x > 0):
				play("hero2_walk_right", t);
			else:
				play("hero2_walk_left", t);
		else:
			if(camdir.y > 0):
				play("hero2_walk_up", t)
			else:
				play("hero2_walk_down", t)
	else:
		stop()
