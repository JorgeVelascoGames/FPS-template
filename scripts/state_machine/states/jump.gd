extends PlayerState

@export var can_jump: bool = true

@export var jump_height: float = 1.0


func enter(msg = {}):
	
	if not player.can_jump:
		return
	
	if msg.has("do_jump"):
		player.velocity.y = sqrt(jump_height * 2.0 * player.gravity)


func update(delta):
	if player.is_on_floor():
		state_machine.transition_to("Idle", {})


func _physics_process(delta):
	var direction = player.direction(delta)
	if direction:
		player.velocity.x = direction.x * player.speed 
		player.velocity.z = direction.z * player.speed
		if Input.is_action_pressed("aim"):
			player.velocity.x *= player.aim_multiplier
			player.velocity.z *= player.aim_multiplier
	
	player.move_and_slide()
