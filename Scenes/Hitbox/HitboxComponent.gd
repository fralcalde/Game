tool
extends Area2D
class_name Hitbox

export var shape : Shape2D = null setget set_shape

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_shape(_shape) -> void:
	if !Engine.editor_hint:
		yield(self, "ready")
	
	shape = _shape
	$CollisionShape2D.shape = shape
