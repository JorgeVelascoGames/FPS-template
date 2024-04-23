extends Node3D

@export var weapon_01: Node3D
@export var weapon_02: Node3D


func _ready() -> void:
	equip(weapon_01)


func equip(active_weapon: Node3D) -> void:
	for child in get_children():
		if child == active_weapon:
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("weapon_01"):
		equip(weapon_01)
	if Input.is_action_just_pressed("weapon_02"):
		equip(weapon_02)
