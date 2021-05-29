extends KinematicBody2D
class_name Player

onready var state_machine = $StateMachine.get("parameters/playback")
onready var weapon : Weapon = $Weapon
onready var sprite = $AnimatedSprite
onready var inventory : Inventory = $Inventory

var velocity = Vector2.ZERO
export var max_speed = 100
export var dash_multiplier = 2
export var dash_modifier = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.active = true
	inventory.save_weapon(weapon)


func get_movement_input() -> Vector2:
	var current_state = state_machine.get_current_node()
	var input = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		input.y -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("right"):
		input.x += 1
	
	input = input.normalized() 
	
	if input.length() != 0:
		state_machine.travel("MOVE")
	if input.length() == 0:
		state_machine.travel("IDLE")
	
	if Input.is_action_just_pressed("dash"):
		state_machine.travel("DASH")
	
	if current_state == "MOVE" or current_state == "IDLE":
		if Input.is_action_pressed("attack"):
			attack()
	
	return input


func sprite_look_at_mouse() -> void:
	if get_global_mouse_position().x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func sprite_look_at_movement_direction() -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func dash() -> void:
	if velocity.length() == 0:
		velocity = Vector2.RIGHT * max_speed * dash_multiplier
	else:
		velocity = velocity * dash_multiplier


func attack() -> void:
	weapon.attack()


func _physics_process(delta):
	var current_state = state_machine.get_current_node()
	
	if current_state == "IDLE" or current_state == "MOVE":
		sprite_look_at_mouse()
		velocity = get_movement_input() * max_speed
		velocity = move_and_slide(velocity)
		
#		if Input.is_action_just_pressed("interact"):
#			$InteractionComponent.interact()
	
	if current_state == "DASH":
		sprite_look_at_movement_direction()
		var input = get_movement_input()
		velocity = velocity + input * max_speed / 10
		velocity = velocity.normalized() * max_speed * dash_multiplier
		velocity = move_and_slide(velocity)


func damage(_projectile) -> void:
	print(self, " - Player hit by ", _projectile)


func hide_weapon():
	weapon.visible = false


func show_weapon():
	weapon.visible = true


func can_interact():
	var current_state = state_machine.get_current_node()
	return current_state == "IDLE" or current_state == "MOVE"


func set_weapon(wep : PackedScene) -> void:
	weapon.queue_free()
	weapon = wep.instance()
	add_child(weapon)


func _on_HitboxComponent_body_entered(body):
	damage(body)


func _on_HitboxComponent_on_hit(damage_data : Dictionary) -> void:
	print(damage_data)
