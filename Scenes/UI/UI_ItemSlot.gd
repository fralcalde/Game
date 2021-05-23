extends CenterContainer
class_name ItemSlot

const selected_color = Color.lightcoral
const unselected_color = Color.webgray

var selected : bool = false
var texture : Texture = null


func _ready():
	update_color()
	update_texture()


func set_selected(_flag : bool) -> void:
	selected = _flag
	update_color()


func set_texture(tex : Texture) -> void:
	texture = tex
	update_texture()


func update_color() -> void:
	if selected:
		$SlotTexture.modulate = selected_color
	else:
		$SlotTexture.modulate = unselected_color


func update_texture() -> void:
	$ItemTexture.texture = texture
