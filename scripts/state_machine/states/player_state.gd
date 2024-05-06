extends State

class_name PlayerState


var player : Player


func _ready():
	await owner.ready
	player = owner as Player
	
	assert(player != null, "Invalid state node")
