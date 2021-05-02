extends BaseWeaponItem
class_name WI_ProjectileR

export var _force : int = 100
export var _life_time : float = 1.0
export var _spread : float = 1.0
export var _texture : Texture
var _direction

var projectile = preload("res://Scenes/Projectile/ProjectileR.tscn")

func activate():
	spawn_projectile()


func spawn_projectile():
	var rot = deg2rad(get_parent().rotation_degrees + rand_range(-1.0, 1.0) * _spread)
	var dir = Vector2(cos(rot), sin(rot))
	var final_force = _force * dir
	var new_projectile = projectile.instance()
	new_projectile.init(final_force, _life_time, _texture)
	
	new_projectile.position = get_parent().projectile_spawn.get_global_transform().origin
	new_projectile.add_collision_exception_with(get_parent().get_parent())
	
	get_node("/root").add_child(new_projectile)


func end_action():
	emit_signal("increment_slot_pointer", 1)
	# TODO: Re-set all weapon's stats after firing any projectile!!
