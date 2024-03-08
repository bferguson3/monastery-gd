extends SubViewportContainer

var blurAmount : float = 100.0
var myTime : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	myTime += delta;
	
	blurAmount -= (delta * 50.0)
	self.material.set_shader_parameter("amount", blurAmount)
	
	if(myTime > 1.5):
		self.material.set_shader_parameter("darken", true)
	
	pass
