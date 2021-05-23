extends KinematicBody2D

export var max_health : int = 100
export var speed : int = 50


var health : int
var velocity = Vector2.ZERO
var enemy = null
onready var state_machine = $StateMachine.get("parameters/playback")
onready var sprite = $Sprite


func _ready():
	health = max_health


func _physics_process(delta):
	var current_state = state_machine.get_current_node()
	
	if current_state != "DIE":
		if enemy and current_state == "IDLE":
			state_machine.travel("CHASE")
		
		if current_state == "CHASE":
			if enemy:
				velocity = position.direction_to(enemy.position) * speed
				velocity = move_and_slide(velocity)
				
				# Flip the sprite if we are moving left.
				sprite.flip_h = velocity.x < 0
			else:
				state_machine.travel("IDLE")


func _on_DetectionArea_body_entered(body):
	if body is Player:
		call_deferred("set_enemy", body)


func _on_DetectionArea_body_exited(body):
	if body == enemy:
		call_deferred("set_enemy", null)


func set_enemy(body : Node2D) -> void:
	enemy = body


func damage(_projectile) -> void:
	health -= _projectile._damage
	$ProgressBar.value = health
	
	if health <= 0:
		die()
	else:
		var current_state = state_machine.get_current_node()
		
		if current_state != "ATTACK":
			state_machine.travel("STAGGER")


func die() -> void:
	state_machine.travel("DIE")

