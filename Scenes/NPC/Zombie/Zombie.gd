extends KinematicBody2D

export var max_health : int = 100
export var speed : int = 50
export var navigation_node_path : NodePath = ".."


var health : int
var velocity = Vector2.ZERO
var enemy = null
var melee_damage : int = 10
onready var nav : Navigation2D = get_node(navigation_node_path) as Navigation2D
onready var state_machine = $StateMachine.get("parameters/playback")
onready var sprite = $Sprite
onready var melee_range_area = $Sprite/MeleeRange
onready var hitbox_area = $HitboxComponent
onready var healthbar = $HealthBar


func _ready():
	health = max_health


func _physics_process(delta):
	var current_state = state_machine.get_current_node()
	
	if current_state != "DIE":
		if enemy and current_state == "IDLE":
			state_machine.travel("CHASE")
		
		if current_state == "CHASE":
			if enemy:
				chase_enemy()
				
				# Flip the sprite if we are moving left.
				sprite.flip_h = velocity.x < 0
			else:
				state_machine.travel("IDLE")


func chase_enemy() -> void:
	if nav:
		var my_pos = get_global_transform().origin
		var enemy_pos = enemy.get_global_transform().origin
		var path = nav.get_simple_path(my_pos, enemy_pos, true)
		
		velocity = position.direction_to(path[1]) * speed
		velocity = move_and_slide(velocity)
		
		# For debugging purposes
		var line_node = get_node("../../Line2D") as Line2D
		if line_node:
			line_node.points = path
	else:
		velocity = position.direction_to(enemy.position) * speed
		velocity = move_and_slide(velocity)


func _on_DetectionArea_body_entered(body):
	if body is Player:
		call_deferred("set_enemy", body)


func _on_DetectionArea_body_exited(body):
	if body == enemy:
		call_deferred("set_enemy", null)


func set_enemy(body : Node2D) -> void:
	enemy = body


func damage(damage_data : Dictionary) -> void:
	print(self, " - Hit with damage_data: ", damage_data)
	health -= damage_data["damage"]
	healthbar.value = health
	
	if health <= 0:
		die()
	else:
		var current_state = state_machine.get_current_node()
		
		if current_state != "ATTACK":
			state_machine.travel("STAGGER")


func die() -> void:
	state_machine.travel("DIE")
	melee_range_area.queue_free()
	hitbox_area.queue_free()
	healthbar.queue_free()


func AttackRange_hit_enemies() -> void:
	for hit_area in melee_range_area.get_overlapping_areas():
		var damage_data = {
			"owner": self,
			"damage": melee_damage
		}
		hit_area.hit(damage_data)


func _on_MeleeRange_area_entered(area):
	state_machine.travel("ATTACK")


func _on_HitboxComponent_on_hit(damage_data : Dictionary) -> void:
	damage(damage_data)

