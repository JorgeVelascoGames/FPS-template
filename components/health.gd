class_name Health
extends Node

@export var max_health : int = 100

@onready var current_health : int = max_health

signal taken_damage(dmg: int)
signal health_minimun_reached


func damage(dmg: int) -> void:
	if current_health == 0:
		return
	
	current_health -= dmg
	taken_damage.emit(dmg)
	if current_health <= 0:
		current_health = 0
		die()
	print(current_health)

func die() -> void:
	health_minimun_reached.emit()
