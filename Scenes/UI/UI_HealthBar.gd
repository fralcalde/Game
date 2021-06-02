extends TextureProgress
class_name UI_HealthBar


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("player_initialized", self, "_on_player_initialized")
	GameEvents.connect("player_hit", self, "_on_player_hit")


func _on_player_initialized(player : Player) -> void:
	max_value = player.max_health
	value = player.current_health


func _on_player_hit(health) -> void:
	value = health
