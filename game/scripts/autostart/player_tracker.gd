extends Node

var player = null
var camera = null

func set_player(p: Node3D) -> void:
	player = p
	camera = p.get_node_or_null("Camera3D")

	if camera == null:
		push_error("PlayerTracker: Camera3D not found on player!")
