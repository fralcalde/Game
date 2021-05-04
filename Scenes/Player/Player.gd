extends KinematicBody2D
class_name Player

onready var state_machine = $StateMachine.get("parameters/playback")
onready var weapon = $Weapon

var velocity = Vector2.ZERO
export var max_speed = 100
export var dash_multiplier = 2
export var dash_modifier = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.active = true


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
#		dash()
	
	if current_state == "MOVE" or current_state == "IDLE":
		if Input.is_action_pressed("attack"):
			attack()
	
	return input


func dash() -> void:
	if velocity.length() == 0:
		velocity = Vector2.RIGHT * dash_multiplier
	else:
		velocity = velocity * dash_multiplier


func attack() -> void:
	weapon.attack()


func _physics_process(delta):
	var current_state = state_machine.get_current_node()
	
	if current_state == "IDLE" or current_state == "MOVE":
		velocity = get_movement_input() * max_speed
		velocity = move_and_slide(velocity)
	
	if current_state == "DASH":
		velocity += get_movement_input() * dash_modifier
		velocity = velocity.linear_interpolate(get_movement_input() * max_speed, 0.25)
		velocity = move_and_slide(velocity)


func damage():
	print(self, " - Player hit!!")
