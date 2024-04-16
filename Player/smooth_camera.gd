extends Camera3D

@export var speed := 60.0
@export var pivot :Node3D


func _physics_process(delta):
	var weight :float = clamp(delta * speed, 0.0, 0.5) 
	
	global_transform = global_transform.interpolate_with(
		get_parent().global_transform, weight
	)
	global_position = get_parent().global_position
