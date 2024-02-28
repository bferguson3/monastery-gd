extends Control
class_name MenuWindow

@export var xPosition : float = 0.05;
@export var yPosition : float = 0.05;

var myX : int;
var myY : int;

var myWidth : int;
var myHeight: int;

var fontSize : int = 14;
var fontScale : float;

@export var columns : int = 2;
var rows : int = 0
var myMenu;
@export var items_list = [];
var myFunctions : Array = [];
var screenRatioY : float;
var screenRatioX : float;
const my_x_res = 200;
const my_y_res = 320;
const my_txt_size = 16
var longest = 0
var originPos;
var rowLens = []
var root;
var idle_ctr : float = 0
const idle_time : float = 2.0

var myType = Monastery.MenuTypes.NONE
var myArrow;

var selectorIndex : int = 0;

func _ready():
	screenRatioY = DisplayServer.window_get_size()[1] / my_x_res;
	screenRatioX = DisplayServer.window_get_size()[0] / my_y_res;
	#print_debug(screenRatioY)
	root = get_tree().get_root()
	root.connect("size_changed", _on_size_changed)
	myArrow = get_node("ArrowContainer")
	#var tc = get_node("TextContainer")
	#originPos = tc.get_position()
	#print_debug(originPos)
	
func link_function(i: int, f:Callable):
	myFunctions[i] = f;
	pass

func setup(ilist:Array):
	fontScale = fontSize / screenRatioY;
	
	items_list = ilist;
	for c in items_list:
		myFunctions.push_back(null)
	
	myX = xPosition * DisplayServer.window_get_size()[0] / (screenRatioX)
	myY = yPosition * DisplayServer.window_get_size()[1] / (screenRatioX)
	
	# Apply text !
	var text = get_node("TextContainer/DialogueText")
	text.clear()
	var totallen = 0
	
	
	if myType != Monastery.MenuTypes.ERROR_WINDOW:
		var p = ""
		var io = 0;
		for _i in items_list:
			text.add_text(' ' + _i)
			text.add_text('  ')
			io += 1 
			if io >= columns:
				io = 0
				rows += 1
				text.add_text("\n")
	else:
		for _i in items_list:
			text.add_text(" " + _i + "\n")
			
	
	# go by each column and find the longest 
	var cio = 0
	while cio < columns:
		var ci = cio
		var _long = 0
		while ci < items_list.size():
			if(_long < items_list[ci].length()):
				_long = items_list[ci].length()
			ci += columns
		cio += 1
		rowLens.push_back(_long)
	for _l in rowLens:
		totallen += _l	
		
	# use that length to determine the width of the box 
	var text_width = fontSize * totallen * 0.7;
	if (myType == Monastery.MenuTypes.ERROR_WINDOW):
		text_width /= rows;
	var tc = get_node("TextContainer")
	var mySz = tc.get_size();
	tc.set_position(Vector2(0 + (screenRatioX), 0 + (screenRatioY + 1)))
	
	set_position(Vector2(myX, myY))
	myArrow.hide();
	
	# set panel and border 
	if(myType != Monastery.MenuTypes.ERROR_WINDOW):
		var cont = get_node("PanelBG")
		cont.set_size(Vector2(text_width - (screenRatioX), fontSize * (rows * 1.2) + screenRatioY))
		var bd = get_node("PanelBorder")
		bd.set_size(cont.get_size())
	else:
		var cont = get_node("PanelBG")
		cont.set_size(Vector2(text_width - (screenRatioX) * 1.5, fontSize * (rows*1.2) + screenRatioY) * 1.5)
		var bd = get_node("PanelBorder")
		bd.set_size(cont.get_size())
	
	pass 
	
	
func _on_size_changed():
	pass
	
func _process(delta):
	if(myType == Monastery.MenuTypes.IDLE_STATUS):
		if Monastery.control_mode == Monastery.ControlModes.NORMAL:
			idle_ctr += delta;
			if idle_ctr > idle_time:
				self.show()
			else:
				self.hide()
		elif Monastery.control_mode == Monastery.ControlModes.MENU_BASE:
			self.show()
		else:
			idle_ctr = 0
			self.hide()
	
	if Monastery.control_mode == Monastery.ControlModes.NORMAL:				
		if(Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up")):
			idle_ctr = 0
		
		
	pass

func move_sel_down():
	myArrow.position.y += my_txt_size
	selectorIndex += 2
	if(selectorIndex >= (columns*rows)):
		selectorIndex -= (columns*rows)
		myArrow.position.y -= (my_txt_size * rows)	
func move_sel_up():
	myArrow.position.y -= my_txt_size
	selectorIndex -= 2
	if(selectorIndex < 0):
		selectorIndex += (columns*(rows))
		myArrow.position.y += (my_txt_size * (rows))
func move_sel_right():
	var width = get_node("PanelBG").get_size().x
	myArrow.position.x += (width * 0.8 / columns)
	selectorIndex += 1 
	if ( selectorIndex % columns == 0 ):
		selectorIndex -= (columns)
		myArrow.position.x = 8
func move_sel_left():
	var width = get_node("PanelBG").get_size().x
	myArrow.position.x -= (width * 0.8 / columns)
	selectorIndex -= 1 
	if (selectorIndex % (columns) != 0): # TODO FIXME BUG WITH MORE THAN 2 COLMS?
		selectorIndex += columns
		myArrow.position.x += (width * 0.8 / columns) * columns
	
func reset_sel():
	selectorIndex = 0
	myArrow.position.x = my_txt_size/2;
	myArrow.position.y = my_txt_size/2 - 4;
