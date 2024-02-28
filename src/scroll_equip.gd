# ARM_EQUIP.GD
extends Node

class_name scroll_equip

var value : monastery.SCROLL_EQUIP;
	
func set_eqp(e:monastery.SCROLL_EQUIP):
	value = e

func get_eqp():
	return Monastery.scroll_equipment[value]

func get_eqp_name():
	return Monastery.scroll_equipment[value][0]


