extends BaseWeaponItem
class_name WI_StatModifier

export var fire_rate_mod = -0.5


func activate():
	print(self, " - Changed fire rate from ", get_parent().fire_rate, " to ", get_parent().fire_rate - 0.5)


func end_action():
	var next_items = get_next_items()
	
	# Activate next modifiers until we find a projectile.
	var i = 0
	while not (next_items[i] is WI_Projectile) and i < next_items.size():
		print(next_items[i].get_class())
		next_items[i].activate()
		i += 1
	
	# Activate the projectile
	next_items[i].activate()
	
	# Increment the slot pointer by the amount of activated items.
	# 1 + i + 1 = this node + the amount of mods after + the projectile
	emit_signal("increment_slot_pointer", 1 + i + 1)


func get_next_items() -> Array:
	# Get the array of items FROM the triggered item.
	var items = get_parent().items.duplicate()
	var p = items.find(self)
	
	for i in range(items.size()):
		if i <= p:
			items.remove(i)
	
	return items
