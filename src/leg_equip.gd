# ARM_EQUIP.GD
extends Node

class_name leg_equip

var value : monastery.LEG_EQUIP;
	
func set_eqp(e:monastery.LEG_EQUIP):
	value = e

func get_eqp():
	return Monastery.leg_equipment[value]

func get_eqp_name():
	return Monastery.leg_equipment[value][0]

