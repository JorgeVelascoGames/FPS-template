extends PlayerState

class_name Run


func enter(_msg : ={}) -> void:
	player.stamina.set_resource_consuming()


func update(delta):
	if player.process_input(delta) == Vector3.ZERO:
		state_machine.transition_to("Idle", {})
	
#	player._delta += delta
#
#	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.camBobSpeed
#	var objCam = player.originCamPos + Vector3.UP * sin(cam_bob) * player.camBobUpDown * 3
#
#	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	if player._delta > 10:
		player._delta = 0
	
	if Input.is_action_just_released("action_run"):
		state_machine.transition_to("Walk", {})
	
	if !player.is_on_floor():
		state_machine.transition_to("Jump", {})
	
	if Input.is_action_just_pressed("do_jump") and player.can_jump:
		state_machine.transition_to("Jump", {do_jump = true})


func physics_update(delta):
	player.velocity = player.velocity.lerp(player.direction * player.get_speed(self), player.accel * delta)
	player.move_and_slide()
