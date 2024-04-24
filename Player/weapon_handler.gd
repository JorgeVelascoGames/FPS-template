extends Node3D

@export var weapon_01: Node3D
@export var weapon_02: Node3D
@export var ammo_handler: AmmoHandler

var current_active_weapon: Node3D

func _ready() -> void:
	equip(weapon_01)
	for child in get_children():
		child.ammo_handler = ammo_handler


func equip(active_weapon: Node3D) -> void:
	for child in get_children():
		if child == active_weapon:
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)
	current_active_weapon = active_weapon
	ammo_handler.update_ammo_label()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_01"):
		equip(weapon_01)
	if event.is_action_pressed("weapon_02"):
		equip(weapon_02)
	if event.is_action_pressed("next_weapon"):
		next_weapon()
	if event.is_action_pressed("last_weapon"):
		next_weapon()


func next_weapon() -> void:
	var index = get_current_index()
	index = wrapi(index + 1, 0, get_child_count())
	equip(get_child(index))


func last_weapon() -> void:
	var index = get_current_index()
	index = wrapi(index - 1, 0, get_child_count())
	equip(get_child(index))


func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible:
			return index
	return 0
