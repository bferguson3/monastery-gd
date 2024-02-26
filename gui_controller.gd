extends Control

var MenuWindow = preload("res://menu_box.tscn")

@export var mainMenu : MenuWindow
@export var statusMenu : MenuWindow 

const body_icon = '♥'
const struct_icon = '⌂'
const breath_icon = '≈'

func _ITEMS():
	print_debug("Called ITEMS menu option")
	pass

func _ready():
	
	var menu = MenuWindow.instantiate()
	add_child(menu)
	
	menu.xPosition = 0.04
	menu.yPosition = 0.05
	menu.columns = 2;
	menu.setup([" Items", " Skills", " Status", "Scrolls", " Equip", " Party", " Map ", "  System"])
	
	menu.link_function(0, _ITEMS);
	#menu.myFunctions[0].call();
	menu.hide();
	mainMenu = menu;
	
	var menu2 = MenuWindow.instantiate()
	add_child(menu2)
	menu2.myType = Monastery.MenuTypes.IDLE_STATUS;
	menu2.xPosition = 0.95
	menu2.yPosition = 0.90
	menu2.columns = 1
	menu2.setup([" Ben","♥  89/ 92", "⌂ 202/230", "≈  30/ 30"])
	statusMenu = menu2;
	
	pass

