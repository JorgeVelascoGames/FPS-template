extends Node
class_name AmmoHandler

@export var ammo_label: Label

enum ammo_type{
	BULLET,
	SMALL_BULLET
}

var ammo_storage := {
	ammo_type.BULLET: 10,
	ammo_type.SMALL_BULLET: 60
}


func use_ammo(type: ammo_type) -> bool:
	if not has_ammo(type):
		return false
	ammo_storage[type] -= 1
	update_ammo_label(type)
	return true


func has_ammo(type: ammo_type) -> bool:
	if ammo_storage[type] > 0:
		return true
	return false


func add_ammo(type: ammo_type, ammount: int) -> void:
	ammo_storage[type] += ammount
	update_ammo_label(type)


func update_ammo_label(type: ammo_type) -> void:
	ammo_label.text = str(ammo_storage[type]) 
