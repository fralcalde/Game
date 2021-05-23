extends Label
class_name UI_InteractionLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	text = ""
	GameEvents.connect("interactable_changed", self, "on_interactable_changed")


func on_interactable_changed(interactable : Node) -> void:
	if interactable:
		var interactable_text = interactable.interaction_get_text()
		text = "Press " + InputMap.get_action_list("interact")[0].as_text() + " to " + interactable_text
	else:
		text = ""
