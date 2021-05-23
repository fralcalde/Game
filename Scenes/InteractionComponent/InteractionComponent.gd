tool
extends Area2D
class_name InteractionComponent

export var interaction_parent : NodePath
export var interaction_area_size : int = 25 setget set_area_size

#signal on_interactable_changed(newInteractable)

var interaction_target : Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact() -> void:
	if interaction_target:
		if interaction_target.has_method("interaction_interact"):
			interaction_target.interaction_interact(get_node(interaction_parent))


func _on_InteractionComponent_body_entered(body):
	var canInteract := false
	
	# GDScript lacks the concept of interfaces, so we can't check wether the body implements an interface
	# Instead, we'll see if it has the methods we need
	if body.has_method("interaction_can_interact"):
		# Interactables tell us wether we're allowed to interact with them
		canInteract = body.interaction_can_interact(get_node(interaction_parent))
	
	if not canInteract:
		return
	
	# Store the thing we'll be interacting with, so we can trigger it from _process
	interaction_target = body
#	emit_signal("on_interactable_changed", interaction_target)
	GameEvents.emit_signal("interactable_changed", interaction_target)


func _on_InteractionComponent_body_exited(body):
	if body == interaction_target:
		interaction_target = null
#		emit_signal("on_interactable_changed", null)
		GameEvents.emit_signal("interactable_changed", interaction_target)


func set_area_size(value : int) -> void:
	if !Engine.editor_hint:
		yield(self, "ready")
	
	interaction_area_size = value
	$CollisionShape2D.shape.radius = interaction_area_size


func _input(event):
	if Input.is_action_just_pressed("interact"):
		if get_node(interaction_parent).has_method("can_interact"):
			if get_node(interaction_parent).can_interact():
				interact()
