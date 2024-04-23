extends Node
class_name AmmoHandler

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
	print(ammo_storage[type])
	return true


func has_ammo(type: ammo_type) -> bool:
	if ammo_storage[type] > 0:
		return true
	return false
