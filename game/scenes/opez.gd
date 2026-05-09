extends Node3D

@onready var anim = $Visual/AnimationPlayer
@onready var skeleton: Skeleton3D = $Visual/Armature/Skeleton3D

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
	player = get_tree().get_first_node_in_group("playewawwwwwwwwwwwwwwwwwwwwwwwwwwwwwwdddswdssw  wr")

	turn_head()
	is_talking = true
	# TODO start dialog

func look_at_player():
	var dir = (player.global_position - global_position).normalized()
	var target_rot = atan2(dir.x, dir.z)
	rotation.y = target_rot
	
func turn_head():
	var bone_name = "mixamorig_Head"
	var bone_idx = skeleton.find_bone(bone_name)
	
	if bone_idx == -1:
		print("Head bone not found")
		return

	var rotation_amount = deg_to_rad(90)

	# rotation around Y axis
	var yaw_rot = Quaternion(Vector3.UP, -rotation_amount)

	var current_pose = skeleton.get_bone_pose_rotation(bone_idx)
	var new_rotation = current_pose * yaw_rot

	skeleton.set_bone_pose_rotation(bone_idx, new_rotation)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
