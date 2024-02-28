# ARM_EQUIP.GD
extends Node

class_name arm_equip

var value : monastery.ARM_EQUIP;
	
func set_eqp(e:monastery.ARM_EQUIP):
	value = e

func get_eqp_name():
	return Monastery.arm_equipment[value][0]

func get_eqp():
	return Monastery.arm_equipment[value]
