extends RigidBody2D
class_name ProjectileR

var _force : Vector2
var _life_time : float = 1.0 # Seconds
var _texture : Texture
#var max_bounce_angle : float = 10.0 # Degrees

onready var _sprite_node = $Sprite
onready var _life_time_node = $LifeTime


func init(force, life_time, texture):
	_force = force
	_life_time = life_time
	_texture = texture


func _ready():
	_sprite_node.texture = _texture
	_life_time_node.start(_life_time)
	
	apply_central_impulse(_force)


func _on_LifeTime_timeout():
	queue_free()


func _on_DamageArea_body_exited(body):
	if body is Player:
		remove_collision_exception_with(body)


func _on_DamageArea_body_entered(body):
	pass
	


func _on_ProjectileR_body_entered(body):
	if not body in get_collision_exceptions() and body.has_method("damage"):
		body.damage()
		queue_free()
