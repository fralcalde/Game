extends Node

signal weapon_selection_changed
signal inventory_changed
signal interactable_changed


func inventory_changed(inventory : Inventory) -> void:
	call_deferred("emit_signal", "inventory_changed", inventory)


func interactable_changed(interactable : Node) -> void:
	call_deferred("emit_signal", "interactable_changed", interactable)


func weapon_selection_changed(number : int) -> void:
	call_deferred("emit_signal", "weapon_selection_changed", number)
