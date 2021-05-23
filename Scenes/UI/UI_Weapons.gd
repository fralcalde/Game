extends HBoxContainer
class_name UI_WeaponsSelect

var selection : int = 0

var item_slot_scene = preload("res://Scenes/UI/UI_ItemSlot.tscn")

func _ready():
	on_weapon_selection_changed(0)
	GameEvents.connect("inventory_changed", self, "on_inventory_changed")
	GameEvents.connect("weapon_selection_changed", self, "on_weapon_selection_changed")


func on_weapon_selection_changed(selected : int) -> void:
	get_child(selection).set_selected(false)
	get_child(selected).set_selected(true)
	selection = selected


func on_inventory_changed(inventory : Inventory) -> void:
	for child in get_children():
		child.queue_free()
	
	for i in range(inventory.weapons.size()):
		var slot = item_slot_scene.instance()
		add_child(slot)
		if i == selection:
			slot.set_selected(true)
		
		var weapon_scene = inventory.load_weapon(i)
		if weapon_scene != null:
			var weapon = weapon_scene.instance()
			slot.set_texture(weapon.texture)
