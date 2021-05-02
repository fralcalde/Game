extends BaseWeaponItem
class_name WI_MultiActivate

# Number of PROJECTILE items to activate
export var activate_amount : int

var matrix = []
var activated_amount = 0

func activate():
	activated_amount = 0
	load_next_items_matrix()
	
	var array_num = 0
	while array_num < matrix.size() and array_num < activate_amount:
		for item in matrix[array_num]:
			item.activate()
			activated_amount += 1
		
		array_num += 1


func load_next_items_matrix() -> void:
	matrix.clear()
	
	var items = get_parent().items.duplicate()
	var p = items.find(self)
	
	for i in range(items.size()):
		if i <= p:
			items.remove(i) 
	
	var items_array = []
	for item in items:
		if item is WI_Projectile:
			items_array.append(item)
			matrix.append(items_array)
			items_array = []
		
		if item is WI_StatModifier:
			items_array.append(item)


func end_action():
	# We start by counting this item itself
	var amount_of_items = 1 + activated_amount
	
	emit_signal("increment_slot_pointer", amount_of_items)
