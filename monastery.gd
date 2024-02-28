
extends Node

class_name monastery

enum FORMS { NONE, CRANE, TIGER, MANTIS, MONKEY, BEAR, DEER, EAGLE, BOAR, SNAKE, DRAGON, WHITETIGER, GOLDENSNAKE };
enum WEAPONFORMS { NONE, STAFF, SWORD_DAGGER, SWORD_FAN, TWIN_DAGGER, TWIN_SAI, SINGLE_SWORD, TWIN_NUNCHUK, TWIN_ROD, TWIN_BROADSWORD, CHAINWHIP, SPEAR, KWANDAO };
enum ELEMENT { NONE, FIRE, WATER, WOOD, METAL, EARTH };
enum AFFINITY { YIN, YANG };
enum BODY_EQUIP { NONE, PRACTICE_ROBE };
enum ARM_EQUIP { NONE, BANDAGE_WRAPS };
enum LEG_EQUIP { NONE, STRAW_SANDAL};
enum SCROLL_EQUIP { NONE, MASTER_SCROLL }
enum MenuTypes { NONE, IDLE_STATUS, BASE_MENU, SUB_MENU, ERROR_WINDOW }


enum EQUIP_HEADINGS { 
	NAME,DESCRIPTION,
	ARMOR,
	STR,END,AGI,WIS,
	BODY,CHI,STRUC,
	UACC,UPWR,WACC,WPWR,
	CHIATK,BREATH,SPEED,DODGE
};

enum BASE_STATS { STR, END, AGI, WIS }

var levelups = [
	[ 0, 0, 0, 0, 0 ], # None
	[ BASE_STATS.AGI, BASE_STATS.STR, BASE_STATS.WIS, BASE_STATS.END, BASE_STATS.AGI ], #crane
	[ BASE_STATS.STR, BASE_STATS.END, BASE_STATS.STR, BASE_STATS.AGI, BASE_STATS.END ], #tiger
	[ BASE_STATS.AGI, BASE_STATS.WIS, BASE_STATS.AGI, BASE_STATS.END, BASE_STATS.STR ], #mantis
	[ BASE_STATS.AGI, BASE_STATS.STR, BASE_STATS.AGI, BASE_STATS.END, BASE_STATS.WIS ], #monkey
	[ BASE_STATS.STR, BASE_STATS.END, BASE_STATS.END, BASE_STATS.STR, BASE_STATS.AGI ], #bear
	[ BASE_STATS.AGI, BASE_STATS.WIS, BASE_STATS.WIS, BASE_STATS.AGI, BASE_STATS.STR ], #deer
	[ BASE_STATS.AGI, BASE_STATS.WIS, BASE_STATS.STR, BASE_STATS.END, BASE_STATS.AGI ], #eagle
	[ BASE_STATS.END, BASE_STATS.STR, BASE_STATS.END, BASE_STATS.STR, BASE_STATS.AGI ], #boar
	[ BASE_STATS.AGI, BASE_STATS.AGI, BASE_STATS.WIS, BASE_STATS.WIS, BASE_STATS.END ], #snake
	[ BASE_STATS.WIS, BASE_STATS.STR, BASE_STATS.END, BASE_STATS.AGI, BASE_STATS.WIS ], # dr
	[ BASE_STATS.STR, BASE_STATS.END, BASE_STATS.WIS, BASE_STATS.AGI, BASE_STATS.STR ], # wt
	[ BASE_STATS.AGI, BASE_STATS.STR, BASE_STATS.END, BASE_STATS.WIS, BASE_STATS.AGI ]  # gs
];


var stat_formulae= [ 
[1.0, 0.5, 0.5, 0.0], #UPWR
[1.5, 0.5, 0.75, 0 ], #WPWR
[0.0, 2.5, 0,   1.0], #UACC
[1.0, 2.0, 0,   0.5], #WACC
[0.0, 2.0, 0.0, 0.5], #DODGE
[0,   0.5, 0,    0 ], #SPEED
[0,   0.5, 0,   2.0], #CHISTRIKE
[0.0, 0.0, 0.1,  0.2], #BREATH
[0.4, 0.25,0.6, 0.1], #BODY (HP)
[0.0, 0.35,0.0, 1.25], #CHI (MP)
[0.25,1.0, 0.75,0.25] ]; #STRUC (SHIELD)

var base_stats= [
	[1,1,1,1], #none
	[4,6,5,5], #crane 
	[7,3,7,3], #tiger
	[4,7,3,6], #mantis
	[6,6,4,4], #monkey
	[7,4,6,3], #bear
	[4,6,3,7], #deer 
	[6,4,4,6], #eagle
	[8,4,6,2], #boar
	[3,7,3,7] #snake
];

var form_stat_modifiers = [
#UPWR, WPWR, UACC, DODGE, SPEED, CHISTRIKE, BREATH, STRUC
	[1.0, 1.0, 1,   1,   1,   1,    1,   1],    #none
	[1.2, 0.9, 1.2, 1.2, 1.1, 0.85, 0.8, 0.75], #crane
	[1.4, 1.2, 0.9, 0.7, 0.7, 0.6,  1.2, 1.3],  #tiger
	[1.2, 1.0, 1.2, 1.1, 1.3, 1.0,  0.5, 0.7],  #mantis
	[1.1, 0.8, 1.0, 1.2, 1.3, 1.0, 0.7, 0.9],  #monkey
	[1.3, 1.1, 0.9, 0.8, 0.9, 0.7, 1.0, 1.3],  #bear
	[0.7, 1.2, 1.0, 1.1, 1.2, 0.8, 1.4, 0.6],  #deer
	[1.1, 0.9, 1.3, 1.1, 1.2, 0.5, 1.1, 0.8],  #eagle
	[1.4, 0.6, 1.0, 0.8, 0.8, 0.8, 1.1, 1.5],  #boar
	[0.75, 1.25, 1.0, 1.0, 1.4, 0.6, 1.1, 0.9], #snake
	[1.1, 1.1, 1.1, 1.1, 1.0, 1.2, 1.1, 1.1], #dragon 
	[1.4, 1.2, 1.0, 1.0, 1.0, 1.0, 1.1, 1.3], #white tiger
	[1.0, 1.1, 1.0, 1.0, 1.3, 1.1, 1.3, 1.0]  #golden snake
]

# THESE MUST BE RE-PARSED INTO DATA:
var arm_equipment = [ ];
var arm_equipment_db= [];
var body_equipment = [ ];
var leg_equipment = [ ];
var scroll_equipment = [ ];
var item_db = [];
# THIS IS ALWAYS STRINGS:
var current_scene_script = [ ];

func get_arm_equipment(index):
	return arm_equipment[index]
func get_body_equipment(index):
	return body_equipment[index]
func get_leg_equipment(index):
	return leg_equipment[index]
func get_scroll_equipment(index):
	return scroll_equipment[index]

var rng;
enum ControlModes { NORMAL, WAITING_SCRIPT, ACCEPT_SCRIPT, MENU_BASE, SHOW_FATAL_ERROR }
var control_mode
var activeNPC : Node3D = null;
@export var callbackColumnNo = 3; # TODO VERIFY
enum ItemEnums { NAME,DESCRIPTION,COST,CALLBACK,STACKABLE };

# TODO make this dynamic like item_callbacks.gd!
enum Items { 
	NONE, HERB
};

func get_control_mode():
	return control_mode
	
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	# import csv data files 
	load_csv_dat("res://arm_equip.dat", arm_equipment)
	
	load_csv_dat("res://body_equip.dat", body_equipment)
	load_csv_dat("res://leg_equip.dat", leg_equipment)
	load_csv_dat("res://scroll_equip.dat", scroll_equipment)
	
	load_csv_dat("res://items.dat", item_db)
	
	load_csv_dat("res://scene_test_script.dat", current_scene_script)
	process_scene_script(current_scene_script)
	#print_debug(current_scene_script)
	
	control_mode = ControlModes.NORMAL

func process_scene_script(scr):
	for row in scr:
		var current_scene = get_tree().get_current_scene()
		var n = row[0]
		for node in current_scene.get_children():
			if(node.name.find(n) == 0):
				node.myScript.push_back(row)
				#print_debug("pushed")
			
	pass

func load_csv_dat(path, arr):
	var d = path
	var f = FileAccess.open(d, FileAccess.READ)
	var nextline = f.get_csv_line()
	while(nextline[0] != ""):
		nextline = f.get_csv_line()
		arr.push_back(nextline)
	f.close()
