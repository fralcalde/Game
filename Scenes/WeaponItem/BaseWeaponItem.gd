extends Node
class_name BaseWeaponItem

signal increment_slot_pointer

export var item_name : String
export var description : String


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("ready")


func trigger():
	activate()
	end_action()


func activate():
	pass


func end_action():
	pass
