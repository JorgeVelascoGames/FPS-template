extends PlayerState
class_name Walk

func enter(_msg : ={}) -> void:
	pass


func update(delta):
	if player.direction(delta) == Vector3.ZERO:
		state_machine.transition_to("Idle", {})
	
#   no head bumb
#	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.camBobSpeed
#	var objCam = player.originCamPos + Vector3.UP * sin(cam_bob) * player.camBobUpDown	
#	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if !player.is_on_floor():
		state_machine.transition_to("Jump", {})
	
	if Input.is_action_just_pressed("jump") and player.can_jump:
		state_machine.transition_to("Jump", {do_jump = true})


func physics_update(delta: float) -> void:
	var direction = player.direction(delta)
	print(direction)
	if direction:
		player.velocity.x = direction.x * player.speed
		player.velocity.z = direction.z * player.speed
		if Input.is_action_pressed("aim"):
			player.velocity.x *= player.aim_multiplier
			player.velocity.z *= player.aim_multiplier
	
	player.move_and_slide()
