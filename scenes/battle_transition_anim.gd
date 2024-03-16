extends SubViewportContainer

var blurAmount : float = 100.0
var myTime : float = 0.0
var _newshader = preload("res://scenes/depixelizer.gdshader")
var fadeIn = false
var enabled = false
var totalTime : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(enabled):
		myTime += delta;
		totalTime += delta;
		
		if(myTime > 0.75):
			enabled = false
		else:
			if not fadeIn:
				blurAmount -= (delta * 100.0)
				self.material.set_shader_parameter("amount", blurAmount)
			else:
				blurAmount += (delta * 50.0)
				self.material.set_shader_parameter("amount", blurAmount)
		pass
	if(totalTime > 1.5):
		queue_free();	

func set_fade_in():
	fadeIn = true
	self.material.set_shader_parameter("darken", true)
	self.material.set_shader(_newshader)
	self.material.set_shader_parameter("amount", 0)
	myTime = 0.0
	enabled = true
			

func reset_me():
	myTime = 0.0 
	blurAmount = 100.0
	fadeIn = false
