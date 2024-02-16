# monk.gd2
extends Node

class_name monk

@export var myName:String;
@export var level:int;
@export var experience:int;

@export var strength:int;
@export var endurance:int;
@export var agility:int;
@export var wisdom:int;

@export var body:int;
@export var body_max:int;
@export var chi:int;
@export var chi_max:int;
@export var struct:int;
@export var struct_max:int;

@export var unarmed_acc:float;
@export var unarmed_pwr:float;
@export var weapon_acc:float;
@export var weapon_pwr:float;
@export var chi_strike:float;
@export var breath:float;
@export var speed:float;
@export var dodge:float;

# to-hit is (player's _acc) - (enemy's dodge)

# damage calc requires incoming power and current armor 
# NPCs all need armor...

# if(armor < (pwr * 0.25)): 
#	dmg = pwr * 2
# if (armor > (pwr * 4)):
#	dmg = 1
# else: # all other dmg 	
#	dmg = pwr * (pwr / armor*2)


@export var primaryForm : Monastery.FORMS;
@export var secondaryForm : Monastery.FORMS;
@export var weaponForm : Monastery.WEAPONFORMS;
@export var element : Monastery.ELEMENT;
@export var affinity: Monastery.AFFINITY;

@export var total_armor : int;

@export var equip_arm : arm_equip = preload("res://arm_equip.gd").new()
@export var equip_body : body_equip = preload("res://body_equip.gd").new()
@export var equip_leg : leg_equip = preload("res://leg_equip.gd").new()

@export var equip_scroll_a : scroll_equip = preload("res://scroll_equip.gd").new()
@export var equip_scroll_b : scroll_equip = preload("res://scroll_equip.gd").new()

# ORDER OF ASSEMBLY:
# 1. Base stats (on creation)
# 2. Change form 
# 3.  -> set derived stats
# 4.  -> set secondary derived stats 
# 5.  -> set equipment changes
#   -> any changes? goto #2

func make_new(e:Monastery.FORMS):
	# TODO DELETE THIS 
	set_arm(Monastery.ARM_EQUIP.BANDAGE_WRAPS)
	set_scroll_a(Monastery.SCROLL_EQUIP.MASTER_SCROLL)
	# normal creation:
	set_base_stats(e)
	change_form(e, Monastery.FORMS.NONE)
	

func print_stats():
	print_debug("str", strength)
	print_debug("end", endurance)
	print_debug("agi", agility)
	print_debug("wis", wisdom)

func set_base_stats(e:Monastery.FORMS):
	strength = Monastery.base_stats[e][0]
	endurance = Monastery.base_stats[e][1]
	agility = Monastery.base_stats[e][2]
	wisdom = Monastery.base_stats[e][3]

func set_derived_stats():
	unarmed_pwr = (Monastery.stat_formulae[0][0] * strength) + \
		(Monastery.stat_formulae[0][1] * endurance) + \
		(Monastery.stat_formulae[0][2] * agility) + \
		(Monastery.stat_formulae[0][3] * wisdom)
	weapon_pwr = (Monastery.stat_formulae[1][0] * strength) + \
		(Monastery.stat_formulae[1][1] * endurance) + \
		(Monastery.stat_formulae[1][2] * agility) + \
		(Monastery.stat_formulae[1][3] * wisdom)
	unarmed_acc = (Monastery.stat_formulae[2][0] * strength) + \
		(Monastery.stat_formulae[2][1] * endurance) + \
		(Monastery.stat_formulae[2][2] * agility) + \
		(Monastery.stat_formulae[2][3] * wisdom)
	weapon_acc = (Monastery.stat_formulae[3][0] * strength) + \
		(Monastery.stat_formulae[3][1] * endurance) + \
		(Monastery.stat_formulae[3][2] * agility) + \
		(Monastery.stat_formulae[3][3] * wisdom)
	dodge = (Monastery.stat_formulae[4][0] * strength) + \
		(Monastery.stat_formulae[4][1] * endurance) + \
		(Monastery.stat_formulae[4][2] * agility) + \
		(Monastery.stat_formulae[4][3] * wisdom)
	speed = (Monastery.stat_formulae[5][0] * strength) + \
		(Monastery.stat_formulae[5][1] * endurance) + \
		(Monastery.stat_formulae[5][2] * agility) + \
		(Monastery.stat_formulae[5][3] * wisdom)
	chi_strike = (Monastery.stat_formulae[6][0] * strength) + \
		(Monastery.stat_formulae[6][1] * endurance) + \
		(Monastery.stat_formulae[6][2] * agility) + \
		(Monastery.stat_formulae[6][3] * wisdom)
	breath = (Monastery.stat_formulae[7][0] * strength) + \
		(Monastery.stat_formulae[7][1] * endurance) + \
		(Monastery.stat_formulae[7][2] * agility) + \
		(Monastery.stat_formulae[7][3] * wisdom)
	body_max = (Monastery.stat_formulae[8][0] * strength) + \
		(Monastery.stat_formulae[8][1] * endurance) + \
		(Monastery.stat_formulae[8][2] * agility) + \
		(Monastery.stat_formulae[8][3] * wisdom)
	chi_max = (Monastery.stat_formulae[9][0] * strength) + \
		(Monastery.stat_formulae[9][1] * endurance) + \
		(Monastery.stat_formulae[9][2] * agility) + \
		(Monastery.stat_formulae[9][3] * wisdom)
	struct_max = (Monastery.stat_formulae[10][0] * strength) + \
		(Monastery.stat_formulae[10][1] * endurance) + \
		(Monastery.stat_formulae[10][2] * agility) + \
		(Monastery.stat_formulae[10][3] * wisdom)
	
	
func change_form(e:Monastery.FORMS, s:Monastery.FORMS):
	set_derived_stats() # to reset 
	
	primaryForm = e
	#UPWR, WPWR, UACC, DODGE, SPEED, CHISTRIKE, BREATH, STRUC
	unarmed_pwr *= Monastery.form_stat_modifiers[e][0]
	weapon_pwr *= Monastery.form_stat_modifiers[e][1]
	unarmed_acc *= Monastery.form_stat_modifiers[e][2]
	dodge *= Monastery.form_stat_modifiers[e][3]
	speed *= Monastery.form_stat_modifiers[e][4]
	chi_strike *= Monastery.form_stat_modifiers[e][5]
	breath *= Monastery.form_stat_modifiers[e][6]
	struct_max *= Monastery.form_stat_modifiers[e][7]
	
	if(s != Monastery.FORMS.NONE):
		change_secondary_form(secondaryForm)
		
	apply_equip()

func apply_equip_effect(eqp):
	total_armor += int(eqp[2])
	strength += int(eqp[3])
	endurance += int(eqp[4])
	agility += int(eqp[5])
	wisdom += int(eqp[6])
	body_max += int(eqp[7])
	chi_max += int(eqp[8])
	struct_max += int(eqp[9])
	
	unarmed_acc += float(eqp[10])
	unarmed_pwr += float(eqp[11])
	weapon_acc += float(eqp[12])
	weapon_pwr += float(eqp[13])
	chi_strike += float(eqp[14])
	breath += float(eqp[15])
	speed += float(eqp[16])
	dodge += float(eqp[17])

func apply_equip():
	
	apply_equip_effect(equip_arm.get_eqp())
	apply_equip_effect(equip_leg.get_eqp())
	apply_equip_effect(equip_body.get_eqp())
	apply_equip_effect(equip_scroll_a.get_eqp())
	apply_equip_effect(equip_scroll_b.get_eqp())
	
	print_debug("total armor", equip_arm.get_eqp()[2])
	print_debug("total breath", breath)
	
	return

func change_secondary_form(e:Monastery.FORMS):
	# reset
	#change_primary_form(primaryForm)
	secondaryForm = e 
	#UPWR, WPWR, UACC, DODGE, SPEED, CHISTRIKE, BREATH, STRUC
	unarmed_pwr *= ((Monastery.form_stat_modifiers[e][0] + 1.0) / 2.0)
	weapon_pwr *= ((Monastery.form_stat_modifiers[e][1] + 1.0) / 2.0)
	unarmed_acc *= ((Monastery.form_stat_modifiers[e][2] + 1.0) / 2.0)
	dodge *= ((Monastery.form_stat_modifiers[e][3] + 1.0) / 2.0)
	speed *= ((Monastery.form_stat_modifiers[e][4] + 1.0) / 2.0)
	chi_strike *= ((Monastery.form_stat_modifiers[e][5] + 1.0) / 2.0)
	breath *= ((Monastery.form_stat_modifiers[e][6] + 1.0) / 2.0)
	struct_max *= ((Monastery.form_stat_modifiers[e][7] + 1.0) / 2.0)

func level_up():
	var ct = 0
	var f = Monastery.rng.randi_range(1, 100)
	if f > 50:
		strength += 1
		ct += 1
	f = Monastery.rng.randi_range(1, 100)
	if f > 50:
		endurance += 1 
		ct += 1 
	f = Monastery.rng.randi_range(1, 100)
	if f > 50:
		agility += 1 
		ct += 1 
	f = Monastery.rng.randi_range(1, 100)
	if f > 50:
		wisdom += 1 
		ct += 1 
	var so = 0
	while(ct < 5):
		if(Monastery.levelups[primaryForm][so] == Monastery.BASE_STATS.STR):
			strength += 1
		if(Monastery.levelups[primaryForm][so] == Monastery.BASE_STATS.END):
			endurance += 1
		if(Monastery.levelups[primaryForm][so] == Monastery.BASE_STATS.AGI):
			agility += 1
		if(Monastery.levelups[primaryForm][so] == Monastery.BASE_STATS.WIS):
			wisdom += 1
		ct += 1
		so += 1 
	change_form(primaryForm, secondaryForm)
	
func set_arm(i:Monastery.ARM_EQUIP):
	equip_arm.set_eqp(i)
func set_body(i:Monastery.BODY_EQUIP):
	equip_body.set_eqp(i)
func set_leg(i:Monastery.LEG_EQUIP):
	equip_leg.set_eqp(i)
func set_scroll_a(i:Monastery.SCROLL_EQUIP):
	equip_scroll_a.set_eqp(i)
func set_scroll_b(i:Monastery.SCROLL_EQUIP):
	equip_scroll_b.set_eqp(i)


func print_derived_stats():
	print_debug("unarmed pwr", unarmed_pwr)
	print_debug("unarmed acc", 50+unarmed_acc)
	print_debug("weapon pwr", weapon_pwr)
	print_debug("weapon acc", 50+weapon_acc)
	print_debug("dodge", dodge)
	print_debug("speed", speed)
	print_debug("chi strike", chi_strike)
	print_debug("breath", breath)
	print_debug("body", body_max)
	print_debug("chi", chi_max)
	print_debug("structure", struct_max)
