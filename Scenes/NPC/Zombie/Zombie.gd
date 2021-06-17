extends KinematicBody2D

export var max_health : int = 20
export var speed : int = 50
export var navigation_node_path : NodePath = ".."


var health : int
var velocity = Vector2.ZERO
var enemy : Node2D = null
var melee_damage : int = 10
onready var nav : Navigation2D = get_node(navigation_node_path) as Navigation2D
onready var state_machine = $StateMachine.get("parameters/playback")
onready var sprite = $Sprite
onready var melee_range_area = $Sprite/MeleeRange
onready var hitbox_area = $HitboxComponent
onready var healthbar = $HealthBar
onready var detection_area = $DetectionArea


func _ready():
	health = max_health
	healthbar.max_value = max_health
	healthbar.value = health


func _physics_process(_delta):
	var current_state = state_machine.get_current_node()
	
	if current_state == "CHASE":
		if enemy:
			chase_enemy()
			
			# Flip the sprite if we are moving left.
			if velocity.x < 0:
				sprite.scale = Vector2(-1, 1)
			if velocity.x > 0:
				sprite.scale = Vector2(1, 1)
		else:
			state_machine.call_deferred("travel", "IDLE")


func chase_enemy() -> void:
	var distance = (enemy.get_global_transform().origin - get_global_transform().origin).length()
	if distance > 10:
		if nav:
			var my_pos = get_global_transform().origin
			var enemy_pos = enemy.get_global_transform().origin
			var path = nav.get_simple_path(my_pos, enemy_pos, true)
			
			velocity = position.direction_to(path[1]) * speed
			velocity = move_and_slide(velocity)
			
			# For debugging purposes
#			var line_node = get_node("../../Line2D") as Line2D
#			if line_node:
#				line_node.points = path
		else:
			velocity = position.direction_to(enemy.position) * speed
			velocity = move_and_slide(velocity)


func set_enemy(body : Node2D) -> void:
	enemy = body
	
	if enemy:
		state_machine.call_deferred("travel", "CHASE")
	else:
		state_machine.call_deferred("travel", "IDLE")


func damage(damage_data : Dictionary) -> void:
	print(self, " - Hit with damage_data: ", damage_data)
	health -= damage_data["damage"]
	healthbar.value = health
	
	if health <= 0:
		die()
	else:
		var current_state = state_machine.get_current_node()
		
		if current_state != "ATTACK":
			state_machine.call_deferred("travel", "STAGGER")


func die() -> void:
	state_machine.call_deferred("travel", "DIE")
	healthbar.hide()
	melee_range_area.disconnect("hitbox_entered", self, "_on_MeleeRange_hitbox_entered")
	detection_area.disconnect("body_entered", self, "_on_DetectionArea_body_entered")
	hitbox_area.disconnect("on_hit", self, "_on_HitboxComponent_on_hit")
	sprite.z_index = sprite.z_index - 1


func melee_hit_enemies() -> void:
	for hit_area in melee_range_area.get_overlapping_areas():
		var damage_data = {
			"owner": self,
			"damage": melee_damage
		}
		hit_area.hit(damage_data)


func _on_DetectionArea_body_entered(body):
	if body is Player:
		call_deferred("set_enemy", body)


func _on_DetectionArea_body_exited(body):
	if body == enemy:
		call_deferred("set_enemy", null)


func _on_MeleeRange_hitbox_entered():
	state_machine.call_deferred("travel", "ATTACK")


func _on_HitboxComponent_on_hit(damage_data : Dictionary) -> void:
	damage(damage_data)




