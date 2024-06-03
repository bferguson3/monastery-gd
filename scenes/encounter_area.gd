extends Area3D

var myEncounterCtr : float = 0
@export var myEncounterRate : float = 300.0
@export var lowStep : float = 1.0 
@export var highStep : float = 100.0

@onready var heroCon = get_node("../HeroController")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print_debug(get_overlapping_bodies())
	var ovb = get_overlapping_bodies()
	for b in ovb:
		if b == heroCon:
			if(heroCon.movedThisFrame):
				myEncounterCtr += (randf_range(lowStep, highStep)) * delta
				#print_debug(myEncounterCtr)
				if myEncounterCtr > myEncounterRate:
					myEncounterCtr = 0.0
					print_debug("encounter")
					myEncounterRate += (randf_range(-200.0, 400.0))
	pass

func _on_body_entered(body):
	print_debug(body , "entered collision zone")
	if(body == heroCon):
		print_debug("encounter rate: ", myEncounterCtr)
		pass
	pass # Replace with function body.
