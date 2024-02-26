extends Node
class_name Item

@export var itemName : String
@export var desc : String 

enum item_callbacks { NONE, HEAL_A_WORLD, FIRE_A_BATTLE, HEAL_A_BATTLE }
#enum item_callbacks_battle { NONE, HEAL_A, FIRE_A }

@export var worldCallback : item_callbacks
@export var battleCallback : item_callbacks

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

