extends RigidBody2D
class_name ProjectileR

export var _force : Vector2
export var _life_time : float = 1.0 # Seconds
export var _texture : Texture
var _damage : int = 10
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


func _on_ProjectileR_body_entered(body):
	if not body in get_collision_exceptions() and body.has_method("damage"):
		body.damage(self)
		queue_free()

func collided(node : Node) -> void:
	print(self, " - Collided with ", node)


func get_damage_data() -> Dictionary:
	return Dictionary()
