class_name Hitscan
extends Node3D

@export var weapon_damage: int = 10
@export var fire_rate :float = 14.0
@export var recoil :float = 0.05
@export var weapon_mesh : Node3D
@export var muzzle_flash: GPUParticles3D

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_mesh_init_position : Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if cooldown_timer.is_stopped():
			shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_mesh_init_position, delta * 10.0)


func shoot() -> void:
	muzzle_flash.restart()
	weapon_mesh.position.z += recoil
	cooldown_timer.start(1.0/ fire_rate)
	
	var collider = ray_cast_3d.get_collider()
	for child in collider.get_children():
		if child is Health:
			child.damage(weapon_damage)
