class_name Enemy
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var speed = 5.0
const JUMP_VELOCITY = 4.5

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
	var distance = global_position.distance_to(player.global_position)
	var direction: Vector3
	if distance < aggro_range:
		provoke = true
	
	var next_position = navigation_agent_3d.get_next_path_position()
	direction = global_position.direction_to(next_position)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * _delta
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
