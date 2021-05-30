extends KinematicBody2D
class_name ProjectileK

var _direction = Vector2()
var _speed : int = 100
var _life_time : float = 1.0 # Seconds
var _texture : Texture
var _damage : int = 10
var _owner : Node = null
#var max_bounce_angle : float = 10.0 # Degrees

onready var _sprite_node = $Sprite
onready var _life_time_node = $LifeTime


func init(dir : Vector2, speed : int, life_time : float, texture : Texture, projectile_owner : Node):
	_direction = dir
	_speed = speed
	_life_time = life_time
	_texture = texture
	_owner = projectile_owner


func _ready():
	_sprite_node.texture = _texture
	_life_time_node.start(_life_time)


func _on_LifeTime_timeout():
	queue_free()


func _physics_process(delta):
	var velocity = _speed * _direction * delta * 50
	velocity = move_and_slide(velocity)


func on_collision(node : Node) -> void:
	print(self, " - Collided with ", node)


func get_damage_data() -> Dictionary:
	var damage_data = {
		"owner": _owner,
		"damage": _damage
	}
	return damage_data
