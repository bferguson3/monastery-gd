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
var rows : int = 1
var myMenu;
@export var items_list = [];# = [ "Items", "Equip", "Skills", "Status", "Search", "System" ]
var myFunctions : Array = [];
var screenRatioY : float;
var screenRatioX : float;
const my_x_res = 200;
const my_y_res = 320;
var longest = 0
var originPos;
var rowLens = []
var root;
var idle_ctr : float = 0
const idle_time : float = 2.0

var myType = Monastery.MenuTypes.NONE

func _ready():
	screenRatioY = DisplayServer.window_get_size()[1] / my_x_res;
	screenRatioX = DisplayServer.window_get_size()[0] / my_y_res;
	#print_debug(screenRatioY)
	root = get_tree().get_root()
	root.connect("size_changed", _on_size_changed)
	var tc = get_node("TextContainer")
	originPos = tc.get_position()
	
	
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
	var totallen = 0
	for _l in rowLens:
		totallen += _l	
		
		 
	var text_width = fontSize * totallen * 0.7;
	var tc = get_node("TextContainer")
	var mySz = tc.get_size();
	tc.set_position(Vector2(originPos[0] + (screenRatioX), originPos[1] + (screenRatioY + 1)))
	
	set_position(Vector2(myX, myY))
	
	var cont = get_node("PanelBG")
	cont.set_size(Vector2(text_width - (screenRatioX), fontSize * rows + screenRatioY))
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
				
	if(Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up")):
		if Monastery.control_mode == Monastery.ControlModes.NORMAL:
			idle_ctr = 0

	pass
