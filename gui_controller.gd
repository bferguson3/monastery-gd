extends Control

var MenuWindow = preload("res://menu_box.tscn")

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
	menu.myFunctions[0].call();
	
	var menu2 = MenuWindow.instantiate()
	add_child(menu2)
	menu2.xPosition = 0.95
	menu2.yPosition = 0.90
	menu2.columns = 1
	menu2.setup(["Ben","♥ 89/ 92", "⌂202/230", "≈ 30/ 30"])
	
	pass



