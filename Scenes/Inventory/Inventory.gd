extends Node
class_name Inventory

export var MAX_WEAPONS = 4 setget set_weapons_array_size
var weapons : Array

func _ready():
	set_weapons_array_size(MAX_WEAPONS)
	GameEvents.weapon_selection_changed(0)


func _input(event):
	if Input.is_action_just_pressed("select_1"):
		inventory_owner_change_weapon(0)
	if Input.is_action_just_pressed("select_2"):
		inventory_owner_change_weapon(1)
	if Input.is_action_just_pressed("select_3"):
		inventory_owner_change_weapon(2)
	if Input.is_action_just_pressed("select_4"):
		inventory_owner_change_weapon(3)


func inventory_owner_change_weapon(slot : int) -> void:
	var new_weapon = load_weapon(slot)
	if get_parent().has_method("set_weapon"):
		if new_weapon != null:
				get_parent().set_weapon(new_weapon)
				GameEvents.weapon_selection_changed(slot)


func set_weapons_array_size(size : int) -> void:
	MAX_WEAPONS = size
	
	for i in range(MAX_WEAPONS):
		if i >= weapons.size():
			weapons.append(null)
	
	GameEvents.inventory_changed(self)


func insert_weapon(wep : Weapon, num : int) -> PackedScene:
	var old_weapon_scene = null
	
	if num in range(MAX_WEAPONS):
		old_weapon_scene = weapons[num]
		var packed_scene = pack_weapon(wep)
		weapons[num] = packed_scene
	
	GameEvents.inventory_changed(self)
	return old_weapon_scene


func save_weapon(weapon : Weapon) -> bool:
	var found_slot = false
	
	for i in range(weapons.size()):
		if weapons[i] == null:
			var packed_scene = pack_weapon(weapon)
			weapons[i] = packed_scene
			found_slot = true
			break
	
	GameEvents.inventory_changed(self)
	return found_slot


func load_weapon(num : int) -> PackedScene:
	var weapon_scene = null
	
	if num in range(MAX_WEAPONS):
		if weapons[num] != null:
			 weapon_scene = weapons[num]
	
	return weapon_scene


func pack_weapon(wep : Weapon) -> PackedScene:
	for child in wep.get_children():
		child.owner = wep
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(wep)
	
	return packed_scene
