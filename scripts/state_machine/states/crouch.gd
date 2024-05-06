extends PlayerState
class_name  Crouch

@onready var ray_cast_crouch = $"../../RayCasts/RayCastCrouch"
@onready var camera_3d = $"../../Camera3D"
@onready var pcap = $"../../CollisionShape3D"

var hasCrouched = false
@export var crouchSpeed = 20
@export var camera_crouched_position = .1
@export var capsule_crouch_limit = .44

@onready var original_height = pcap.shape.height
@onready var original_camera_position = camera_3d.position.y


func enter(msg = {}):
	hasCrouched = false
	player.stamina.set_resource_neutral()
	player.velocity = Vector3.ZERO


func update(delta):
	if !hasCrouched:
		pcap.shape.height -= crouchSpeed * delta
		camera_3d.position.y = lerp(camera_3d.position.y, camera_crouched_position, crouchSpeed * delta)
		if pcap.shape.height <= capsule_crouch_limit and player.is_on_floor():
			hasCrouched = true
	
	if hasCrouched == false:
		return #Esto previene comportamientos raros antes de que se haya agachado,
		#además de añadir una capa de dificultad
	
	if Input.is_action_just_pressed("interact"):
		player.interact()
		
	if !Input.is_action_pressed("action_crouch") and !ray_cast_crouch.is_colliding():
		pcap.shape.height += crouchSpeed * delta
		camera_3d.position.y = lerp(camera_3d.position.y, original_camera_position, crouchSpeed * delta)
		if pcap.shape.height >= original_height:
			state_machine.transition_to("Idle", {})
	
	if !player.is_on_floor():
		pcap.shape.height = original_height
		camera_3d.position.y = original_camera_position
		state_machine.transition_to("Jump", {})

	
	if Input.is_action_just_pressed("do_jump") and player.can_jump and !ray_cast_crouch.is_colliding():
		pcap.shape.height = original_height
		camera_3d.position.y = original_camera_position
		state_machine.transition_to("Jump", {do_jump = true})


func physics_update(delta):
	player.velocity = player.velocity.lerp(player.direction * player.get_speed(self), (player.accel /2) * delta)
	player.move_and_slide()


func exit() -> void:
	pcap.shape.height = original_height
	camera_3d.position.y = original_camera_position
