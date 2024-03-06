extends Control

var MenuWindow = preload("res://scenes/menu_box.tscn")

@export var mainMenu : MenuWindow
@export var statusMenu : MenuWindow 
var ew : MenuWindow

const body_icon = '♥'
const struct_icon = '⌂'
const breath_icon = '≈'

func _ITEMS():
	print_debug("Called ITEMS menu option")
	pass

func _ready():
	
	var menu = MenuWindow.instantiate()
	add_child(menu)
	
	menu.xPosition = 0.01
	menu.yPosition = 0.01 
	menu.columns = 2;
	menu.setup(["Items", "Skills ", "Stats", "Scrolls ", "Equip", "Party", "Map  ", "System"])
	
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
	statusMenu.hide()
	
	ew = MenuWindow.instantiate();
	add_child(ew)
	ew.hide();
	
	pass


func show_error_window(txt:Array):
	
	ew.myType = Monastery.MenuTypes.ERROR_WINDOW;
	ew.xPosition = 0.30
	ew.yPosition = 0.40
	ew.columns = 1
	ew.rows = 2
	ew.setup(txt)
	ew.show()
	

	return ew;
	
