extends PlayerState

@onready var camera_3d: Camera3D = $"../../Camera3D"
@onready var original_camera_position: float = camera_3d.position.x
@export var camera_peaking_offset: float = 0.8
@export var peaking_speed: float = 3
@onready var ray_cast_check_cover: RayCast3D = $"../../Camera3D/RayCastCheckCover"


func enter(_msg : ={}) -> void:
	player.stamina.set_resource_neutral()
	player.canMoveAndRotate = false


func update(delta):
	if Input.is_action_pressed("peak_left"):
		lerp_camera_left(delta)
	elif  Input.is_action_pressed("peak_right"):
		lerp_camera_right(delta)
	else:
		lerp_camera_back(delta)


func lerp_camera_right(delta):
	camera_3d.position.x = lerp(camera_3d.position.x, camera_peaking_offset, peaking_speed * delta)


func lerp_camera_left(delta):
	camera_3d.position.x = lerp(camera_3d.position.x, -camera_peaking_offset, peaking_speed * delta)


func lerp_camera_back(delta):
	camera_3d.position.x = lerp(camera_3d.position.x, 0.0, peaking_speed * 5 * delta)
	if is_zero_approx(camera_3d.position.x):
		camera_3d.position.x = 0
		state_machine.transition_to("Idle", {})


func exit() -> void:
	player.canMoveAndRotate = true
