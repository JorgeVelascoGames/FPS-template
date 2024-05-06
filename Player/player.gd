extends CharacterBody3D
class_name Player


@export var speed = 3.0
@export var fall_multiplier: float = 2.5
@export var camera_sensibility: float = 1.2
@export var aim_multiplier: float = 0.3
@export var can_jump: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Private variables
var mouse_motion := Vector2.ZERO

#Components
@onready var camera_pivot = $CameraPivot
@onready var health: Health = $Components/Health
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu
@onready var ammo_handler: AmmoHandler = $Components/AmmoHandler
@onready var world_camera: Camera3D = $CameraPivot/WorldCamera
@onready var original_world_camera_fov = world_camera.fov
@onready var weapon_camera: Camera3D = $SubViewportContainer/SubViewport/WeaponCamera
@onready var original_weapon_camera_fov = weapon_camera.fov
@onready var state_machine = $StateMachine


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		world_camera.fov = lerp(
			world_camera.fov, original_world_camera_fov * 
			aim_multiplier, 
			delta * 20.0
			) 
		weapon_camera.fov = lerp(
			weapon_camera.fov, original_weapon_camera_fov * 
			aim_multiplier, 
			delta * 20.0
			)
	else:
		world_camera.fov = lerp(
			world_camera.fov, 
			original_weapon_camera_fov, 
			delta * 20.0
			)
		weapon_camera.fov = lerp(
			weapon_camera.fov, 
			original_weapon_camera_fov, 
			delta * 20.0
			)


func _physics_process(delta):
	handle_camera_rotation(delta)
	# Add the gravity.
	process_gravity(delta)


func direction(delta) -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction


func process_gravity(delta):
	if not is_on_floor():
		if velocity.y >=0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier


func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001
		if Input.is_action_pressed("aim"):
			mouse_motion *= aim_multiplier / 2


func handle_camera_rotation(_delta:float) -> void:
	rotate_y(mouse_motion.x * camera_sensibility)
	camera_pivot.rotate_x(mouse_motion.y * camera_sensibility)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO


func _on_health_taken_damage(_dmg: int) -> void:
	damage_animation_player.stop(false)
	damage_animation_player.play("TakeDamage")


func _on_health_health_minimun_reached() -> void:
	game_over_menu.game_over()
