extends CharacterBody3D



@export var speed = 5.0
@export var jump_height: float = 1.0
@export var fall_multiplier: float = 2.5
@export var camera_sensibility: float = 1.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Private variables
var mouse_motion := Vector2.ZERO

#Components
@onready var camera_pivot = $CameraPivot
@onready var health: Health = $Components/Health
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	handle_camera_rotation(delta)
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >=0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001


func handle_camera_rotation(delta:float) -> void:
	rotate_y(mouse_motion.x * camera_sensibility)
	camera_pivot.rotate_x(mouse_motion.y * camera_sensibility)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO


func _on_health_taken_damage(dmg: int) -> void:
	damage_animation_player.stop(false)
	damage_animation_player.play("TakeDamage")
