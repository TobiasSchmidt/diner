extends Node3D

@onready var anim = $Visual/AnimationPlayer

var player = null
var is_talking := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sit()

func sit():
	anim.play("Sit")
	
func interact():
	if is_talking:
		return
	print("Start Dialog...")
	player = get_tree().get_first_node_in_group("player")
	look_at_player()
	# TODO start dialog

func look_at_player():
	var dir = (player.global_position - global_position).normalized()
	var target_rot = atan2(dir.x, dir.z)
	rotation.y = target_rot
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
