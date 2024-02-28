# ARM_EQUIP.GD
extends Node

class_name body_equip

var value : monastery.BODY_EQUIP;
	
func set_eqp(e:monastery.BODY_EQUIP):
	value = e

func get_eqp():
	return Monastery.body_equipment[value]

func get_eqp_name():
	return Monastery.body_equipment[value][0]

