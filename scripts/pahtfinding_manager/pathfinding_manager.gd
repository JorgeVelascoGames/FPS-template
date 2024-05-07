extends Node

var player : Player 
var player_position: Vector3


func set_up_player(current_player: Player) -> void:
	player = current_player


func _process(delta):
	if player:
		player_position = player.global_position
		
