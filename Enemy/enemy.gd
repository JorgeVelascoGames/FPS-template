class_name Enemy
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed = 5.0
const JUMP_VELOCITY = 4.5

@export var attack_range: float = 1.5

var player
var provoke := false
@export var aggro_range := 12.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(_delta: float) -> void:
	if provoke:
		navigation_agent_3d.target_position = player.global_position


func _physics_process(_delta: float) -> void:
	movement_process(_delta);


func movement_process(_delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	if distance < aggro_range:
		provoke = true
	
	if provoke and distance < attack_range:
		animation_player.play("Attack")
	
	var next_position = navigation_agent_3d.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * _delta
	
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()


func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	
	look_at(global_position + adjusted_direction, Vector3.UP, true)


func attack() -> void:
	player.health.damage(10)
	print("Enemy Attack!");


func _on_health_health_minimun_reached() -> void:
	queue_free()


func _on_health_taken_damage(_dmg: int) -> void:
	provoke = true
