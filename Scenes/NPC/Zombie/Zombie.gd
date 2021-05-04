extends KinematicBody2D

export var max_health : int = 100
export var speed : int = 50


var health : int
var velocity = Vector2.ZERO
var enemy = null
onready var state_machine = $StateMachine.get("parameters/playback")


func _ready():
	health = max_health


func _physics_process(delta):
	var current_state = state_machine.get_current_node()
	
	if current_state == "CHASE":
		velocity = position.direction_to(enemy.position) * speed
		velocity = move_and_slide(velocity)


func _on_DetectionArea_body_entered(body):
	if body is Player:
		enemy = body
		state_machine.travel("CHASE")


func _on_DetectionArea_body_exited(body):
	if body == enemy:
		state_machine.travel("IDLE")


func damage() -> void:
	var current_state = state_machine.get_current_node()
	
	if current_state != "ATTACK":
		state_machine.travel("STAGGER")

