extends Node2D
class_name Weapon

export var weapon_name : String
export var texture : Texture 

export var init_fire_rate = 1.0
export var init_reload_time = 1.0
export var capacity = 10
export var init_max_overheat = 100
export var init_dissipate_rate = 1.0

var fire_rate
var reload_time
var max_overheat
var dissipate_rate
var items : Array = []
var current_slot = 0

onready var fire_rate_timer = $FireRateTimer
onready var reload_timer = $ReloadTimer
onready var projectile_spawn = $ProjectileSpawn
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	set_weapon_texture(texture)
	items = get_weapon_items()
	reset_stats()


func attack():
	if fire_rate_timer.time_left <= 0 and reload_timer.time_left <= 0:
		if items.size() == 0:
			# Play no items animation
			return
		
		trigger_item()
		return
	
	# Play not ready to shoot animation


func trigger_item() -> void:
	if current_slot < items.size():
#		print(self, " - Triggering item number ", current_slot)
		items[current_slot].trigger()


func reload() -> void:
	reload_timer.start(reload_time)
#	print(self, " - Reloading!")


func reset_stats() -> void:
	fire_rate = init_fire_rate
	reload_time = init_reload_time
	max_overheat = init_max_overheat
	dissipate_rate = init_dissipate_rate


func get_weapon_items() -> Array:
	var items_list = Array()
	
	for child in get_children():
		if child is BaseWeaponItem:
			items_list.append(child)
			child.connect("increment_slot_pointer", self, "increment_slot_pointer")
	
	return items_list


func add_weapon_item(weapon_item : BaseWeaponItem) -> void:
	if items.size() < capacity:
		add_child(weapon_item)
		get_weapon_items()
	else:
		print(self, " - WARNING: Tried to add a Weapon Item to an already full weapon! Discarded!")


func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	
	sprite.flip_v = mouse_position.x < get_global_transform().origin.x
	
	look_at(get_global_mouse_position())


func _on_FireRateTimer_timeout():
	pass
#	print(self, " - ready to fire!")


func _on_ReloadTimer_timeout():
	current_slot = 0
#	print(self, " - reloaded!")


func increment_slot_pointer(amount : int) -> void:
	current_slot = current_slot + amount
	
	if current_slot >= items.size():
		reload()
	else:
		fire_rate_timer.start(fire_rate)


func set_weapon_texture(tex : Texture) -> void:
	sprite.texture = tex
