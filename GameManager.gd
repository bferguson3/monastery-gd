#game manager

extends Node3D

class_name GameManager

@export var party = []
var event_script
@onready var gui = get_node("../GUI")
@onready var db = get_node("../GUI/DialogueBox")
@onready var txt = db.get_node("TextContainer").get_node("DialogueText")
var _i
var dialoguelen
var script_incrementer : int = 2


#var activeNPC
# ITEM DATABASE?
var item_callbacks = load("res://item_callbacks.gd").item_callbacks

func add_item_to(item : Monastery.Items, me : monk):
	#NAME,DESCRIPTION,COST,CALLBACK,STACKABLE
	var new = Item.new()
	new = Monastery.item_db[item]
	if(me.inventory.size() < 15):
		me.inventory.push_back(new)
	else:
		return false
	#print_debug(me.inventory[0][Monastery.ItemEnums.NAME])
	return true


# Called when the node enters the scene tree for the first time.
func _ready():
	_i = 0
	var i = 8
	while i > 0:
		party.push_back(monk.new())
		i-=1
	party[0].make_new(Monastery.FORMS.CRANE)
	
	if(!add_item_to(Monastery.Items.HERB, party[0])):
		print_debug("failed")
		# todo: add menu UI somesuch here. 
	
	party[1].make_new(Monastery.FORMS.BOAR)
	party[2].make_new(Monastery.FORMS.SNAKE)
	party[3].make_new(Monastery.FORMS.DEER)
	event_script = []


func _process(_delta):
	#print_debug(1.0 / Performance.get_monitor(Performance.TIME_PROCESS))
	# loading an event script triggers this:
	if(event_script != []):
		# WAITING FOR SCRIPT LINE TO DISPLAY:
		if Monastery.control_mode == Monastery.ControlModes.WAITING_SCRIPT:
			# Get the next line of the current NPC row:
			var nt : String
			nt = event_script[Monastery.activeNPC.scriptCtr][script_incrementer]
			# If it is not empty:
			if (nt != ""):
				# Get the length, and display the text row by row using _i as a saved iterator
				dialoguelen = len(event_script[Monastery.activeNPC.scriptCtr][script_incrementer])
				if _i <= dialoguelen:
					txt.text = nt.substr(0, _i)
					_i += 1
				# then wait for input 
				else:
					Monastery.control_mode = Monastery.ControlModes.ACCEPT_SCRIPT
		########
		elif Monastery.control_mode == Monastery.ControlModes.ACCEPT_SCRIPT:
			if(Input.is_action_just_pressed("ui_accept")):
				# reset the display iterator
				_i = 0
				# if the next column is not empty, reset display and wait 
				if(event_script[Monastery.activeNPC.scriptCtr][script_incrementer+1] != ""):
					script_incrementer += 1
					Monastery.control_mode = Monastery.ControlModes.WAITING_SCRIPT
				else: # otherwise, move to the next row on the NPC
					script_incrementer = 2   # incrementer 2 is the actual text
					if(Monastery.activeNPC.scriptCtr < len(event_script) - 1):
						Monastery.activeNPC.scriptCtr += 1
					# and close dialogue mode 
					_i = 0 
					event_script = []
					dialoguelen = 0
					Monastery.activeNPC = null
					Monastery.control_mode = Monastery.ControlModes.NORMAL
					db.hide()
					


func run_callback(item_callbacks):
	match item_callbacks:
		item_callbacks.NONE:
			pass
		item_callbacks.HEALBODY_A:
			pass
	pass

func healbody_a():
	pass
	
func fire_a():
	pass 
	
#-- dmg calc:
#-- dmg = atp * (atp / dfp*2)

#-- if def < 1/4 atp then:
#-- dmg = atp * 2

#-- if def > 4x atp then:
#-- dmg = 1
