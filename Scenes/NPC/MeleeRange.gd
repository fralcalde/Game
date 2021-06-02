extends Area2D
class_name MeleeRange

signal hitbox_entered

func _physics_process(_delta):
	if get_overlapping_areas():
		emit_signal("hitbox_entered")
