extends Area3D

@onready var hero = get_node("../../../HeroController")
@onready var bub = get_node("TalkBubble")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	#print_debug(bodies)
	for b in bodies:
		if b == hero:
			if(not get_parent().get_parent().stopped):
				bub.show()
		else:
			bub.hide()
	pass
