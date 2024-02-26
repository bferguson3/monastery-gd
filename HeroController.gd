extends CharacterBody3D;
# aka PartyController

@export var SPEED = 2.0;
const JUMP_VELOCITY = 3.5;

@onready var mySprite = get_node("HeroSprite"); #$HeroSprite as AnimatedSprite2D
@onready var myCam = get_node("HeroCollider/SVC/SubViewport/MainCamera");
@onready var interactor = get_node("InteractArea")
@onready var GM = get_node("../GameManager")
@onready var p2 = get_node("../PartySprite1")
@onready var p3 = get_node("../PartySprite2")
@onready var p4 = get_node("../PartySprite3")
#@onready var statsWindow : Control = get_node("../GUI/StatBox")
@onready var menuWindow : MenuWindow = get_node("../GUI").mainMenu #get_node("../GUI/MenuBox")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

var rotation_around_point = 90;
var camera_distance = 0.75;
var camera_changed = true;

var stopped = false

var interact_delay = 0.25
var delay_counter = 0.0

var idle_delay = 3.0
var idle_counter = 0.0

func _ready():
	if(p2):
		p2.myLeader = self as CharacterBody3D;
	if(p3):
		p3.myLeader = p2 as CharacterBody3D;
	if(p4):
		p4.myLeader = p3 as CharacterBody3D;
	#menuWindow.hide();
	
func _physics_process(delta):
	
	if (Monastery.control_mode == Monastery.ControlModes.NORMAL) and stopped:
		stopped = false
		delay_counter = 0.0	
	
	# Process interaction delay 
	delay_counter += delta 
	if( Monastery.control_mode == Monastery.ControlModes.NORMAL ):
		idle_counter += delta 
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		#TODO : PARTY FALLING PROPERLY
	
	var aspd = 1.0/3.0;
	
	
	## Control mode: normal 
	
	if Monastery.control_mode == Monastery.ControlModes.NORMAL:
		# Handle jump.
		if Input.is_action_just_pressed("ui_cancel") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# handle camera rotation 
		var rotation_point = mySprite.global_transform.origin;
		if Input.is_key_pressed(KEY_Q):
			rotation_around_point -= 0.02;
			camera_changed = true;
		if Input.is_key_pressed(KEY_E):
			rotation_around_point += 0.02;
			camera_changed = true;
		if camera_changed:
			myCam.global_transform.origin = rotation_point + Vector3(cos(rotation_around_point), 2.0, sin(rotation_around_point))*camera_distance;
			myCam.look_at(mySprite.global_transform.origin);
			camera_changed = false;
			
		## INTERACT 
		if Input.is_action_just_pressed("ui_accept") and (delay_counter > interact_delay):
			idle_counter = 0.0
			var areas = interactor.get_overlapping_areas()
			for a in areas:
				var npc = a.get_parent().get_parent()
				if(npc.name.find("NPC") != -1):
					if(npc.talkBubbleOpen):
						GM.event_script = npc.myScript
						npc.face_hero()
						npc.stopped = true
						stop_all_anim()
						Monastery.control_mode = Monastery.ControlModes.WAITING_SCRIPT
						GM.db.show()
						Monastery.activeNPC = npc
			if Monastery.activeNPC == null:
				if(menuWindow == null):
					menuWindow = get_node("../GUI").mainMenu
				menuWindow.show();
				velocity = Vector3(0.0, 0.0, 0.0)
				Monastery.control_mode = Monastery.ControlModes.MENU_SELECT
			
		## MOVEMENT 
		if Input.is_action_pressed("ui_up"):
			idle_counter = 0.0
			mySprite.play("hero2_walk_up");
			aspd = 1.0
			camera_changed = true
		elif Input.is_action_pressed("ui_down"):
			idle_counter = 0.0
			mySprite.play("hero2_walk_down");
			aspd = 1.0
			camera_changed = true
		elif Input.is_action_pressed("ui_right"):
			idle_counter = 0.0
			mySprite.play("hero2_walk_right");
			aspd = 1.0
			camera_changed = true
		elif Input.is_action_pressed("ui_left"):
			idle_counter = 0.0
			mySprite.play("hero2_walk_left");
			aspd = 1.0
			camera_changed = true
	
		# sprite movement 
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (myCam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED 
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		velocity = velocity.normalized();
		# END: normal control mode 
	
	## control mode menu:
	
	elif(Monastery.control_mode == Monastery.ControlModes.MENU_SELECT):
		if Input.is_action_just_pressed("ui_accept"):
			menuWindow.hide()
			Monastery.control_mode = Monastery.ControlModes.NORMAL
	
	## control mode else :
	
	else: # WAITING_SCRIPT and ACCEPT_SCRIPT ... 
		velocity = Vector3(0.0, 0.0, 0.0)
		
	# animation cleanup
	if not stopped:
		mySprite.play(mySprite.animation, mySprite.speed_scale * aspd)
	else:
		mySprite.stop()
		
	# show stat window 
	#if(idle_counter > idle_delay):
	#	statsWindow.show()
	#else:
	#	statsWindow.hide()
	
	move_and_slide()

func stop_all_anim():
	if(p2):
		p2.stopped = true 
	if(p3):
		p3.stopped = true 
	if(p4):
		p4.stopped = true 
	self.stopped = true 
	
