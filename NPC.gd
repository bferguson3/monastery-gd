extends AnimatedSprite3D
@export var mySprite : String
@onready var myCam = get_node("../HeroController/HeroCollider/SVC/SubViewport/MainCamera")
@onready var myTalkBubble = get_node("CharacterBody3D/InteractArea/TalkBubble")
@onready var heroSprite = get_node("../HeroController/HeroSprite")
@export var facing : Vector3

@export var myScript : Array
@export var scriptCtr : int = 0

var talkBubbleOpen : bool = false
var stopped
var change_facing : bool
var pscale : float = 4.0

func face_hero():
	facing = (heroSprite.global_transform.origin - global_transform.origin).normalized()
	change_facing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(myTalkBubble.is_visible()):
		var relpos : Vector2 = myCam.unproject_position(self.global_transform.origin)
		myTalkBubble.global_transform.origin = myCam.project_position(Vector2(relpos.x, relpos.y - (24.0 * pscale)), 1.25)
		talkBubbleOpen = true 
	else:
		talkBubbleOpen = false 
	
	if(Monastery.control_mode == Monastery.ControlModes.NORMAL) and stopped:
		stopped = false 
	
	var direction = facing.normalized()
	var camdir = direction * myCam.basis
	var t = 0.33
	
	if (not stopped) or (change_facing):
		if(abs(camdir.x) > abs(camdir.y)):
			if(camdir.x > 0):
				play(mySprite + "_walk_right", t);
			else:
				play(mySprite + "_walk_left", t);
		else:
			if(camdir.y > 0):
				play(mySprite + "_walk_up", t)
			else:
				play(mySprite + "_walk_down", t)
		change_facing = false
	else:
		myTalkBubble.hide()
		stop()
