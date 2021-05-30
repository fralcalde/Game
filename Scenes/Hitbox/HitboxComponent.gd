tool
extends Area2D
class_name Hitbox

signal on_hit

export var shape : Shape2D = null setget set_shape

func _ready():
	pass # Replace with function body.


func set_shape(_shape) -> void:
	if !Engine.editor_hint:
		yield(self, "ready")
	
	shape = _shape
	$CollisionShape2D.shape = shape


func hit(damage_data : Dictionary) -> void:
	call_deferred("emit_signal", "on_hit", damage_data)


func _on_HitboxComponent_body_entered(body):
	if body.has_method("get_damage_data"):
		hit(body.get_damage_data())
	if body.has_method("on_collision"):
		body.on_collision(get_parent())
