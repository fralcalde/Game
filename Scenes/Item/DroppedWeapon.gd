tool
extends StaticBody2D
class_name Dropped_Weapon

export var item_scene : PackedScene setget set_scene

var weapon_name : String

func interaction_can_interact(interactionComponentParent : Node) -> bool:
	return interactionComponentParent is Player


func interaction_get_text() -> String:
	return "pick up weapon" #+ weapon_name


func interaction_interact(interactionComponentParent : Node) -> void:
	print("player interacted")
	
	interactionComponentParent.inventory.save_weapon(item_scene.instance())
	
	queue_free()


func set_up_item(item_scene : PackedScene):
	if item_scene:
		var scene = item_scene.instance() as Weapon
		$Sprite.texture = scene.texture
		weapon_name = scene.weapon_name
	else:
		$Sprite.texture = null


func set_scene(sc : PackedScene) -> void:
	if running():
		yield(self, "ready")
	
	item_scene = sc
	set_up_item(item_scene)


func running() -> bool:
	return !Engine.editor_hint
