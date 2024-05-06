extends PlayerState

class_name PlayerIdle


func enter(_msg : ={}) -> void:
	player.velocity = Vector3.ZERO


func update(delta):
#Head bob code
#	player._delta += delta
#	var cam_bob = floor(abs(1)+abs(1)) * player._delta * 1
#	var objCam = player.originCamPos + Vector3.UP * sin(cam_bob) * .05
#
#	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	pass


func physics_update(delta: float) -> void:
	if player.direction(delta) != Vector3.ZERO:
		state_machine.transition_to("Walk", {})
		return
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	player.move_and_slide()
