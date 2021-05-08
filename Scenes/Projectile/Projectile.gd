extends KinematicBody2D
class_name Projectile

var _direction = Vector2()
var _speed : int = 100
var _life_time : float = 1.0 # Seconds
var _texture : Texture
var _damage : int = 10
#var max_bounce_angle : float = 10.0 # Degrees

onready var _sprite_node = $Sprite
onready var _life_time_node = $LifeTime


func init(dir : Vector2, speed : int, life_time : float, texture : Texture):
	_direction = dir
	_speed = speed
	_life_time = life_time
	_texture = texture


func _ready():
	_sprite_node.texture = _texture
	_life_time_node.start(_life_time)


func _on_LifeTime_timeout():
	queue_free()


func _physics_process(delta):
	var velocity = _speed * _direction * delta * 50
	velocity = move_and_slide(velocity)
	


func _on_DamageArea_body_exited(body):
	if body is Player:
		remove_collision_exception_with(body)


func _on_DamageArea_body_entered(body):
	if not body in get_collision_exceptions() and body.has_method("damage"):
		body.damage(self)
		queue_free()
